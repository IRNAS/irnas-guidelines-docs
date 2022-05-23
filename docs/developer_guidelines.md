# Developer guidelines

## Table of Contents 📜

<!-- vim-markdown-toc GFM -->

* [Commits 🪢](#commits-)
    * [Message style](#message-style)
        * [Short](#short)
        * [Full](#full)
    * [Commit and message content](#commit-and-message-content)
* [Documentation in source code 📑](#documentation-in-source-code-)
* [Coding standards 📚](#coding-standards-)
    * [C/C++ 🇨](#cc-)
    * [Python 🐍](#python-)
    * [Rust 🦀](#rust-)
    * [JavaScript/TypeScript 🇯🇸 / 🇹🇸](#javascripttypescript---)

<!-- vim-markdown-toc -->

## Commits 🪢

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

Whenever the change you made needs more context you should you full message
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

The below sections are copied directly from [Source control commit guidelines
by Embedded Artistry].

About content of the commits:

> 1. All changes in a commit should be related.
>    * Don’t combine changes that address different problems into a single
>     commit.
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

## Documentation in source code 📑

## Coding standards 📚

### C/C++ 🇨

### Python 🐍

### Rust 🦀

### JavaScript/TypeScript 🇯🇸 / 🇹🇸

[Source control commit guidelines by Embedded Artistry]: https://embeddedartistry.com/fieldatlas/source-control-commit-guidelines/
[One Idea is One Commit]: https://secure.phabricator.com/book/phabflavor/article/recommendations_on_revision_control/
[tools/gitlint/README.md]: ../tools/gitlint/README.md
