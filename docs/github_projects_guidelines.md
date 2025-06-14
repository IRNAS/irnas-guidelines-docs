# GitHub project guidelines 📚

This document describes guidelines and recommendations that should be used when working with
projects hosted on GitHub.

## Table of Contents 📜

<!-- vim-markdown-toc GFM -->

- [Repository naming scheme 📝](#repository-naming-scheme-)
  - [General rules](#general-rules)
  - [Naming scheme](#naming-scheme)
- [Versioning 1️⃣0️⃣0️⃣](#versioning-1️⃣0️⃣0️⃣)
  - [Software/Firmware projects](#softwarefirmware-projects)
  - [Hardware projects](#hardware-projects)
  - [Mechanical projects](#mechanical-projects)
  - [Concepts](#concepts)
- [Changelog 📋](#changelog-)
  - [Content of changelog notes](#content-of-changelog-notes)
  - [Zephyr drivers](#zephyr-drivers)
- [Releases 🚀](#releases-)
  - [Tagging and naming releases](#tagging-and-naming-releases)
  - [Release notes](#release-notes)
  - [Creating releases](#creating-releases)
- [Release artifacts naming scheme for software/firmware projects 📦](#release-artifacts-naming-scheme-for-softwarefirmware-projects-)
  - [General rules](#general-rules-1)
  - [Naming scheme](#naming-scheme-1)
  - [Qualifiers](#qualifiers)
    - [Misc qualifiers](#misc-qualifiers)
    - [Git hash](#git-hash)
  - [Valid release objects names](#valid-release-objects-names)
- [GitHub for non-software projects 🛠️](#github-for-non-software-projects-)
  - [Mechanics project](#mechanics-project)
    - [Changelog](#changelog)
  - [Electronics project](#electronics-project)
    - [Changelog](#changelog-1)
  - [Release process automation](#release-process-automation)
- [GitHub labels management 🏷️](#github-labels-management-)
  - [Usage](#usage)
- [Documentation 📖](#documentation-)
  - [OneDrive](#onedrive)
  - [Github](#github)
- [Resources 🤓](#resources-)

<!-- vim-markdown-toc -->

## Repository naming scheme 📝

### General rules

- Names are written in lowercase letters.
- Names consist of several fields separated by dashes, which means that the fields themselves can
  not contain dashes.
- Some fields are mandatory, and some of them are optional, as per project requirements.
- Underscores are not allowed.

### Naming scheme

Use this scheme when naming GitHub repositories:

```code
{client}-{project}-[{specifier}-]{repo_type}
```

Explanation of fields:

- `client` - Client's name, such as `irnas`, `fabrikor`, `companyinc`.
- `project` - Project name, such as `controller`, `beacon`, `robot`.
- `specifier` - Used to specify chip name, sensor name, or similar, such as `nrf92`, `nrf52`,
  `scp40`. This field is optional. Use only when specifying extra information that distinguishes
  codebases, such as two MCUs on the same PCB.
- `repo_type` - Possible options are:
  - `firmware` - `C/C++` project for microcontrollers, projects for RPi,
  - `driver` - `C/C++` project for a sensor, communication module driver,
  - `hardware` - PCB hardware project,
  - `mechanics` - mechanical CAD project,
  - `software` - software project, for example, Python tooling or a web app,
  - `application` - Android/iOS application project,
  - `docs` - Documentation project.
  - `master` - Master repo which ties together all other repos.

It can happen that your new GitHub project does not fit the preceding `repo_type` options. In that
case, describe your `repo_type` with one, short word.

When creating fields `client` and `project` for a new project long names should be avoided, the soft
limit is around 12 characters. Character shortening techniques such as abbreviations, internal
codenames and concatenations of multiple words are allowed to satisfy the limit, **however, overall
clarity should not be compromised**.

Some examples include:

- `irnas-blebeacon-firmware`
- `irnas-userapp-application`
- `irnas-lis2-driver`
- `fabrikor-3dprinter-nrf91-firmware`
- `fabrikor-3dprinter-nrf52-firmware`
- `irnas-guidelines-docs`

## Versioning 1️⃣0️⃣0️⃣

The versioning scheme consists of a letter `v`, followed by 3 numbers separated by dots:
`v{major}.{minor}.{bugfix}`

The following versions are all valid examples:

- `v0.1.4`
- `v0.9.3`
- `v0.9.10`
- `v1.0.0`
- `v1.1.0`
- `v1.12.45`
- `v5.0.0`

Numbering was inspired by [SemVer] convention. We deviate from their rules on version incrementing,
as the SemVer convention makes more sense when you are developing libraries that are consumed by the
developers and not in the sense of our product development.

Starting version and how it is incremented depends on the type of the project.

### Software/Firmware projects

Given the preceding versioning scheme increment:

1. A `major` number when releasing a new, initial stable version of a product (`v1.0.0`), making any
   conceptual changes, major rewrite, major documentation changes, a new generation of a product or
   any other change which requires additional human involvement.
2. A `minor` number when adding new features, enhancements, and documentation in a
   backwards-compatible manner and
3. A `bugfix` number when you make backwards-compatible bug fixes.

New projects should start with version `v0.1.0` and continue from there.

### Hardware projects

Given the preceding versioning scheme increment:

1. A `major` number for major schematic and layout changes such as changes to general functionality,
   board shape or board dimensions.
2. A `minor` number for minor schematic and layout changes such as smaller changes to functionality,
   board shape and dimensions, components placement, layout routing.
3. A `bugfix` number for changes to component values, silkscreen and documentation, such that do not
   require new boards manufacturing.

New projects should start with version `v0.1.0` for **concepts** (see explanation below) and
`v1.0.0` for functional devices and continue from there.

### Mechanical projects

Given the preceding versioning scheme increment:

1. A `major` number for major changes such as changes to general functionality, shape and size.
2. A `minor` number for minor changes such as smaller changes to functionality and dimensions.
3. A `bugfix` number for changes to documentation, such that do not require new part manufacturing.

New projects should start with version `v0.1.0` for **concepts** (see explanation below) and
`v1.0.0` for functional devices and continue from there.

### Concepts

Concept is a project that might not yet be completely functional, but it is a proof of concept that
demonstrates the feasibility of a specific idea or technology.

It is intended only for the internal use and presentation purposes, it should never be released to
the production.

## Changelog 📋

A changelog is a file that contains a curated, chronologically ordered list of notable changes for
each version of a project. Changelog makes it easier for users and engineers to see precisely what
notable changes have been made between each version of the project.

IRNAS's changelog format is based on the [Keep a Changelog's] format, we follow it is almost to a
point with some minor additions and modifications.

This means that:

- We follow its overall structure in markdown, which can be seen at the top of the page.
- We follow its _guiding principles_, however, we define our versioning scheme.
- Each version entry needs to be linkable, where the link points to a page showing the comparison
  between that version and the previous one.
- Each bullet line should finish with a period dot.

The same types of changes should be grouped under one of the following groups:

- `Added` for new features,
- `Changed` for changes in existing functionality,
- `Deprecated` for soon-to-be removed features,
- `Removed` for now removed features,
- `Fixed` for any bug fixes and
- `Security` in case of vulnerabilities.

### Content of changelog notes

Changelog notes can be seen as a common point between development and business.

Below are a few points that will help you construct clear and concise changelog notes:

- Use plain language, without technical jargon. Write your release notes like you are explaining
  them to a friend.
- Keep them short.
- If you’ve implemented a new feature, your changelog notes should contain a high-level summary of
  what it can do. But, of course, some more explanation on how to use it might be required, so
  provide a link to the detailed stuff, like a user guide, step-by-step instructions, etc.

In general, your changelog notes should answer the following questions:

- What has changed in the latest version of your product?
- Why has that thing changed?
- How does this change impact the user?
- What does the user need to do differently as a result?

Keep in mind that in most cases a project manager will notify a customer about the new release and
will also need to create a customer-understandable abstract from the changelog notes. Write
changelog notes in such a way that is easy to write an abstract that communicates to the customer
what value a specific the release brings to him.

### Zephyr drivers

When creating a version entry for a Zephyr driver add a section which says for which NCS version was
the driver built. This information should be visible to the developer who is deciding which version
of the driver to use so that it will work with its NCS version of the project. Use the below
template:

```markdown
### Compatibility

- This release was built and tested on the NCS version <version>.
```

## Releases 🚀

Taken from <https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases>:

> Releases are deployable software iterations you can package and make available for a wider
> audience to download and use.

Releases are based on Git tags, which mark a specific point in your repository's history. A tag date
may be different from a release date since they can be created at different times.

GitHub release consists of a git tag, some text (commonly referred to as Release Notes) and
artifacts (binaries, executables, any kind of documentation, etc.)

### Tagging and naming releases

<!-- TODO: Shrink this section, refer to the Versioning section above it -->

Release tags and names consist of the letter `v` followed by a version number.

The below tags are all valid examples:

- `v0.1.4`
- `v0.9.3`
- `v1.0.0`
- `v1.1.0`
- `v1.12.45`
- `v5.0.0`

The name of a GitHub release should be identical to the tag that the release was created from.

### Release notes

Release notes are identical to the changelog notes for that specific version of a project and should
be always kept in sync.

### Creating releases

Since we are following the [trunk-based development] branching model, a GitHub release is created
directly from a commit that was tagged with the release tag.

This process is automated with GitHub Actions with the "Basic" group of workflow files. More about
this [here](https://github.com/IRNAS/irnas-workflows-software).

## Release artifacts naming scheme for software/firmware projects 📦

### General rules

- Names are written in lowercase letters.
- Names consist of several fields separated by dashes, which means that the fields themselves can
  not contain dashes.
- Some fields are mandatory and some are optional, as per project requirements.
- Underscores are not allowed.

### Naming scheme

The naming scheme that should be used for release objects:

```code
{project}-{firmware_type}-{board_name}-{hardware_version}-{version}-{qualifiers}.{file_extension}
```

Fields `project` and `firmware_version` are the only mandatory ones, others should be added to avoid
any confusion when dealing with generated files. If the `repo_type` of your GitHub project is
`firmware` then the `hardware_version` the field is mandatory.

Explanation of fields:

- `project` - Project name, such as `blebeacon` or `tracker`
- `firmware_type` - The type of firmware, needs to be added if the build system produces
  applications and bootloader firmware. It can be `app` (for application firmware or software) or
  `bl` (for bootloader firmware).
- `board_name` - If a project supports multiple boards, this field should be used to distinguish
  between different hardware boards, such as, `VYPER_GO` and `VYPER_30`.
- `hardware_version` - Hardware version of the board which consists of `hv` and a version number.
  Hardware versions such as `hv1.2.0`, `hv4.0.1` or `hv0.5.1` are all valid options.
- `version` - Version of the software/firmware which consists of `v` and a version number. Versions
  such as `v1.2.0`, `v4.0.1` or `v0.5.1` are all valid options.
- `qualifiers` - Optional field, can be repeated. See the explanation below.
- `file_extension` - Depends on a generated object, could be `bin`, `elf`, `hex` or something else.

### Qualifiers

Qualifiers come in several forms:

- Misc qualifiers - examples: `log`, `dbg`, `dbgble`, `rf`
- 7 char Git hash - examples: `57fb962`, `a982467`, `6b3089c`

#### Misc qualifiers

These are special qualifiers that indicate that some special set of build flags was used to build a
release artifact. Release artifacts that are meant to be used in the production do not contain any
misc qualifiers.

Example scenario: you could be developing firmware that is used:

- in production, with debug logs turned off,
- in development, with debug logs turned on and
- in RF compliance tests, where the device behaves completely differently for testing purposes.

In that scenario, production artifact would have no misc qualifier, development the artifact could
have `log` qualifier and RF compliance artifact would have `rf` qualifier.

A project that uses misc qualifiers should have its meaning and usage documented in a visible place,
such as the project's README.

#### Git hash

Git hash qualifiers are useful for internal testing processes of the product and where later
identification is required. The version that precedes the qualifier should be a version of the
release that was **already released**.

**Important:** release artifacts should never contain git hash qualifiers.

### Valid release objects names

Below release names are all valid examples:

Simple firmware project:

- GitHub repo name: `irnas-blebeacon-firmware`
- Release artifacts: `blebeacon-hv1.4.0-v1.3.3.hex`

Firmware project with application and bootloader firmware:

- GitHub repo name: `irnas-robot-firmware`
- Release artifacts:
  - `robot-app-hv1.4.0-v1.0.0.hex`
  - `robot-bl-hv1.0.0-v1.0.0.hex`

Firmware project with application and bootloader firmware, and various sets of build flags:

- GitHub repo name: `irnas-largerobot-firmware`
- Release artifacts:
  - `largerobot-app-hv1.4.0-v1.0.0.hex`
  - `largerobot-bl-hv1.0.0-v1.0.0.hex`
  - `largerobot-app-hv1.4.0-v1.0.0-log.hex`
  - `largerobot-bl-hv1.0.0-v1.0.0-log.hex`
  - `largerobot-app-hv1.4.0-v1.0.0-rf.hex`
  - `largerobot-bl-hv1.0.0-v1.0.0-rf.hex`

## GitHub for non-software projects 🛠️

This section describes the expected content of the GitHub repositories for non-software project.

### Mechanics project

Below files should be commited to the GitHub repository:

- STEP files
- STL files
- Bill of material file (BOM)
- project documentation and images

Below files should be uploaded as a part of the release:

- STEP, STL and BOM files, compressed together as a single zip file.
- Release notes.

#### Changelog

Entries in the changelog should contain:

- Description of the changes (see above [changelog](#changelog-) section)

Entries in the changelog do not have to contain images.

### Electronics project

Below files should be committed to the GitHub repository:

- Complete Altium project
- project documentation and images

Below files should be uploaded as a part of the release:

- output files of the Altium release generation script (FAB, PCBA, etc.)
- Release notes.

#### Changelog

Entries in the changelog should contain:

- Description of the changes (see above [changelog](#changelog-) section)
- Image of the PCB
- Link to the Altium 365 project

### Release process automation

<!-- prettier-ignore -->
> [!NOTE]
> GitHub Action release workflow will automatically compress files in `release/` folder in a zip
> file and attach it to the release assets during release process. It will also automatically
> generate release notes from the latest section from the `CHANGELOG.md` file.

## GitHub labels management 🏷️

What are GitHub labels? From [GitHub's docs]:

> You can manage your work on GitHub by creating labels to categorize issues, pull requests, and
> discussions. You can apply labels in the repository the label was created in. Once a label exists,
> you can use the label on any issue, pull request, or discussion within that repository.

To organize and categorize issues we use a set of labels that are defined in the
[irnas-project-template] repository.

When creating a new project labels are automatically transferred if the new the the project used the
`irnas-project-template` repository as a template.

If you want to use the labels in a project that was not created from the above the template then
read the next section.

### Usage

Below are some guidelines regarding the usage of labels:

- An Issue/PR without labels should not require labels to attract attention, therefore the default
  state should be label-less.
- Most of the labels have prefixes that organize them into groups:
  - `priority` - describes the immediacy of the attention required.
  - `state` - describes the decision state of the issue or pull request.
  - `type` - describes the type of the issue or pull request.
- Issue should have a maximum of one label per group.
- Some labels do not have prefixes, specifically `pull request` and `release` as they are created by
  the templates/CI.

Please note that the above guidelines are exactly that, guidelines, and not rules. If your project
requires a different set of labels, uses additional groups, etc. then feel free to break the
guidelines.

## Documentation 📖

There are two general places where project-related documentation can exist:

- OneDrive
- Github

This section does not try to address documentation in the source code. That is a separate topic.

### OneDrive

Documentation on the OneDrive is meant to be mostly written by the management.

Things like:

- project-related notes and ideas,
- mockups,
- project timeline projections,
- meeting notes,
- concepts and
- field research notes

all belong on the OneDrive.

Engineers and developers can also write to the OneDrive due to project-specific requests.

### Github

Documentation on GitHub is meant to be mostly written by engineers and developers. It is written in
the form of markdown files either in `README.md` or in the `docs` folder.

Things like:

- setting up the build environment,
- instruction on how to create a release,
- customer-facing technical documentation,
- getting started guide,
- API documentation,
- architecture diagrams,
- block and flow diagrams and
- power consumption reports

all belong on GitHub.

When looking at the documentation from a point of a specific release, the documentation should be up
to date and should reflect the behavior and implementation of the project at that point.

## Resources 🤓

The below section is a hot mess of links to various topics related to this document, embedded
systems and more.

Branching models/strategies/Git related:

- [Trunk Based Development](https://trunkbaseddevelopment.com/) - Exhaustive website on a newer,
  better way to do Git Branching.
- [Git Organized: A Better Git Flow](https://dev.to/render/git-organized-a-better-git-flow-56go) -
  Interesting article on how to separate documenting git commits from coding.
- [Git your reset on](https://changelog.com/podcast/480) - Podcast with the author of the above
  article.
- [Pro Git Book](https://git-scm.com/book/en/v2) - The main resource for learning Git.
- [Learn Git Branching](https://learngitbranching.js.org/) - Interactive browser game that helps you
  to learn Git branching.

Versioning:

- [SemVer](https://semver.org) - Versioning scheme used by many.
- [CalVer](https://calver.org/) - Another versioning scheme used by many.
- [zero0ver](https://0ver.org/) - Parody website on how many libraries misuse Semver.
- [Giving Your Firmware Build a Version] - Good article from Embedded Artistry about versioning in
  firmware-related context.
- [Proper Release Versioning Goes a Long Way] - Another good article about versioning from Memfualt.

[Giving Your Firmware Build a Version]:
  https://embeddedartistry.com/blog/2016/12/21/giving-your-firmware-build-a-version/
[Proper Release Versioning Goes a Long Way]: https://interrupt.memfault.com/blog/release-versioning

Release naming:

- [Release naming conventions] - Naming conventions used by Drupal.

[Release naming conventions]:
  https://www.drupal.org/docs/develop/git/git-for-drupal-project-maintainers/release-naming-conventions

Changelog:

- [What makes a good changelog?](https://depfu.com/blog/what-makes-a-good-changelog) - Writing a
  good changelog, like writing any text, is about knowing your audience and their needs.

Awesome projects:

- [Awesome embedded](https://github.com/nhivp/Awesome-Embedded) - A curated list of awesome embedded
  resources.
- [Awesome C](https://github.com/oz123/awesome-c) - A curated list of C good stuff.
- [Awesome Zephyr RTOS](https://github.com/golioth/awesome-zephyr-rtos) - A curated list of
  Zephyr-related stuff.

[semver]: https://semver.org
[keep a changelog's]: https://keepachangelog.com/en/1.0.0/
[github's docs]:
  https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels
[irnas-project-template]: https://github.com/IRNAS/irnas-projects-template/labels
