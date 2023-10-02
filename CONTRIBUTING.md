# Contributing to mongo-express-docker

Thank you for your contribution. Here are a set of guidelines for contributing to the dmongo-express docker project.

## Version Updates

The folders represent the list of supported major, minor and prerelease version (e.g. `1.0`, `2.1` or `1.1.0-alpha`). To update these versions, run `./update.sh`. You can also run the script with a specific version e.g. `update 1.0`.

### Submitting a PR for a version update

If you'd like to help us by submitting a PR for a version update, please do the following:

1. [Fork this project.](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
1. [Clone the forked repository.](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository)
1. Create a branch for the update PR. For example, `git checkout main; git checkout -b version-update`.
1. Run `./update.sh`.
1. Commit the modified files to the `version-update` branch and push the branch to your fork.
1. [Create a PR to merge the branch from your fork into this project's default branch.](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork).