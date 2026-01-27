# git-stack Tools

A collection of command-line tools for managing stacked Git branches and pull/merge requests. These
tools are meant to be used alongside Graphite's `gt` tool, specifically they replace the `gt submit`
and `gt sync` commands.

The commands work seamlessly with repos hosted both on GitHub and GitLab.

## Installation and updating

To install or update the commands copy below line into the terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/irnas/irnas-guidelines-docs/refs/heads/main/tools/git_stack/install.sh | bash
```

## Dependencies

The scripts require the following tools to be installed:

### Required

- **git** - Version control system (assumed to be installed)
- **jq** - JSON processor for parsing API responses
- **Graphite CLI (gt)** - For managing stacked branches
- **GitHub CLI (gh)** - Required for GitHub repositories
- **GitLab CLI (glab)** - Required for GitLab repositories

The installer will check for all dependencies and provide installation instructions for any that are
missing.

## Usage

Once the commands are installed they are available as part of the regular `git` commands.

The users are expected to use the `gt` commands and usual `git` commands as part of their workflow.
Once a stack of branches is ready for the review, the `git stack-submit` should be used to submit
them automatically instead of `gt submit`.

Whenever an update of the trunk branch is needed, the `git sync` command should be used instead of
`gt sync`.

Both commands include long help description on when and how to use them so check them out:

```bash
git stack-submit -h
git sync -h
```
