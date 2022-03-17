<p align="center">
  <img src="images/irnas-logo.png" alt="irnas-logo" width=400 ><br><br>
</p>

# IRNAS Guidelines

This repository contains guidelines related to various aspects of managing GitHub repositories at IRNAS and working with them.

## Table of Contents 📜


<!-- vim-markdown-toc GFM -->

* [Branching model 🌲](#branching-model-)
    * [Key Concepts](#key-concepts)
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
* [Releases 🚀](#releases-)
* [Release artifacts naming scheme 📦](#release-artifacts-naming-scheme-)

<!-- vim-markdown-toc -->

## Branching model 🌲

<p align="center">
  <img src="images/gitflow-atlassian.svg" alt="gitflow" width=600 ><br><br>
    <i>GitFlow branching diagram, source: <a href="https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow">Atlassian</a></i><br>

</p>

The IRNAS's Git branching model is based on the [GitFlow] branching model with some small differences.

### Key Concepts

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

## Releases 🚀

## Release artifacts naming scheme 📦

[GitFlow]: https://nvie.com/posts/a-successful-git-branching-model
[SemVer]: https://semver.org
