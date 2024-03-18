# `pre-commit`

`pre-commit` is a useful tool used by developers to ensure code quality and
consistency before committing changes to Git. It automates the process of
running various checks and tests on your codebase, helping catch potential
issues early on and maintaining a clean and reliable codebase.

More concretely, the `pre-commit` tool is a framework that is capable of
managing and running various multi-language tools, called _hooks_, whenever a
specific [Git hook] runs.

[Git hook]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks

A `.pre-commit-commit.yaml` file, located in the project root dir, defines
exactly which hooks should run, with which arguments, and when.

See our `.pre-commit-commit.yaml` file in the [irnas-zephyr-template]
repository.

[irnas-zephyr-template]: https://github.com/IRNAS/irnas-zephyr-template

In essence, pre-commit will not allow you to create a commit until the codebase
follows our guidelines.

## Setup

To install `pre-commit` run:

```bash
pip install pre-commit
```

### System setup

You can setup your `git` to automatically setup hooks on newly cloned
repository, that uses `pre-commit`.

```bash
git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template
```

If you don't want to do that you can do a repository setup below.

### Repository setup

To make `pre-commit` run before every `git commit` you need to install it into
the repository:

```bash
pre-commit install
```

Every time you clone a project that uses `pre-commit` you should run
`pre-commit install` before doing anything else.

## Expected workflow

Developer's workflow with the `pre-commit` looks something like this:

1. You made some changes to the repository and you have added them with
   `git add` to the staging area.
2. You run `git commit` to commit the files.
3. The `pre-commit` tool automatically runs all hooks on your staged files and
   checks your commit message.
4. If any of the hooks detects that there is a linting error or formatting
   error, it tries to fix it and then reports an error. In cases where files
   were modified by the `pre-commit` hook, you get back the below message:

   ```shell
   prettier.................................................................Failed
   - hook id: prettier
   - files were modified by this hook

   docs/current_consumption.md
   ```

   In other cases where some error is detected, the `pre-commit` will print it
   out.

5. You fix the error, add newly modified files, run `git commit` and see
   `pre-commit` hooks run again.
6. Repeat this until all errors are resolved, at that point, the commit is
   accepted and created.

## Hooks

The following section describes some of the hooks we are using which might
require more knowledge from the developers.

### General `pre-commit` tips

#### Global file exclude

If you have some folders in your repository, which you don't want `pre-commit`
to check you can add `exclude` key to the top level of `.pre-commit-config.yaml`
to filter them out, for example:

```yaml
exclude: some/specific/dir/to/ignore
```

#### Hook specific configuration files

Some hooks have their own configuration files that configure them. Whenever that
is a case, a comment in the `.pre-commit-config.yaml` should mention that.

### `typos`

[`typos`] is a source code spell checker. When used in combination with
`pre-commit` tool finds and fixes spelling mistakes in the source code.

If the spelling solution is non-ambiguous the fix is applied automatically.
Wherever it is ambiguous, as there is more than one solution, it emits an error
message and gives the user a choice of how to resolve it.

If you think that the `typos` tool made an incorrect fix you can change the
`typos.toml` file in the project's directory to correct that.

[`typos`]: https://github.com/crate-ci/typos

Some examples:

```toml
# rsource is a word, so don't correct it
[default.extend-words]
rsource = "rsource"

# some_long_variable_name is a identifier, so don't correct it
[default.extend-identifiers]
some_long_variable_name = "some_long_variable_name"

# Ignore all files ending with *.po in 'localized' folder.
[files]
extend-exclude = ["localized/*.po"]
```

Relevant links:

- [Difference between identifiers and words](https://github.com/crate-ci/typos/blob/master/docs/design.md#identifiers-and-words)
- [Config reference](https://github.com/crate-ci/typos/blob/master/docs/reference.md)

### `markdownlint`

[`markdownlint`] tool is a static analysis tool with a library of rules to
enforce standards and consistency for Markdown files.

[`markdownlint`]: https://github.com/igorshubovych/markdownlint-cli

`markdownlint` checks markdown files in the project folder and, if found, emit
any errors emitted with it.

Each error has a rule number. They are explained in the `markdownlint`
[documentation](https://github.com/DavidAnson/markdownlint?tab=readme-ov-file#rules--aliases).

### `committed`

[`committed`] tool checks if your commit message passes commit guidelines.

If the commit message created with the `git commit` command doesn't pass the
check the `git` will save that message in the `./git/COMMIT_EDITMSG` file.

You can then read the error messages output by the `committed` tool and directly
fix the commit message by using below command:

```bash
git commit -e --file .git/COMMIT_EDITMSG
```

[`committed`]: https://github.com/crate-ci/committed

## Testing and debugging

### Manual runs

To manually run `pre-commit` on all files in the repository you can run:

```bash
pre-commit run --all-files
```

Without the `--all-files` flag `pre-commit` runs only on currently staged files.

To run only a specific hook you can run:

```bash
pre-commit run --all-files <hook-id>
```

For example:

```bash
pre-commit run --all-files clang-format
```

### Testing commit messages

To test if your commit message passes the rules imposed by the `committed` tool,
first add your commit message to a file and then run:

```bash
pre-commit run --hook-stage commit-msg committed --commit-msg-filename <file_with_commit_message>
```

### Skip running pre-commit hooks

Not all hooks are perfect so sometimes you may need to skip execution of one or
more hooks. There are two ways how you can do that.

You can skip all `pre-commit` hooks:

```bash
git commit --no-verify
```

Or you can specify some of them with the `SKIP` environment variable.

```bash
SKIP="markdownlint,typos" git commit --no-verify
```

The `SKIP` environment variable should be a comma separated list of hook ids.
