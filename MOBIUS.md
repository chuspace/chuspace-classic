# GitLab Shell

## GitLab Shell handles git commands for GitLab

GitLab Shell handles git commands for GitLab and modifies the list of authorized keys.
GitLab Shell is not a Unix shell nor a replacement for Bash or Zsh.

When you access the GitLab server over ssh then GitLab Shell will:

1. Limits you to predefined git commands (git push, git pull).
1. Call the GitLab Rails API to check if you are authorized
1. It will execute the pre-receive hooks (called Git Hooks in GitLab Enterprise Edition)
1. It will execute the action you requested
1. Process the GitLab post-receive actions
1. Process any custom post-receive actions

If you access a GitLab server over http(s) what happens depends on if you pull from or push to the git repository.
If you pull from git repositories over http(s) the GitLab Rails app will completely handle the authentication and execution.
If you push to git repositories over http(s) the GitLab Rails app will not handle any authentication or execution but it will delegate the following to GitLab Shell:

1. Call the GitLab Rails API to check if you are authorized
1. It will execute the pre-receive hooks (called Git Hooks in GitLab Enterprise Edition)
1. It will excute the action you requested
1. Process the GitLab post-receive actions
1. Process any custom post-receive actions

Maybe you wonder why in the case of git push over http(s) the Rails app doesn't handle authentication before delegating to GitLab Shell.
This is because GitLab Rails doesn't have the logic to interpret git push commands.
The idea is to have these interpretation code in only one place and this is GitLab Shell so we can reuse it for ssh access.
Actually GitLab Shell executes all git push commands without checking authorizations and relies on the pre-receive hooks to check authorizations.
When you do a git pull command the authorizations are checked before executing the commands (either in GitLab Rails or GitLab Shell with an API call to GitLab Rails).
The authorization checks for git pull are much simpler since you only have to check if a user can access the repo (no need to check branch permissions).

An overview of the four cases described above:

1. git pull over ssh  -> gitlab-shell -> API call to gitlab-rails (Authorization) -> accept or decline -> execute git command
1. git pull over http -> gitlab-rails (Authorization) -> accept or decline -> execute git command
1. git push over ssh  -> gitlab-shell (git command is not executed yet) -> execute git command -> gitlab-shell pre-receive hook -> API call to gitlab-rails (authorization) -> accept or decline push
1. git push over http -> gitlab-rails (git command is not executed yet) -> execute git command -> gitlab-shell pre-receive hook -> API call to gitlab-rails (authorization) -> accept or decline push

## Code status

[![build status](https://gitlab.com/gitlab-org/gitlab-shell/badges/master/build.svg)](https://gitlab.com/gitlab-org/gitlab-shell/commits/master)
[![Build Status](https://semaphoreapp.com/api/v1/projects/a71ddd46-a9cc-4062-875e-7ade19a44927/243336/badge.svg)](https://semaphoreapp.com/gitlabhq/gitlab-shell)
[![Code Climate](https://codeclimate.com/github/gitlabhq/gitlab-shell.svg)](https://codeclimate.com/github/gitlabhq/gitlab-shell)
[![Coverage Status](https://coveralls.io/repos/gitlabhq/gitlab-shell/badge.svg?branch=master)](https://coveralls.io/r/gitlabhq/gitlab-shell)

## Requirements

**GitLab shell will always use your system ruby (normally located at /usr/bin/ruby) and will not use the ruby your installed with a ruby version manager (such as RVM).**
It requires ruby 2.0 or higher.
Please uninstall any old ruby versions from your system:

```
sudo apt-get remove ruby1.8
```

Download Ruby and compile it with:

```
mkdir /tmp/ruby && cd /tmp/ruby
curl -L --progress http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz | tar xz
cd ruby-2.1.5
./configure --disable-install-rdoc
make
sudo make install
```

## Setup

    ./bin/mobius_install

## Check

    ./bin/mobius_check

## Repos

Add repo:

    ./bin/mobius_repositories add-repository gitlab/gitlab-ci.git

Remove repo:

    ./bin/mobius_repositories rm-repository gitlab/gitlab-ci.git

List repos:

    ./bin/mobius_repositories list-repositories

Import repo:

    # Default timeout is 2 minutes
    ./bin/mobius_repositories import-repository randx/six.git https://github.com/randx/six.git

    # Override timeout in seconds
    ./bin/mobius_repositories import-repository randx/six.git https://github.com/randx/six.git 90

Fork repo:

    ./bin/mobius_repositories fork-repository gitlab/gitlab-ci.git randx

Create tag (lightweight & annotated):

    ./bin/mobius_repositories create-tag gitlab/gitlab-ci.git v3.0.0 3-0-stable
    ./bin/mobius_repositories create-tag gitlab/gitlab-ci.git v3.0.0 3-0-stable 'annotated message goes here'

Gc repo:

    ./bin/mobius_repositories gc gitlab/gitlab-ci.git

## Keys

Add key:

    ./bin/mobius_keys add-key key-782 "ssh-rsa AAAAx321..."

Remove key:

    ./bin/mobius_keys rm-key key-23 "ssh-rsa AAAAx321..."

List all keys:

    ./bin/mobius_keys list-keys


Remove all keys from authorized_keys file:

    ./bin/mobius_keys clear

## Git LFS remark

Starting with GitLab 8.12, GitLab supports Git LFS authentication through ssh.
