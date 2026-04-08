# `prek`

`prek` is a useful tool used by developers to ensure code quality and consistency before committing
changes to Git. It automates the process of running various checks and tests on your codebase,
helping catch potential issues early on and maintaining a clean and reliable codebase.

More concretely, the `prek` tool is a framework that is capable of managing and running various
multi-language tools, called _hooks_, whenever a specific [Git hook] runs.

[Git hook]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks

A `.pre-commit-config.yaml` file, located in the project root dir, defines exactly which hooks
should run, with which arguments, and when.

See our `.pre-commit-config.yaml` file in the [irnas-zephyr-template] repository.

[irnas-zephyr-template]: https://github.com/IRNAS/irnas-zephyr-template

In essence, `prek` will not allow you to create a commit until the codebase follows our guidelines.

<!-- prettier-ignore -->
> [!NOTE]
> `prek` is a faster, drop-in, replacement of `pre-commit`. They both use the same command, same
> configuration file. In the past we use `pre-commit`, now we use `prek`.

## Setup

To install `prek` run:

```bash
pip install prek
```

### System setup

You can setup your `git` to automatically setup hooks on newly cloned repository, that uses `prek`.

```bash
git config --global init.templateDir ~/.git-template
prek init-templatedir ~/.git-template
```

If you don't want to do that you can do a repository setup below.

### Repository setup

To make `prek` run before every `git commit` you need to install it into the repository:

```bash
prek install
```

Every time you clone a project that uses `prek` you should run `prek install` before doing anything
else.

## Expected workflow

Developer's workflow with the `prek` looks something like this:

1. You made some changes to the repository and you have added them with `git add` to the staging
   area.
2. You run `git commit` to commit the files.
3. The `prek` tool automatically runs all hooks on your staged files and checks your commit message.
4. If any of the hooks detects that there is a linting error or formatting error, it tries to fix it
   and then reports an error. In cases where files were modified by the `prek` hook, you get back
   the below message:

   ```shell
   prettier.................................................................Failed
   - hook id: prettier
   - files were modified by this hook

   docs/current_consumption.md
   ```

   In other cases where some error is detected, the `prek` will print it out.

5. You fix the error, add newly modified files, run `git commit` and see `prek` hooks run again.
6. Repeat this until all errors are resolved, at that point, the commit is accepted and created.

## Hooks

The following section describes some of the hooks we are using which might require more knowledge
from the developers.

### General `prek` tips

#### Global file exclude

If you have some folders in your repository, which you don't want `prek` to check you can add
`exclude` key to the top level of `.prek-config.yaml` to filter them out, for example:

```yaml
exclude: some/specific/dir/to/ignore
```

#### Hook specific exclude

You can also exclude files from specific hooks by adding `exclude` key to the hook configuration in
`.pre-commit-config.yaml`. The `exclude` key must be a valid regular expression.

Single entry example:

```yaml
- repo: https://github.com/scop/pre-commit-shfmt
  rev: v3.8.0-1
  hooks:
    - id: shfmt
      stages: [pre-commit]
      exclude: scripts/.*
```

Multiple entry example:

```yaml
- repo: https://github.com/scop/pre-commit-shfmt
  rev: v3.8.0-1
  hooks:
    - id: shfmt
      stages: [pre-commit]
      exclude: |
        (?x)^(
            scripts/codechecker-diff.sh|
            scripts/rpi-jlink-server/request_resource.sh
        )$
```

#### Hook specific configuration files

Some hooks have their own configuration files that configure them. Whenever that is a case, a
comment in the `.prek-config.yaml` should mention that.

### `typos`

[`typos`] is a source code spell checker. When used in combination with `prek` tool finds and fixes
spelling mistakes in the source code.

If the spelling solution is non-ambiguous the fix is applied automatically. Wherever it is
ambiguous, as there is more than one solution, it emits an error message and gives the user a choice
of how to resolve it.

If you think that the `typos` tool made an incorrect fix you can change the `typos.toml` file in the
project's directory to correct that.

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

[`markdownlint`] tool is a static analysis tool with a library of rules to enforce standards and
consistency for Markdown files.

[`markdownlint`]: https://github.com/igorshubovych/markdownlint-cli

`markdownlint` checks markdown files in the project folder and, if found, emit any errors emitted
with it.

Each error has a rule number. They are explained in the `markdownlint`
[documentation](https://github.com/DavidAnson/markdownlint?tab=readme-ov-file#rules--aliases).

### `committed`

[`committed`] tool checks if your commit message passes commit guidelines.

If the commit message created with the `git commit` command doesn't pass the check the `git` will
save that message in the `./git/COMMIT_EDITMSG` file.

You can then read the error messages output by the `committed` tool and directly fix the commit
message by using below command:

```bash
git commit -e --file .git/COMMIT_EDITMSG
```

[`committed`]: https://github.com/crate-ci/committed

## Testing and debugging

### Manual runs

To manually run `prek` on all files in the repository you can run:

```bash
prek run --all-files
```

Without the `--all-files` flag `prek` runs only on currently staged files.

To run only a specific hook you can run:

```bash
prek run --all-files <hook-id>
```

For example:

```bash
prek run --all-files clang-format
```

### Testing commit messages

To test if your commit message passes the rules imposed by the `committed` tool, first add your
commit message to a file and then run:

```bash
prek run --hook-stage commit-msg committed --commit-msg-filename <file_with_commit_message>
```

### Skip running prek hooks

Not all hooks are perfect so sometimes you may need to skip execution of one or more hooks. There
are two ways how you can do that.

You can skip all `prek` hooks:

```bash
git commit --no-verify
```

Or you can specify some of them with the `SKIP` environment variable.

```bash
SKIP="markdownlint,typos" git commit --no-verify
```

The `SKIP` environment variable should be a comma separated list of hook ids.
