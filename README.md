<p align="center">
  <img src="images/irnas-logo.png" alt="irnas-logo" width=400 ><br><br>
</p>

# IRNAS Guidelines

This repository contains guidelines related to various aspects of managing GitHub repositories at IRNAS and working with them.

## Table of Contents 📜


<!-- vim-markdown-toc GFM -->

* [Branching model 🌲](#branching-model-)
    * [Key concepts](#key-concepts)
    * [Deviations from GitFlow article](#deviations-from-gitflow-article)
    * [Feature branches](#feature-branches)
* [Repository naming scheme 📝](#repository-naming-scheme-)
    * [General rules](#general-rules)
    * [Naming scheme](#naming-scheme)
* [Versioning and tagging 🏷️](#versioning-and-tagging-)
    * [Software/Firmware projects](#softwarefirmware-projects)
    * [Hardware projects](#hardware-projects)
    * [Mechanical projects](#mechanical-projects)
* [Changelog 📋](#changelog-)
    * [Content of changelog notes](#content-of-changelog-notes)
    * [Zepyhr drivers](#zepyhr-drivers)
* [Releases 🚀](#releases-)
    * [Tagging and naming releases](#tagging-and-naming-releases)
    * [Release notes](#release-notes)
    * [Creating releases](#creating-releases)
* [Release artifacts naming scheme 📦](#release-artifacts-naming-scheme-)
    * [General rules](#general-rules-1)
    * [Naming scheme](#naming-scheme-1)
    * [Qualifiers](#qualifiers)
        * [Misc qualifiers](#misc-qualifiers)
        * [Git hash](#git-hash)
    * [Valid release objects names](#valid-release-objects-names)
* [Production versions 🏭](#production-versions-)

<!-- vim-markdown-toc -->

## Branching model 🌲

<p align="center">
  <img src="images/gitflow-atlassian.svg" alt="gitflow" width=600 ><br><br>
    <i>GitFlow branching diagram, source: <a href="https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow">Atlassian</a></i><br>

</p>

The IRNAS's Git branching model is based on the [GitFlow] branching model with some small differences.

### Key concepts

Each repository needs to have two long-lived branches, `master` and `dev`.

* `master` branch should always contain production-ready code, which should be committed to it in form of a GitHub Pull Request.
Nothing should be committed to it directly (exceptions can be made for GitHub CI workflows, which can otherwise misbehave).
* `dev` branch contains the latest development changes for the next release.
Commits to it can be done to it directly or in form of GitHub Pull requests.

Besides these two branches, various short-lived branches exist in this workflow.
They can be classified into three categories: feature, release, and hotfix.

* feature branches are used to develop new features.
They always branch from and back into the `dev` branch, never in `master`.
They are named as `feature/*`, for example, names `feature/new-board` and `feature/refactor` are both valid feature branch names.
* release branches are used for the preparation of a new release.
They allow for last-minute changes.
They are always created from the `dev` branch and merged into the `master` branch.
They are named as `release/<version>`, where `<version>` indicates the version of the next release.
* hotfix branches are used to address unplanned changes to the release in production.
The essence is that the work of team members can continue, while another person is preparing a quick production fix.
Hotfix branches must always branch from the `master` branch and merge back into it.

It is important that after every merge into the `master` branch a Pull Request is made from `master` back into `dev`, to bring in the changes that were made during the release process in release and hotfix branches.

### Deviations from GitFlow article

* Use `dev` instead of `develop`.
* When tagging tags add `v-` prefix, so `v1.0.0` instead of `1.0.0`.
* Use slash `/` instead of dash `-` when naming release, hotfix and feature branches, so `release/v1.0.0` instead of `release-v1.0.0`.

###  Feature branches

A few things should be kept in mind when working with feature branches:
* They should be focused on accomplishing one thing.
* They should be small, they should take up to 1 day of work to complete and to open Pull Request back into the `dev` branch.

This enables smaller feedback loops, as Pull Request reviews become more digestible for the reviewers.

## Repository naming scheme 📝

### General rules

* Names are written in lowercase letters.
* Names consists of several fields separated by dashes, which means that the fields themselves can not contain dashes.
* Some fields are mandatory, some of them are optional, as per project requirements.
* Underscores are not allowed.

### Naming scheme

The naming scheme that should be used for naming GitHub repositories:
```
{client}-{project}-[{specifier}-]{repo_type}
```

Explanation of fields:
* `client` - Client's name, such as `irnas`, `fabrikor`, `companyinc`.
* `project` - Project name, such as `controller`, `beacon`, `robot`.
* `specifier` - Used to specify chip name, sensor name, or similar, such as `nrf92`, `nrf52`, `scp40`.
This field is optional.
Use only when specifying additional information that distinguishes codebases, such as for example two MCUs on the same PCB.
* `repo_type` - Possible options are:
    * `firmware` - `C/C++` project for microcontrollers, projects for RPi,
    * `driver` - `C/C++` project for a sensor, communication module driver,
    * `hardware` - PCB hardware project,
    * `mechanical` - mechanical CAD project,
    * `software` - software project, for example Python tooling or a web app,
    * `application` - Android/iOS application project,
    * `docs` - Project used just for the documentation.

It can happen that your new GitHub project does not fit preceding `repo_type` options, in that case, please describe it succinctly, in one word.

When creating fields `client` and `project` for a new project long names should be avoided, the soft limit is around 12 characters.
Character shortening techniques such as abbreviations, internal codenames and concatenations of multiple words are allowed to satisfy the limit, __however, overall clarity should not be compromised__.

Some examples include:
- `irnas-blebeacon-firmware`
- `irnas-userapp-application`
- `irnas-lis2-driver`
- `fabrikor-3dprinter-nrf91-firmware`
- `fabrikor-3dprinter-nrf52-firmware`
- `irnas-guidelines-docs`

## Versioning and tagging 🏷️

The versioning scheme consists of 3 numbers separated by dots:
```
{major}.{minor}.{bugfix}
```

Following versions are all valid examples:
* `0.1.4`
* `0.9.3`
* `0.9.10`
* `1.0.0`
* `1.1.0`
* `1.12.45`
* `5.0.0`

Numbering was inspired by [SemVer] convention.
We deviate from their rules on version incrementing, as the SemVer convention makes more sense when you are developing libraries that are consumed by the developers and not in the sense of our product development.

Starting version and how it is incremented depends on the type of the project.

### Software/Firmware projects

Given preceding versioning scheme increment:
1. a`major` number when releasing a new, initial stable version of a product (`1.0.0`) or making any conceptual change, major rewrite, major documentation changes, a new generation of a product or any other change which requires additional human involvement.
2. a `minor` number when adding new features, enhancements, documentation in a backwards-compatible manner and
3. a `bugfix` number when you make backwards-compatible bug fixes.

New projects should start with a version `0.1.0` and continue from there.

### Hardware projects

Given preceding versioning scheme increment:
1. a `major` number for major layout and schematic changes such as changes to board dimensions, components placement or general functionality and
2. a `minor` number for minor layout and schematic changes such as component value changes, layout routing, copper fills, etc.

Number `bugfix` is never incremented and is always set to `0`.
New projects should start with a version `1.0.0` and continue from there.

### Mechanical projects

Given preceding versioning scheme increment:
1. a `major` number for major changes such as changes to dimensions, components placement or general functionality and
2. a `minor` number for minor changes such as fixes, etc.

Number `bugfix` is never incremented and is always set to `0`.
New projects should start with a version `1.0.0` and continue from there.

## Changelog 📋

A changelog is a file that contains a curated, chronologically ordered list of notable changes for each version of a project.
Changelog makes it easier for users and engineers to see precisely what notable changes have been made between each version of the project.

IRNAS's changelog format is based on the [Keep a Changelog's] format, we follow it almost to a point with some minor additions and modifications.

This means that:
* We follow its overall structure in markdown, which can be seen at the top of the page.
* We follow its _guiding principles_, however, we define our versioning scheme.
* Each version entry needs to be linkable, where the link points to a page showing the comparison between that version and the previous one.
* Each bullet line should finish with a period dot.

The same types of changes should be grouped under one of the following groups:
* `Added` for new features,
* `Changed` for changes in existing functionality,
* `Deprecated` for soon-to-be removed features,
* `Removed` for now removed features,
* `Fixed` for any bug fixes and
* `Security` in case of vulnerabilities.

### Content of changelog notes

Changelog notes can be seen as a common point between development and business.

Below are a few points that will help you construct clear and concise changelog notes:
* Use plain language, without technical jargon.
Write your release notes like you are explaining them to a friend.
* Keep them short.
* If you’ve implemented a new feature, your changelog notes should contain a high-level summary of what it can do.
But, of course, some more explanation on how to use it might be required, so provide a link to the detailed stuff, like a user guide, step-by-step instructions, etc.

In general, your changelog notes should answer the following questions:
* What has changed in the latest version of your product?
* Why has that thing changed?
* How does this change impact the user?
* What does the user need to do differently as a result?

### Zepyhr drivers

When creating a version entry for a Zepyhr driver add a section which says on which NCS version was the driver built.
This information should be visible to the developer which is deciding which version of driver to use so that it will work with its NCS version of the project.
Use below template:
```markdown

### Compatibility

-    This release was built and tested on NCS version <version>.
```

## Releases 🚀

Taken from https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases:

> Releases are deployable software iterations you can package and make available for a wider audience to download and use.
Releases are based on Git tags, which mark a specific point in your repository's history.
A tag date may be different from a release date since they can be created at different times.

GitHub release consists of a git tag, some text (commonly referred to as Release Notes) and artifacts (binaries, executables, any kind of documentation, etc.)

### Tagging and naming releases

Release tags and names consist of the letter `v` followed by a version number.

Below tags are all valid examples:
* `v0.1.4`
* `v0.9.3`
* `v1.0.0`
* `v1.1.0`
* `v1.12.45`
* `v5.0.0`

The name of a GitHub release should be identical to the tag that the release was created from.

### Release notes

Release notes are identical to the changelog notes for that specific version of a project and should be always kept in sync.

### Creating releases

Since we are following [GitFLow] branching model, a GitHub release is always created after a release branch is merged into the master branch and the tag has been created.

This process can be/is automated with GitHub Actions.

## Release artifacts naming scheme 📦

**Important** : this section is relevant only for software and firmware projects as the release process for mechanical and hardware projects still yet needs to be defined.

### General rules

* Names are written in lowercase letters.
* Names consists of several fields separated by dashes, which means that the fields themselves can not contain dashes.
* Some fields are mandatory, some of them are optional, as per project requirements.
* Underscores are not allowed.

### Naming scheme

The naming scheme that should be used for release objects:
```
{project}-{firmware_type}-{board_name}-{hardware_version}-{firmware_version}-{qualifier}.{file_extension}
```

Fields `project`, `firmware_version` are the only ones that are mandatory, others should be added to avoid any confusion when dealing with generated files.
If the `repo_type` of your GitHub project is `firmware` then `hardware_version` field is mandatory.

Explanation of fields:
* `project` - Project name, such as `blebeacon` or `tracker`
* `firmware_type` - Type of the firmware, needs to be added if build system produces applications and bootloader firmware. It be `app` (for application firmware or software) or `bl` (for bootloader firmware).
* `board_name` - If a project supports multiple boards, this field should be used to distinguish between different hardware boards, such as, `VYPER_GO` and `VYPER_30`.
* `hardware_version` - Hardware version of the board which consists of `hv` and a version number. Hardware versions such as `hv1.2.0`, `hv4.0.1` or `hv0.5.1` are all valid options.
* `version` - Version of the software/firmware which consists of `v` and a version number. Versions such as `v1.2.0`, `v4.0.1` or `v0.5.1` are all valid options.
* `qualifier` - Optional field, see explanation below.
* `file_extension` - Depends on a generated object, could be `bin`, `elf`, `hex` or something else.

### Qualifiers

Qualifiers come in several forms:

* Misc qualifiers - examples: `log`, `dbg`, `dbgble` `rf`
* 7 char Git hash - examples: `57fb962`, `a982467`, `6b3089c`

#### Misc qualifiers

These are special qualifiers that indicate that some special set of build flags was used to build a release artifact.
Release artifacts that are meant to be used in the production do not contain any misc qualifiers.

Example scenario: you could be developing firmware that is used:
* in production, with debug logs turned off,
* in development, with debug logs turned on and
* in RF compliance tests, where device behaves completely differently for the purposes of testing.

In that scenario production artifact would have no misc qualifier, development artifact could have `log` qualifier and RF compliance artifact would have `rf` qualifier.

Project that uses misc qualifiers should have their meaning and usage documented in a visible place, such as project's README.

#### Git hash

Git hash qualifiers are useful internal testing processes of the product and where later identification is required.
The version that precedes the qualifier should be a version of the release that was **already released**.

**Important:** release artifacts should never contain git hash qualifiers.

### Valid release objects names

Below release names are all valid examples:

Simple firmware project:
* GitHub repo name: `irnas-blebeacon-firmware`
* Release artifacts: `blebeacon-hv1.4.0-v1.3.3.hex`


Firmware project with application and bootloader firmwares:
* GitHub repo name: `irnas-robot-firmware`
* Release artifacts:
    - `robot-app-hv1.4.0-v1.0.0.hex`
    - `robot-bl-hv1.0.0-v1.0.0.hex`

Firmware project with application and bootloader firmwares, and various sets of build flags:
* GitHub repo name: `irnas-largerobot-firmware`
* Release artifacts:
    - `largerobot-app-hv1.4.0-v1.0.0.hex`
    - `largerobot-bl-hv1.0.0-v1.0.0.hex`
    - `largerobot-app-hv1.4.0-v1.0.0-log.hex`
    - `largerobot-bl-hv1.0.0-v1.0.0-log.hex`
    - `largerobot-app-hv1.4.0-v1.0.0-rf.hex`
    - `largerobot-bl-hv1.0.0-v1.0.0-rf.hex`


## Production versions 🏭

Some versions of the project will be used in the production environment.
The production environment is a final destination where the project will be put into operation and thus will be used by the end-users.
To ensure that the project works in production it should go through testing and validation processes that are specific to that project.

The testing entity (either IRNAS, the customer, or both) that performs these processes has a final say if a specific version is suitable for the production environment.

Taking the above into account, when a project version is being introduced into the production environment two steps should be done:
1. Test and validation processes need to be documented and easily accessible.
2. When a version of a project is tested, validated, and signed by the testing entity this should be marked in its appropriate version entry in the changelog and release notes for easier later identification.

When marking a version as a production version please follow the below template, **prepend it to the rest of changelog/release notes**.

Try to keep the extra information to a minimum, if more information needs to be communicated (such as test, validation reports, etc.) those should be contained in a separate linked document.

```markdown
### Production version

This version is used in the production since _date_!
This version has been tested and validated by the _testing entity_ on _testing date_ (or during _the testing period_) and has been approved to be used in a production environment.
Documentation about the used test and validation processes can be found here: _embedd link to Github, GitBook or something else_.

_Additional info here if needed._
```

Eventually, a new production version will be created.
In that case, you should:
1. Perform the same steps as before, document test and validations processes that were used and mark a production version in the changelog and release notes.
2. Find the previous production version in the changelog and release notes, strikethrough the text related to the production version and add a text that points to the new production version, see example below.


```markdown
### Production version

~~This version is used in the production since _date_!
This version has been tested and validated by the _testing entity_ on _testing date_ (or during _the testing period_) and has been approved to be used in the production environment.
Documentation about the used test and validation processes can be found here: _embedd link to Github, GitBook or something else_.~~

~~_Additional info here if needed._~~

**This product version was superseded by the version _version number_. **
```

[GitFlow]: https://nvie.com/posts/a-successful-git-branching-model
[SemVer]: https://semver.org
[Keep a Changelog's]: https://keepachangelog.com/en/1.0.0/
