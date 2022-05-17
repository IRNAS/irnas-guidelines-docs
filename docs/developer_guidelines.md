# Developer guidelines

## Table of Contents 📜

<!-- vim-markdown-toc GFM -->

* [Commits 🪢](#commits-)
    * [Message style](#message-style)
    * [Message content](#message-content)
* [Documentation in source code 📑](#documentation-in-source-code-)
* [Coding standards 📚](#coding-standards-)
    * [C/C++ 🇨](#cc-)
    * [Python 🐍](#python-)
    * [Rust 🦀](#rust-)
    * [JavaScript/TypeScript 🇯🇸 / 🇹🇸](#javascripttypescript---)

<!-- vim-markdown-toc -->

## Commits 🪢

This section outlines general ideas to follow when making commits and writing commit messages.

A lot has been said on this topic, so it is best to refer to resources and then highlight important points.

Resources:
* [Source control commit guidelines by Embedded Artistry] - Main resource related to the commit content and message content. Read this **first**, before reading the rest.
* [One Idea is One Commit] - Interesting commiting strategy, similiar to atomic commits.

### Message style

There are two possible style for a commit message: short and full.

Short commit message should be around 50 characters long, maximum is at 72.

Use this when the change that you made is either:
* self-explanatory - For example: `Fix typo in README.md` or
* there is a GitHub issue that provides full context for the change made, for example: `Fix out of bounds bug, closes #123`

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

More detailed explanatory text, if necessary. Wrap it to about 72
characters or so, editors like Visual Studio Code and Vim do this
automatically. Treat the first line as the subject of the commit
and the rest of the text as the body. The blank line separating
the summary from the body is critical (unless you omit the body
entirely); various tools like `log`, `shortlog` and `rebase` can
get confused if you run the two together.

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


## Documentation in source code 📑

## Coding standards 📚

### C/C++ 🇨

### Python 🐍

### Rust 🦀

### JavaScript/TypeScript 🇯🇸 / 🇹🇸

[Source control commit guidelines by Embedded Artistry]: https://embeddedartistry.com/fieldatlas/source-control-commit-guidelines/
[One Idea is One Commit]: https://secure.phabricator.com/book/phabflavor/article/recommendations_on_revision_control/
