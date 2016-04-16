# How to make multiple pull requests to a forked repository.

## One-time preparation

From inside the forked repository, add a new `remote` pointing to the upstream repo:

```shell
$ git remote add upstream git://github.com/upstream/repo.git
```

Then change the master branch to track `upstream/master`.

```shell
$ git checkout -b anything
$ git branch -D master
$ git checkout --track upstream/master
$ git branch -D anything
```

## Make a pull request

```shell
$ git pull
$ git checkout -b new-changes
$ # make bump changes
$ git commit
$ git push --set-upstream origin new-changes
$ # make PR from browser
$ # wait for PR to be merged
$ git checkout master
$ git branch -D new-changes
```
