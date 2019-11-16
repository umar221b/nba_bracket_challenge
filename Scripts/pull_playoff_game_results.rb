require 'axlsx'
require 'mechanize'

last_year = ARGV[0] ? ARGV[0].to_i : 2019

mechanize = Mechanize.new

package = Axlsx::Package.new
work_book = package.workbook

header = ['Year', 'Round', 'Round Without Conference', 'Game Number in Series', 'Game Date', 'Home Team', 'Home Team Score', 'Away Team', 'Away Team Score']
stats = []

(1997..last_year).each do |year|
  link = "https://www.basketball-reference.com/playoffs/NBA_#{year}.html"
  page = mechanize.get(link)
  playoffs_table_rows = page.search('#all_playoffs > tbody > tr:not(.thead)')

  round = nil;
  round_without_conference = nil;
  playoffs_table_rows.each_with_index do |playoff_series, i|
    if i % 2 == 0
      round = playoff_series.search('strong').text.strip
      round_without_conference = round.gsub('Western ', '').gsub('Eastern ', '')
      next
    end
    games = playoff_series.search('tr')
    games.each do |game|
      game_data = game.search('td')
      game_number = game_data[0].text.strip[-1].to_i
      game_date = Time.parse(game_data[1].text.strip + " #{year}").to_date.to_s
      away_team = game_data[2].text.strip
      away_team_score = game_data[3].text.strip.to_i
      home_team = game_data[4].text.strip[2..-1]
      home_team_score = game_data[5].text.strip.to_i

      stats << [year, round, round_without_conference, game_number, game_date, home_team, home_team_score, away_team, away_team_score]
    end
  end
end

work_book.add_worksheet(name: 'Playoff Games') do |sheet|
  sheet.add_row(header)
  stats.each do |stat|
    sheet.add_row(stat)
  end
end

package.serialize('playoff_games.xlsx')
