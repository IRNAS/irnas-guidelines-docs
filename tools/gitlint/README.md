# How to setup gitlint

Gitlint is a git commit message linter written in python: it checks your commit
messages for style.

#### Installation

To install it run below in the terminal:

```bash
pip install gitlint==0.20.0.dev18
```

Specific version is needed as it includes a fix for edit functionality.

#### Basic usage

To check the last commit message:

```bash
gitlint
```

To check the commit message of a specific commit:

```bash
gitlint --commit <commit_hash>
```

#### Configuring gitlint in your project

To make gitlint check your commit messages automatically after each commit you
need to install it as a [git commit-msg hook].

This is done by running the below command inside of your git project:

```bash
gitlint install-hook
```

Additionally, you need to copy `.gitlint` configuration file, which is located
alongside this README, into the root directory of your project.

Gitlint is now used in your project.

#### Important ⚠️

Command `gitlint install-hook` places a specific file inside `.git/hooks`
directory, which runs gitlint automatically after each commit.

`.git` is not considered to be a normal directory inside of a git project, so
**changes inside of it are not tracked**.

This means that:

- Installing a git hook is a project-specific action, other git projects on your
  machine are not affected.
- Git hooks are not persistent. Whenever you clone a new project you have run
  `gitlint install-hook` command.

[git commit-msg hook]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
