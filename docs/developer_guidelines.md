# Developer guidelines

## Table of Contents 📜

<!-- vim-markdown-toc GFM -->

* [Commits 📌](#commits-)
    * [Message style](#message-style)
    * [Message content](#message-content)
* [Programming language specifics 💻](#programming-language-specifics-)
    * [C/C++ 🇨](#cc-)
        * [Source code documentation](#source-code-documentation)
        * [Doxygen guidelines](#doxygen-guidelines)
        * [Coding style](#coding-style)
        * [Include statements](#include-statements)
    * [Python 🐍](#python-)
        * [Coding standard](#coding-standard)
        * [Coding style](#coding-style-1)
        * [Docstrings](#docstrings)
    * [Rust 🦀](#rust-)
        * [Coding style](#coding-style-2)
        * [Doc comments](#doc-comments)
    * [JavaScript/TypeScript 🇯🇸 / 🇹🇸](#javascripttypescript---)
    * [Short scripts in various languages 💣](#short-scripts-in-various-languages-)
        * [Documentation](#documentation)
        * [Shebang lines](#shebang-lines)

<!-- vim-markdown-toc -->

## Commits 📌

This section outlines general ideas to follow when making commits and writing
commit messages.

A lot has been said on this topic, so it is best to refer to resources and then
highlight important points.

Resources:
* [Source control commit guidelines by Embedded Artistry] - Main resource
  related to the commit content and message content. Read this **first**,
  before reading the rest.
* [One Idea is One Commit] - Interesting commiting strategy, similiar to atomic
  commits.

### Message style

There are two possible styles for a commit message: short and full.

Short commit message should be around 50 characters long, maximum is at 72.

Use this when the change that you made is either:
* self-explanatory - For example: `Fix typo in README.md` or
* there is a GitHub issue that provides full context for the change made, for
  example: `Fix out of bounds bug, closes #123`

Full commit message style is best summarized with below rules:

* Separate subject from body with a blank line
* Limit the subject line to 50 characters
* Capitalize the subject line
* Do not end the subject line with a period
* Use the imperative mood in the subject line
* Wrap the body at 72 characters

Below is a visual repesentation of the full message format:

```
Summarize changes in around 50 characters or less

More detailed explanatory text, if necessary, it can be only a
sentence or two. Wrap it to about 72 characters or so, editors
like Visual Studio Code and Vim do this automatically. Treat
the first line as the subject of the commit and the rest of the
text as the body. The blank line separating the summary from the
body is critical (unless you omit the body entirely); various
tools like `log`, `shortlog` and `rebase` can get confused if
you run the two together.

Explanatory text can be split into several paragraphs.

You can also include bullet points:
* A
* B
* C

Reference GitHub issues at the bottom, like this:

Resolves: #123
See also: #456, #789
```

### Message content

## Programming language specifics 💻

### C/C++ 🇨

#### Source code documentation

The following section has been adapted from the [Patterns in the Machine] book
and the [Google's Python Style Guide], section _3.8 Comments and Docstrings_.

Considers header files to be “data sheets”. In the header files, you want to
summarize:
* what the function does,
* what are its inputs and outputs,
* what are the required precondition and
* what are the possible side effects.

The goal is that comments provide enough information to the programmer so that
he can use the module without reading its implementation. Do not document
implementation details in the header files, unless those details are relevant
to how the function should be used (try to avoid this if you can). Do not
duplicate information in multiple places in the code.

Concretely this means:
* Provide description of the module at the top of the header file. Optionally,
  add a brief description of functions and/or usage examples. If documenting a
  driver level module, include a link to the datasheet and mention relevant
  sections. See [template files] in this repository for examples.
* Document all externally visible constructs in the header files. Always
  comment functions, function-like macros, structs and enums. You can omit
  comments of macro defines and constants if their use and meaning are obvious.
* Don't document internally visible static functions, or function-like macros
  if they are very short and obvious. The same goes for the structs, enum, and
  macro defines.
* Add single or multi-line comments before tricky or non-obvious parts in code.
  Describe what and why the code is trying to do, not how is doing it.

#### Doxygen guidelines

For documenting the code constructs use [Doxygen] style comments. The structure
of these is defined by [nRF Connect SDK's Doxygen guidelines]. Follow these
guidelines completely, except for the _File headers and groups_ section, for an
example of a file header refer to `c_cpp_template.h` file.

#### Coding style

Follow [Zephyr's Coding Style]. Zephyr's Coding Style generally follows of a
[Linux kernel coding style] with few exceptions.

Almost all sections in the Linux kernel coding style are relevant to firmware
programming, some might need minor changes to become relevant:
* [Printing kernel messages] - Replace kernel messages with log messages.
* [Allocating memory] - Contains mentions to kernel specific memory allocators,
  but, the advice still applies.
* [The inline disease] - Again, somewhat kernel specific, we rarely use
  `inline` keyword in our code, but, the advice still applies.

#### Include statements

Include statements should be placed at the top of the file, after the license
header and before any other code. In header files, they should be placed after
header guards and `extern C` guards.

Include only what is necessary to compile the source code. Adding unnecessary
includes means a longer compilation time, especially in large projects. Each
header and corresponding source file should compile cleanly on its own. That
means, if you have a source file that includes only the corresponding header,
it should compile without errors. The header file should include not more than
what is necessary for that.

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
* We increase the maximum number of characters from 88 to 100.
* We use an improved string processing feature, which splits long string literals
  and merges short ones, more about this
  [here](https://black.readthedocs.io/en/stable/the_black_code_style/future_style.html).

This means that you need to add a few extra arguments when using Black from the
command-line or from your favourite editor:
```bash
black {some file or directory that you want to format} --line-length 100 --preview
```

#### Docstrings

Follow [Google's Python Style Guide], section _3.8 Comments and Docstrings_.

Use the `python_template.py` file as a starting point.

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

🚧 **In progress** 🚧

### Short scripts in various languages 💣

#### Documentation

Short scripts in written Python or Bash are often used to automate a simple
task or process some data. Those types of programs are not required to
comment on every internal function or class, as Google's Python Style Guide
suggests for example.

The most important documentation that these scripts need to have is **what they
do** and **how to use them**.

These instructions have to be provided to the user when he calls the program
with the `--help` flag or when after incorrect use. If the program is simple enough and
`argparse` or similar command-line parsing modules are not used then
instructions need to be written at the top of the file in the comments.

There is a way to generate help strings in Bash scripts from the comments at
the top of the file. In the below example the script will return text from
the second line to the end of the comment section if the user gives a `--help` flag or
an insufficient number of arguments.

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

For Python or Bash scripts that you will execute directly specify the shebang line
in the first line of the file.

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

In that way, you can call the script directly, without specifying an interpreter
first. The script needs to have to execute permissions for this to work, you can
do that with:
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
