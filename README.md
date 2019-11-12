# cse450_endless_frogger

**To create and push a feature:**
- Create a feature branch from develop:
  - Make sure you are on develop first: `git checkout develop`.
  - Create a feature branch: `git checkout -b feature/feature_name`, replace feature_name with a descriptive but short name for your feature.
- Do your work on the created branch, and commit your changes in small chunks of related changes. Do not make commits too big.
- When the feature is done and functioning without problems, push it to github using: `git push origin feature_branch_name`, replace feature_branch_name with the name of the feature branch.
- Create a pull request to merge that branch to develop:
  - **Select develop as the base branch.**
  - Select your branch as the compare branch.
- Save the pull request and request review from team members.


**To review someone's feature:**
Either see the changes on Github or pull the changes to your local machine as follows:
- After they push their branch and create a pull request, run the following command on your local machine to make your repository up to date with the remote repository on github: `git fetch`.
- Run `git pull origin feature_branch_name`, replace feature_branch_name with the name of the feature branch.
- Switch to the new branch: `git checkout feature_branch_name`, replace feature_branch_name with the name of the feature branch.
- You know have their code locally, you can look through it as you like.
- When ready, give your review on github by either approving the changes or requesting changes.
