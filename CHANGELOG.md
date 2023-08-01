# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [0.2.0] - 2023-08-01

### Added

-   Sections about code standards, code styles, documentation guidelines for
    C/C++, Python and Rust.
-   File templates for C/C++ and Python.
-   New document related to developer specific guidelines can be found in
    `docs/developer_guidelines.md`. It contains section about commits.
-   Documentation related to `gitlint` tool, it can be found in
    `tools/gitlint`.
-   Section about GitHub labels.
-   Created `draft_ideas.md` file for storing unused work that might be useful
    in the future.

### Changed

-   General project structure. Main README.md now serves as a landing page,
    from where users can jump to other documents. Contents of the old README
    were moved to `docs/github_project_guidelines.md`.
-   Various documents related to tooling, such as clang-format and gitlint, are
    now in `tools` directory.
-   Branching model to the Trunk-based development model from GitFlow.
-   Moved Production versions section from project guidelines to the
    `draft_ideas.md` do to not using it.
-   Moved section about moving labels to the `draft_ideas.md` as it adds no 
    value and should be automated anyhow.

## [0.1.0] - 2022-05-12

### Added

-   `CHANGELOG` file.
-   `README` file with basic structure.
-   Section about branching model.
-   Section about repository naming scheme and versioning.
-   Section about artifact naming.
-   Section about changelog.
-   Section about production versions.
-   Section about releases.
-   Section about resources.
-   Section about documentation.
-   Extra readme for `.clang-format`

[Unreleased]: https://github.com/IRNAS/irnas-guidelines-docs/compare/v0.2.0...HEAD

[0.2.0]: https://github.com/IRNAS/irnas-guidelines-docs/compare/v0.1.0...v0.2.0

[0.1.0]: https://github.com/IRNAS/irnas-guidelines-docs/compare/72adf4ac813c1915181b3cf15993ee44d90fa3ea...v0.1.0
