This document describes guidelines and recommendations that should be used when
working with projects hosted on GitHub.

## Table of Contents 📜

<!-- vim-markdown-toc GFM -->

- [Repository naming scheme 📝](#repository-naming-scheme-)
  - [General rules](#general-rules)
  - [Naming scheme](#naming-scheme)
- [Versioning 1️⃣0️⃣0️⃣](#versioning-1️⃣0️⃣0️⃣)
  - [Software/Firmware projects](#softwarefirmware-projects)
  - [Hardware projects](#hardware-projects)
  - [Mechanical projects](#mechanical-projects)
- [Changelog 📋](#changelog-)
  - [Content of changelog notes](#content-of-changelog-notes)
  - [Zepyhr drivers](#zepyhr-drivers)
- [Releases 🚀](#releases-)
  - [Tagging and naming releases](#tagging-and-naming-releases)
  - [Release notes](#release-notes)
  - [Creating releases](#creating-releases)
- [Release artefacts naming scheme 📦](#release-artefacts-naming-scheme-)
  - [General rules](#general-rules-1)
  - [Naming scheme](#naming-scheme-1)
  - [Qualifiers](#qualifiers)
    - [Misc qualifiers](#misc-qualifiers)
    - [Git hash](#git-hash)
  - [Valid release objects names](#valid-release-objects-names)
- [GitHub labels management 🏷️](#github-labels-management-)
  - [Usage](#usage)
  - [Exporting labels to a project](#exporting-labels-to-a-project)
- [Production versions 🏭](#production-versions-)
- [Documentation 📖](#documentation-)
  - [Gitbook](#gitbook)
  - [Github](#github)
- [Resources 🤓](#resources-)

<!-- vim-markdown-toc -->

## Repository naming scheme 📝

### General rules

- Names are written in lower-case letters.
- Names consist of several fields separated by dashes, which means that the
  fields themselves can not contain dashes.
- Some fields are mandatory, and some of them are optional, as per project
  requirements.
- Underscores are not allowed.

### Naming scheme

Use this scheme when naming GitHub repositories:

```
{client}-{project}-[{specifier}-]{repo_type}
```

Explanation of fields:

- `client` - Client's name, such as `irnas`, `fabrikor`, `companyinc`.
- `project` - Project name, such as `controller`, `beacon`, `robot`.
- `specifier` - Used to specify chip name, sensor name, or similar, such as
  `nrf92`, `nrf52`, `scp40`. This field is optional. Use only when specifying
  extra information that distinguishes codebases, such as two MCUs on the same
  PCB.
- `repo_type` - Possible options are:
  - `firmware` - `C/C++` project for microcontrollers, projects for RPi,
  - `driver` - `C/C++` project for a sensor, communication module driver,
  - `hardware` - PCB hardware project,
  - `mechanical` - mechanical CAD project,
  - `software` - software project, for example, Python tooling or a web app,
  - `application` - Android/iOS application project,
  - `docs` - Documentation project.
  - `master` - Master repo which ties together all other repos.

It can happen that your new GitHub project does not fit the preceding
`repo_type` options. In that case, describe your `repo_type` with one, short
word.

When creating fields `client` and `project` for a new project long names should
be avoided, the soft limit is around 12 characters. Character shortening
techniques such as abbreviations, internal codenames and concatenations of
multiple words are allowed to satisfy the limit, **however, overall clarity
should not be compromised**.

Some examples include:

- `irnas-blebeacon-firmware`
- `irnas-userapp-application`
- `irnas-lis2-driver`
- `fabrikor-3dprinter-nrf91-firmware`
- `fabrikor-3dprinter-nrf52-firmware`
- `irnas-guidelines-docs`

## Versioning 1️⃣0️⃣0️⃣

The versioning scheme consists of a letter `v`, followed by 3 numbers separated
by dots: `v{major}.{minor}.{bugfix}`

The following versions are all valid examples:

- `v0.1.4`
- `v0.9.3`
- `v0.9.10`
- `v1.0.0`
- `v1.1.0`
- `v1.12.45`
- `v5.0.0`

Numbering was inspired by [SemVer] convention. We deviate from their rules on
version incrementing, as the SemVer convention makes more sense when you are
developing libraries that are consumed by the developers and not in the sense of
our product development.

Starting version and how it is incremented depends on the type of the project.

### Software/Firmware projects

Given the preceding versioning scheme increment:

1. a`major` number when releasing a new, initial stable version of a product
   (`v1.0.0`) or making any conceptual change, major rewrite, major
   documentation changes, a new generation of a product or any other change
   which requires additional human involvement.
2. a `minor` number when adding new features, enhancements, and documentation in
   a backwards-compatible manner and
3. a `bugfix` number when you make backwards-compatible bug fixes.

New projects should start with a version `v0.1.0` and continue from there.

### Hardware projects

Given the preceding versioning scheme increment:

1. a `major` number for major layout and schematic changes such as changes to
   board dimensions, components placement or general functionality and
2. a `minor` number for minor layout and schematic changes such as component
   value changes, layout routing, copper fills, etc.

Number `bugfix` is never incremented and is always set to `0`. New projects
should start with a version `v1.0.0` and continue from there.

### Mechanical projects

Given the preceding versioning scheme increment:

1. a `major` number for major changes such as changes to dimensions, components
   placement or general functionality and
2. a `minor` number for minor changes such as fixes, etc.

Number `bugfix` is never incremented and is always set to `0`. New projects
should start with a version `v1.0.0` and continue from there.

## Changelog 📋

A changelog is a file that contains a curated, chronologically ordered list of
notable changes for each version of a project. Changelog makes it easier for
users and engineers to see precisely what notable changes have been made between
each version of the project.

IRNAS's changelog format is based on the [Keep a Changelog's] format, we follow
it almost to a point with some minor additions and modifications.

This means that:

- We follow its overall structure in markdown, which can be seen at the top of
  the page.
- We follow its _guiding principles_, however, we define our versioning scheme.
- Each version entry needs to be linkable, where the link points to a page
  showing the comparison between that version and the previous one.
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

Below are a few points that will help you construct clear and concise changelog
notes:

- Use plain language, without technical jargon. Write your release notes like
  you are explaining them to a friend.
- Keep them short.
- If you’ve implemented a new feature, your changelog notes should contain a
  high-level summary of what it can do. But, of course, some more explanation on
  how to use it might be required, so provide a link to the detailed stuff, like
  a user guide, step-by-step instructions, etc.

In general, your changelog notes should answer the following questions:

- What has changed in the latest version of your product?
- Why has that thing changed?
- How does this change impact the user?
- What does the user need to do differently as a result?

Keep in mind that in most cases a project manager will notify a customer about
the new release and will also need to create a customer understandable abstract
from the changelog notes. Write changelog notes in such a way so that is easy to
write an abstract that communicates to the customer what value a specific
release brings to him.

### Zepyhr drivers

When creating a version entry for a Zephyr driver add a section which says for
which NCS version was the driver built. This information should be visible to
the developer which is deciding which version of driver to use so that it will
work with its NCS version of the project. Use the below template:

```markdown
### Compatibility

- This release was built and tested on the NCS version <version>.
```

## Releases 🚀

Taken from
https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases:

> Releases are deployable software iterations you can package and make available
> for a wider audience to download and use.

Releases are based on Git tags, which mark a specific point in your repository's
history. A tag date may be different from a release date since they can be
created at different times.

GitHub release consists of a git tag, some text (commonly referred to as Release
Notes) and artefacts (binaries, executables, any kind of documentation, etc.)

### Tagging and naming releases

Release tags and names consist of the letter `v` followed by a version number.

Below tags are all valid examples:

- `v0.1.4`
- `v0.9.3`
- `v1.0.0`
- `v1.1.0`
- `v1.12.45`
- `v5.0.0`

The name of a GitHub release should be identical to the tag that the release was
created from.

### Release notes

Release notes are identical to the changelog notes for that specific version of
a project and should be always kept in sync.

### Creating releases

Since we are following the [trunk-based development] branching model, a GitHub
release is created directly from a commit that was tagged with the release tag.

This process is automated with GitHub Actions with the "Basic" group of workflow
files. More about this
[here](https://github.com/IRNAS/irnas-workflows-software).

## Release artefacts naming scheme 📦

**Important**: this section is relevant only for software and firmware projects
as the release process for mechanical and hardware projects still yet needs to
be defined.

### General rules

- Names are written in lower-case letters.
- Names consist of several fields separated by dashes, which means that the
  fields themselves can not contain dashes.
- Some fields are mandatory and some are optional, as per project requirements.
- Underscores are not allowed.

### Naming scheme

The naming scheme that should be used for release objects:

```
{project}-{firmware_type}-{board_name}-{hardware_version}-{firmware_version}-{qualifiers}.{file_extension}
```

Fields `project` and `firmware_version` are the only mandatory ones, others
should be added to avoid any confusion when dealing with generated files. If the
`repo_type` of your GitHub project is `firmware` then the `hardware_version`
field is mandatory.

Explanation of fields:

- `project` - Project name, such as `blebeacon` or `tracker`
- `firmware_type` - The type of the firmware, needs to be added if the build
  system produces applications and bootloader firmware. It can be `app` (for
  application firmware or software) or `bl` (for bootloader firmware).
- `board_name` - If a project supports multiple boards, this field should be
  used to distinguish between different hardware boards, such as, `VYPER_GO` and
  `VYPER_30`.
- `hardware_version` - Hardware version of the board which consists of `hv` and
  a version number. Hardware versions such as `hv1.2.0`, `hv4.0.1` or `hv0.5.1`
  are all valid options.
- `version` - Version of the software/firmware which consists of `v` and a
  version number. Versions such as `v1.2.0`, `v4.0.1` or `v0.5.1` are all valid
  options.
- `qualifiers` - Optional field, can be repeated. See explanation below.
- `file_extension` - Depends on a generated object, could be `bin`, `elf`, `hex`
  or something else.

### Qualifiers

Qualifiers come in several forms:

- Misc qualifiers - examples: `log`, `dbg`, `dbgble`, `rf`
- 7 char Git hash - examples: `57fb962`, `a982467`, `6b3089c`

#### Misc qualifiers

These are special qualifiers that indicate that some special set of build flags
was used to build a release artefact. Release artefacts that are meant to be
used in the production do not contain any misc qualifiers.

Example scenario: you could be developing firmware that is used:

- in production, with debug logs turned off,
- in development, with debug logs turned on and
- in RF compliance tests, where the device behaves completely differently for
  testing purposes.

In that scenario production artefact would have no misc qualifier, development
artefact could have `log` qualifier and RF compliance artefact would have `rf`
qualifier.

A project that uses misc qualifiers should have its meaning and usage documented
in a visible place, such as the project's README.

#### Git hash

Git hash qualifiers are useful internal testing processes of the product and
where later identification is required. The version that precedes the qualifier
should be a version of the release that was **already released**.

**Important:** release artefacts should never contain git hash qualifiers.

### Valid release objects names

Below release names are all valid examples:

Simple firmware project:

- GitHub repo name: `irnas-blebeacon-firmware`
- Release artifacts: `blebeacon-hv1.4.0-v1.3.3.hex`

Firmware project with application and bootloader firmwares:

- GitHub repo name: `irnas-robot-firmware`
- Release artifacts:
  - `robot-app-hv1.4.0-v1.0.0.hex`
  - `robot-bl-hv1.0.0-v1.0.0.hex`

Firmware project with application and bootloader firmwares, and various sets of
build flags:

- GitHub repo name: `irnas-largerobot-firmware`
- Release artifacts:
  - `largerobot-app-hv1.4.0-v1.0.0.hex`
  - `largerobot-bl-hv1.0.0-v1.0.0.hex`
  - `largerobot-app-hv1.4.0-v1.0.0-log.hex`
  - `largerobot-bl-hv1.0.0-v1.0.0-log.hex`
  - `largerobot-app-hv1.4.0-v1.0.0-rf.hex`
  - `largerobot-bl-hv1.0.0-v1.0.0-rf.hex`

## GitHub labels management 🏷️

What are GitHub labels? From [GitHub's docs]:

> You can manage your work on GitHub by creating labels to categorize issues,
> pull requests, and discussions. You can apply labels in the repository the
> label was created in. Once a label exists, you can use the label on any issue,
> pull request, or discussion within that repository.

To organize and categorize issues we use a set of labels that are defined in the
[irnas-project-template] repository.

When creating a new project labels are automatically transferred if the new the
project used the `irnas-project-template` repository as a template.

If you want to use the labels in a project that was not created from the above
the template then read the next section.

### Usage

Below are some guidelines regarding the usage of labels:

- An Issue/PR without labels should not require labels to attract attention,
  therefore the default state should be label-less.
- Most of the labels have prefixes that organize them into groups:
  - `priority` - describes the immediacy of the attention required.
  - `state` - describes the decision state of the issue or pull request.
  - `type` - describes the type of the issue or pull request.
- Issue should have a maximum of one label per group.
- Some labels do not have prefixes, specifically `pull request` and `release` as
  they are created by the templates/CI.

Please note that the above guidelines are exactly that, guidelines, and not
rules. If your project requires a different set of labels, uses additional
groups, etc. then fell free to break the guidelines.

### Exporting labels to a project

To export labels from `irnas-project-template` to your you will need to install
and use GitHub's `gh` command line tool.

Install `gh` on Ubuntu by running the below commands:

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

Authenticate `gh` tool so it can communicate with GitHub:

```bash
gh auth login
```

_The easiest way is to just press enter on every choice and confirm in the web
browser._

To clone the labels from the template project to a project of your choice:

```bash
gh label clone IRNAS/irnas-projects-template --repo IRNAS/<repo_of_your_choice>
```

**Important:** Above command will only copy new labels to the destination repo.
Existing labels in the destination repository will not be modified or deleted.
To overwrite existing labels use `--force` flag.

## Production versions 🏭

<!-- TODO: Remove this when resolved  -->

**Warning ⚠️**: this section should not be implemented, as it is depended on the
entire project management workflow and it might be removed.

Some versions of the project will be used in the production environment. The
production environment is a final destination where the project will be put into
operation and thus will be used by the end-users. To ensure that the project
works in production it should go through testing and validation processes that
are specific to that project.

The testing entity (either IRNAS, the customer, or both) that performs these
processes has a final say if a specific version is suitable for the production
environment.

Taking the above into account, when a project version is being introduced into
the production environment two steps should be done:

1. Test and validation processes need to be documented and easily accessible.
2. When a version of a project is tested, validated, and signed by the testing
   entity this should be marked in its appropriate version entry in the
   changelog and release notes for easier later identification.

When marking a version as a production version please follow the below template,
**prepend it to the rest of the changelog/release notes**.

Try to keep the extra information to a minimum, if more information needs to be
communicated (such as tests, validation reports, etc.) those should be contained
in a separate linked document.

```markdown
### Production version

This version is used in production since _date_! This version has been tested
and validated by the _testing entity_ on _the testing date_ (or during _the
testing period_) and has been approved to be used in a production environment.
Documentation about the used test and validation processes can be found here:
_embedd link to Github, GitBook or something else_.

_Additional info here if needed._
```

Eventually, a new production version will be created. In that case, you should:

1. Perform the same steps as before, document test and validation processes that
   were used and mark a production version in the changelog and release notes.
2. Find the previous production version in the changelog and release notes,
   strikethrough the text related to the production version and add a text that
   points to the new production version, see example below.

```markdown
### Production version

~~This version is used in production since _date_! This version has been tested
and validated by the _testing entity_ on _the testing date_ (or during _the
testing period_) and has been approved to be used in the production environment.
Documentation about the used test and validation processes can be found here:
_embedd link to Github, GitBook or something else_.~~

~~_Additional info here if needed._~~

**This product version was superseded by the version _version number_. **
```

## Documentation 📖

There are two general places where project-related documentation can exist:

- GitBook
- Github

This section does not try to address documentation in the source code. That is a
separate topic.

### Gitbook

Documentation on the Gitbook is meant to be mostly written by the management.

Things like:

- project-related notes and ideas,
- mockups,
- project timeline projections,
- meeting notes,
- concepts and
- field research notes

all belong on the Gitbook.

Engineers and developers can also write to the GitBook on specific instructions.

### Github

Documentation on GitHub is meant to be mostly written by the engineers and
developers. It is written in form of markdown files either in `README.md` or in
the `docs` folder.

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

When looking at the documentation from a point of a specific release, the
documentation should be up to date and should reflect the behaviour and
implementation of the project at that point.

## Resources 🤓

The below section is a hot mess of links to various topics related to this
document, embedded systems and more.

Branching models/strategies/Git related:

- [Trunk Based Development](https://trunkbaseddevelopment.com/) - Exhaustive
  website on a newer, better way to do Git Branching.
- [Git Organised: A Better Git Flow](https://dev.to/render/git-organized-a-better-git-flow-56go) -
  Interesting article on how to separate documenting git commits from coding.
- [Git your reset on](https://changelog.com/podcast/480) - Podcast with the
  author of the above article.
- [Pro Git Book](https://git-scm.com/book/en/v2) - The main resource for
  learning Git.
- [Learn Git Branching](https://learngitbranching.js.org/) - Interactive browser
  game that helps you to learn Git branching.

Versioning:

- [SemVer](https://semver.org) - Versioning scheme used by many.
- [CalVer](https://calver.org/) - Another versioning scheme used by many.
- [zero0ver](https://0ver.org/) - Parody website on how many libraries misuse
  Semver.
- [Giving Your Firmware Build a Version](https://embeddedartistry.com/blog/2016/12/21/giving-your-firmware-build-a-version/)
  - Good article from Embedded Artistry about versioning in firmware-related
    context.
- [Proper Release Versioning Goes a Long Way](https://interrupt.memfault.com/blog/release-versioning) -
  Another good article about versioning from Memfualt.

Release naming:

- [Release naming conventions](https://www.drupal.org/docs/develop/git/git-for-drupal-project-maintainers/release-naming-conventions)
  - Naming conventions used by Drupal.

Changelog:

- [What makes a good changelog?](https://depfu.com/blog/what-makes-a-good-changelog) -
  Writing a good changelog, like writing any text, is about knowing your
  audience and their needs.

Awesome projects:

- [Awesome embedded](https://github.com/nhivp/Awesome-Embedded) - A curated list
  of awesome embedded resources.
- [Awesome C](https://github.com/oz123/awesome-c) - A curated list of C good
  stuff.
- [Awesome Zephyr RTOS](https://github.com/golioth/awesome-zephyr-rtos) - A
  curated list of Zephyr-related stuff.

[semver]: https://semver.org
[keep a changelog's]: https://keepachangelog.com/en/1.0.0/
[github's docs]:
  https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels
[irnas-project-template]:
  https://github.com/IRNAS/irnas-projects-template/labels
