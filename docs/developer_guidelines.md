# Developer guidelines

## Table of Contents 📜

<!-- vim-markdown-toc GFM -->

- [Developer guidelines](#developer-guidelines)
  - [Table of Contents 📜](#table-of-contents-)
  - [Commits 📌](#commits-)
    - [Message style](#message-style)
      - [Short](#short)
      - [Full](#full)
    - [Commit and message content](#commit-and-message-content)
  - [Coding standards 📚](#coding-standards-)
    - [C/C++ 🇨](#cc-)
      - [Source code documentation](#source-code-documentation)
      - [Doxygen guidelines](#doxygen-guidelines)
      - [Coding style](#coding-style)
      - [Include statements](#include-statements)
    - [Python 🐍](#python-)
      - [Coding standard](#coding-standard)
      - [Coding style](#coding-style-1)
      - [Docstrings](#docstrings)
    - [Rust 🦀](#rust-)
      - [Coding style](#coding-style-2)
      - [Doc comments](#doc-comments)
    - [JavaScript/TypeScript 🇯🇸 / 🇹🇸](#javascripttypescript---)
      - [General guidelines](#general-guidelines)
      - [Coding standard](#coding-standard-1)
      - [Coding style](#coding-style-3)
      - [Docstrings](#docstrings-1)
    - [Short scripts in various languages 💣](#short-scripts-in-various-languages-)
      - [Documentation](#documentation)
      - [Shebang lines](#shebang-lines)

<!-- vim-markdown-toc -->

## Commits 📌

This section outlines general guidelines to follow when making commits and
writing commit messages.

A lot has been said on this topic, so it is best to refer to external resources
and then highlight important points.

Resources:
* [Source control commit guidelines by Embedded Artistry] - The main resource
  related to the commit content and message content. **Read this first, before
  reading the rest**.
* [One Idea is One Commit] - Interesting committing strategy, comparable to
  atomic commits.

Use the `gitlint` tool to check your commit messages. See
[tools/gitlint/README.md] for more information.

### Message style

There are two possible styles for the commit messages: short and full.

#### Short

Short commit messages should be around 50 characters long, the maximum is 72.

Use this when the change that you made is either:
* self-explanatory, for example: `Fix typo in README.md` or
* there is a GitHub issue that provides sufficient context for the change made.

Mention relevant GitHub issues at the end of the message, for example:
* `Fix out of bounds bug, closes #123`
* `Add shell module, relevant #456`

#### Full

Whenever the change you made needs more context you should use full message
format.

The full message format is best summarized with the below rules:

* Separate subject from body with a blank line.
* Limit the subject line to 50 characters.
* Capitalize the subject line.
* Do not end the subject line with a period.
* Use the imperative mood in the subject line.
* Wrap the body at 72 characters.

Below is a visual representation of the full message format:

```
Summarize changes in around 50 characters or less

More detailed explanatory text, can be only a sentence or two.
Wrap it to about 72 characters or so, editors like Visual Studio
Code and Vim do this automatically. Treat the first line as the
subject of the commit and the rest of the text as the body. The
blank line separating the summary from the body is critical
(unless you omit the body completely); various tools like `log`,
`shortlog` and `rebase` can get confused if you run the two
together.

Explanatory text can be split into several paragraphs.

You can also include bullet points:
* A
* B
* C

Optionally, reference relevant GitHub issues at the bottom,
like this:

Resolves: #123
See also: #456, #789
```

### Commit and message content

The below sections are copied directly from [Source control commit guidelines by
Embedded Artistry].

About content of the commits:

> 1. All changes in a commit should be related.
>    * Don’t combine changes that address different problems into a single
>      commit.
> 2. All changes in a commit should address a single aspect of a problem or
>    change.
>    * Don’t be afraid to break up a new feature, bug fix, or refactoring
>      effort into multiple distinct changes.
>    * This will help you keep track of what works and what doesn’t: if there’s
>      a problem, you can always revert to the last known good state. If you
>      wait too long between commits, you may lose a lot of work or spend too
>      long finding the source of the problem.
> 3. Prefer small commits to large commits.
>    * This helps reviewers by allowing them to focus on a small set of related
>      changes.
>    * This helps future debugging efforts by increasing the probability that a
>      git bisect operation will quickly identify the source of the problem.

About content of the commits messages:

> Most importantly, the commit message body should be used to explain what you
> are doing and why you did it that way, rather than how you did it. The code
> itself serves to explain the how. Focus on side effects, compatibility
> changes, or other consequences that are not immediately obvious from
> reviewing the code. Also include any important factors that helped you arrive
> at your particular approach.
>
> Not all commit messages require both a subject and a body. You can include
> only a subject if it is sufficient for a given commit.

## Coding standards 📚

### C/C++ 🇨

#### Source code documentation

The following section has been adapted from the [Patterns in the Machine] book
and the [Google's Python Style Guide], section _3.8 Comments and Docstrings_.

Considers header files to be “data sheets”. In the header files, you want to
summarize:
* what the function does,
* what are its inputs and outputs,
* what are the required preconditions and
* what are the possible side effects.

The goal is that comments provide enough information to the programmer so that
he can use the module without reading its implementation. Do not document
implementation details in the header files, unless those details are relevant to
how the function should be used (try to avoid this if you can). Do not duplicate
information in multiple places in the code.

Concretely this means:
* Describe the module at the top of the header file. Optionally, add a brief
  description of functions and/or usage examples. If documenting a driver level
  module, include a link to the datasheet and mention relevant sections. See
  [template files] in this repository for examples.
* Document all externally visible constructs in the header files. Always comment
  functions, function-like macros, structs and enums. You can omit comments of
  macro defines and constants if their use and meaning are obvious.
* Don't document internally visible static functions, or function-like macros if
  they are very short and obvious. The same goes for the structs, enum, and
  macro defines.
* Add single or multi-line comments before tricky or non-obvious parts in code.
  Describe what and why the code is trying to do, not how is doing it.

See the below snippet for an example of good documentation from the Zephyr
codebase:
```c
/**
 * @brief Lock a mutex.
 *
 * This routine locks @a mutex. If the mutex is locked by another thread,
 * the calling thread waits until the mutex becomes available or until
 * a timeout occurs.
 *
 * A thread is permitted to lock a mutex it has already locked. The operation
 * completes immediately and the lock count is increased by 1.
 *
 * Mutexes may not be locked in ISRs.
 *
 * @param mutex Address of the mutex.
 * @param timeout Waiting period to lock the mutex,
 *                or one of the special values K_NO_WAIT and
 *                K_FOREVER.
 *
 * @retval 0 Mutex locked.
 * @retval -EBUSY Returned without waiting.
 * @retval -EAGAIN Waiting period timed out.
 */
__syscall int k_mutex_lock(struct k_mutex *mutex, k_timeout_t timeout);
```

#### Doxygen guidelines

For documenting the code constructs use [Doxygen] style comments. The structure
of these is defined by [nRF Connect SDK's Doxygen guidelines]. Follow these
guidelines completely, except for the _File headers and groups_ section, for an
example of a file header refer to the `c_cpp_template.h` file.

#### Coding style

Follow [Zephyr's Coding Style]. Zephyr's Coding Style generally follows of a
[Linux kernel coding style] with few exceptions.

Almost all sections in the Linux kernel coding style are relevant to firmware
programming, some might need minor changes to become relevant:
* [Printing kernel messages] - Replace kernel messages with log messages.
* [Allocating memory] - Contains mentions of kernel specific memory allocators,
  but, the advice still applies.
* [The inline disease] - Again, somewhat kernel specific, we rarely use `inline`
  keyword in our code, but, the advice still applies.

#### Include statements

Include statements should be placed at the top of the file, after the license
header and before any other code. In header files, they should be placed after
header guards and `extern C` guards.

Include only what is necessary to compile the source code. Adding unnecessary
includes means a longer compilation time, especially in large projects. Each
header and corresponding source file should compile cleanly on its own. That
means, if you have a source file that includes only the corresponding header, it
should compile without errors. The header file should include not more than what
is necessary for that.

Include statements belonging to the same include group should be written
together with no space in the between, ordered alphabetically(`clang-format`
does this for you). Different include groups should be separated by a single
empty line.

Include groups should be ordered from top to bottom following the below list:
1. Corresponding header file
2. Header files from the project's codebase
3. Header files from SDK's codebase
4. System header files such as `stdio.`, `stddef.`, `string.h` and others
5. C/C++ implementation files (rarely needed, but it can happen)

Of course header files themselves do not include themself.

Below is an example for `ui.c` file:

```c
/* Corresponding header file */
#include "ui.h"

/* Header files from project's codebase */
#include <event/event_def.h>
#include <event/event_mgmt.h>
#include <misc/utility.h>

/* Header files from SDK's codebase */
#include <nrf_delay.h>
#include <nrf_gpio.h>

/* System header files */
#include <stdint.h>
#include <string.h>
```

With proposed ordering where includes are grouped from local to global is easy
to detect hidden dependencies. That way you can avoid introducing hidden
dependencies.

If you reverse the order and i.e. `ui.c` includes `<string.h>` and then
`"ui.h"`, there is no way to catch at build time that `ui.h` may itself depend
on `<string.h>`. So if later someone includes `ui.h` but does not need
`<string.h>`, he'll get an error that needs to be fixed either in the source or
header file.

### Python 🐍

#### Coding standard

Follow [Google's Python Style Guide]. We do **not enforce** conformity to this
guide. Read it and learn from it.

#### Coding style

Follow the [Black code style] that is enforced by the formatting tool [Black].
Black is a PEP8 compliant opinionated formatter with a limited set of
configurable options.

We slightly deviate from Black's default code style:
* We use an improved string processing feature, which splits long string
  literals and merges short ones, more about this
  [here](https://black.readthedocs.io/en/stable/the_black_code_style/future_style.html).

This means that you need to add a few extra arguments when using Black from the
command-line or from your favourite editor:
```bash
black {some file or directory that you want to format} --preview
```

#### Docstrings

Follow [Google's Python Style Guide], section _3.8 Comments and Docstrings_.

Use the `python_template.py` file as a starting point.

See below snippet for an example of good documentation from TensorFlow codebase:
```python
@keras_export(v1=['keras.__internal__.legacy.layers.average_pooling2d'])
@tf_export(v1=['layers.average_pooling2d'])
def average_pooling2d(inputs,
                      pool_size, strides,
                      padding='valid', data_format='channels_last',
                      name=None):
  """Average pooling layer for 2D inputs (e.g. images).
  Args:
    inputs: The tensor over which to pool. Must have rank 4.
    pool_size: An integer or tuple/list of 2 integers: (pool_height, pool_width)
      specifying the size of the pooling window.
      Can be a single integer to specify the same value for
      all spatial dimensions.
    strides: An integer or tuple/list of 2 integers,
      specifying the strides of the pooling operation.
      Can be a single integer to specify the same value for
      all spatial dimensions.
    padding: A string. The padding method is either 'valid' or 'same'.
      Case-insensitive.
    data_format: A string. The ordering of the dimensions in the inputs.
      `channels_last` (default) and `channels_first` are supported.
      `channels_last` corresponds to inputs with shape
      `(batch, height, width, channels)` while `channels_first` corresponds to
      inputs with shape `(batch, channels, height, width)`.
    name: A string, the name of the layer.
  Returns:
    Output tensor.
  Raises:
    ValueError: if eager execution is enabled.
  """
```

### Rust 🦀

#### Coding style

Follow [Rust Style Guide]. Use the [rustfmt] tool for formatting Rust code
according to the style guide.

#### Doc comments

Follow to [Rust Style Guide], section _Comments_. Use doc comments to document
interfaces, the standard Rust distribution ships with a tool called `rustdoc`
which generates documentation from Rust projects.

For a simple example refer to the [Rust By Example] page. For a more
comprehensive document refers to the [rustdoc book].

### JavaScript/TypeScript 🇯🇸 / 🇹🇸

#### General guidelines
- Use `yarn` instead of `npm` package manager:
  - `yarn add <package_name>` instead of `npm install <package_name>`,
  - `yarn add --dev <package_name>` instead of `npm install --save-dev <package_name>`,
  - `yarn create` instead of `npx`.
- Use templates for React or RN when creating a new project.
- Typescript usage is recommended.

#### Coding standard
Follow guidelines from [Jared Palmer](https://github.com/jaredpalmer/typescript). They were written for TS but most of the sections apply also to JS.

For more information about the languages and coding styles refer to:
- [JavaScript.info](https://javascript.info/) for JS
- [TypeScript lang](https://www.typescriptlang.org/docs/) for TS

#### Coding style
One should use configuration files, which are available in this repo.
1. TS compiler config
2. Linter config
3. Code formatter config

Style should be automatically enforced by the linter and formatter. In VS code this is done by the following two components: ESLint (for linting) and Prettier (for code formatting).

#### Docstrings
Use style comments from **JSDoc** for functions, interfaces, enums, and classes. Documentation is available [here](https://jsdoc.app/index.html).

See example below:
```TypeScript
/**
 * Compares two software version numbers (e.g. "1.7.1" or "1.2b").
 *
 * This function was born in http://stackoverflow.com/a/6832721.
 *
 * @param {string} v1 The first version to be compared.
 * @param {string} v2 The second version to be compared.
 * @param {object} [options] Optional flags that affect comparison behavior:
 *         - lexicographical: true</tt> compares each part of the version strings lexicographically instead of
 *         naturally; this allows suffixes such as "b" or "dev" but will cause "1.10" to be considered smaller than
 *         "1.2".
 *         - zeroExtend: true</tt> changes the result if one version string has less parts than the other. In
 *         this case the shorter string will be padded with "zero" parts instead of being considered smaller.
 *
 * @returns {number|NaN}
 *    - 0 if the versions are equal
 *    - a negative integer iff v1 < v2
 *    - a positive integer iff v1 > v2
 *    - NaN if either version string is in the wrong format
 *
 * @copyright by Jon Papaioannou (["john", "papaioannou"].join(".") + "@gmail.com")
 * This is an updated version from https://github.com/Rombecchi/version-compare
 * @license This function is in the public domain. Do what you want with it, no strings attached.
 */
export function VersionCompare(v1: string, v2: string, options?: { lexicographical: boolean; zeroExtend: boolean }): number {
  ...
}
```

### Short scripts in various languages 💣

#### Documentation

Short scripts in written Python or Bash are often used to automate a simple task
or process some data. Those types of programs are not required to comment on
every internal function or class, as Google's Python Style Guide suggests for
example.

The most important documentation that these scripts need to have is **what they
do** and **how to use them**.

These instructions have to be provided to the user when he calls the program
with the `--help` flag or after incorrect use. If the program is simple enough
and `argparse` or similar command-line parsing modules are not used then
instructions need to be written at the top of the file in the comments.

There is a way to generate help strings in Bash scripts from the comments at the
top of the file. In the below example the script will return text from the
second line to the end of the comment section if the user gives a `--help` flag
or an insufficient number of arguments.

```bash
#!/usr/bin/env bash
# Usage: get_nrfsdk SDK_LOCATION TOOLCHAIN_LOCATION
#
# Description:
#   Following program will download nRF5 SDK, place it in SDK_LOCATION,
#   prepare Makefile.posix file and compile micro-ecc libraries that
#   are needed for creating a secure bootloader.
#
# Arguments:
#
#   SDK_LOCATION            Folder location where sdk will be installed into.
#                           If it does not exist yet it will be created.
#
#   TOOLCHAIN_LOCATION      Location of arm-none-eabi-gcc binaries on your
#                           system.

NUM_ARGS=2
# Print help text and exit if -h, or --help or insufficient number of arguments
# was given.
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -lt ${NUM_ARGS} ]; then
	sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' <"$0"
	exit 1
fi
```

#### Shebang lines

For Python or Bash scripts that you will execute directly specify the shebang
line in the first line of the file.

For Python2:
```python
#!/usr/bin/env python2.7
```

For Python3:
```python
#!/usr/bin/env python3
```

For Bash:
```bash
#! /usr/bin/env bash
```

In that way, you can call the script directly, without specifying an
interpreter first. The script needs to have to execute permissions for this to
work, you can do that with:
```bash
sudo chmod +x <script>
```

[Source control commit guidelines by Embedded Artistry]: https://embeddedartistry.com/fieldatlas/source-control-commit-guidelines/
[One Idea is One Commit]: https://secure.phabricator.com/book/phabflavor/article/recommendations_on_revision_control/
[Rust Style Guide]: https://github.com/rust-dev-tools/fmt-rfcs/blob/master/guide/guide.md
[rustfmt]: https://github.com/rust-lang/rustfmt
[Black code style]: https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html
[Black]: https://github.com/psf/black
[Zephyr's Coding Style]: https://docs.zephyrproject.org/latest/contribute/guidelines.html#coding-style
[Linux kernel coding style]: https://kernel.org/doc/html/latest/process/coding-style.html

[Printing kernel messages]: https://kernel.org/doc/html/latest/process/coding-style.html#printing-kernel-messages
[Allocating memory]: https://kernel.org/doc/html/latest/process/coding-style.html#allocating-memory
[The inline disease]: https://kernel.org/doc/html/latest/process/coding-style.html#the-inline-disease
[Rust By Example]: https://doc.rust-lang.org/rust-by-example/meta/doc.html
[rustdoc book]: https://doc.rust-lang.org/stable/rustdoc/

[Patterns in the Machine]: https://www.amazon.com/Patterns-Machine-Software-Engineering-Development/dp/1484264398
[Google's Python Style Guide]: https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings
[Doxygen]: https://www.doxygen.nl/
[nRF Connect SDK's Doxygen guidelines]: https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/doc_styleguide.html#doxygen-gl
[template files]: source_code_templates
[tools/gitlint/README.md]: ../tools/gitlint/README.md
