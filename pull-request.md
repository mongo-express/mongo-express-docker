# make a pull request to the official images repo

```shell
$ git pull
$ git checkout -b mongo-express
$ # make bump changes
$ git commit
$ git push --set-upstream origin mongo-express
$ # make PR from browser
$ # wait for PR to be merged
$ git checkout master
$ git branch -D mongo-express
```
