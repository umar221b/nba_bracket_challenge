require 'rest-client'
require 'JSON'
require 'axlsx'

last_year = ARGV[0] ? ARGV[0].to_i : 2018

package = Axlsx::Package.new
work_book = package.workbook
work_book.add_worksheet(name: 'Team Stats') do |sheet|
  header = []
  stats = []
  (1996..last_year).each do |year|
    year_str = year.to_s + '-' + (year + 1).to_s[2..3]
    team_stats_url = "https://stats.nba.com/stats/leaguedashteamstats?Conference=&DateFrom=&DateTo=&Division=&GameScope=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=#{year_str}&SeasonSegment=&SeasonType=Regular Season&ShotClockRange=&StarterBench=&TeamID=0&TwoWay=0&VsConference=&VsDivision="
    headers = { 'Accept' => 'application/json, text/plain, */*', 'Accept-Encoding' => 'gzip, deflate, br', 'Accept-Language' => 'en-US,en;q=0.9', 'Connection' => 'keep-alive', 'Cache-Control' => 'no-cache', 'Referer' => 'https://stats.nba.com/teams/traditional/?sort=W_PCT&dir=-1', 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36', 'Host' => 'stats.nba.com', 'Sec-Fetch-Mode' => 'cors', 'Sec-Fetch-Site' => 'same-origin', 'x-nba-stats-origin' => 'stats', 'x-nba-stats-token' => 'true' }
    games_result = RestClient.get(team_stats_url, headers)
    gz = Zlib::GzipReader.new(StringIO.new(games_result.body.to_s))
    uncompressed_string = gz.read
    parsed_string = JSON.parse(uncompressed_string)
    data = parsed_string['resultSets'][0]
    header = ['SEASON'] + data['headers']
    stats += data['rowSet'].map { |stat| [year_str] + stat }
  end

  sheet.add_row(header)
  stats.each do |stat|
    sheet.add_row(stat)
  end
end

package.serialize('team_stats.xlsx')
