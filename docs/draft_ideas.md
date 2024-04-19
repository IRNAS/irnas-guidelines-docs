# Draft ideas

This file contains various draft ideas, unfinished work or just work that we currently do not use.

## Production versions 🏭

<!-- TODO: Remove this when resolved  -->

**Warning ⚠️**: this section should not be implemented, as it is depended on the entire project
management workflow and it might be removed.

Some versions of the project will be used in the production environment. The production environment
is a final destination where the project will be put into operation and thus will be used by the
end-users. To ensure that the project works in production it should go through testing and
validation processes that are specific to that project.

The testing entity (either IRNAS, the customer, or both) that performs these processes has a final
say if a specific version is suitable for the production environment.

Taking the above into account, when a project version is being introduced into the production
environment two steps should be done:

1. Test and validation processes need to be documented and easily accessible.
2. When a version of a project is tested, validated, and signed by the testing entity this should be
   marked in its appropriate version entry in the changelog and release notes for easier later
   identification.

When marking a version as a production version please follow the below template, **prepend it to the
rest of the changelog/release notes**.

Try to keep the extra information to a minimum, if more information needs to be communicated (such
as tests, validation reports, etc.) those should be contained in a separate linked document.

```markdown
### Production version

This version is used in production since _date_! This version has been tested and validated by the
_testing entity_ on _the testing date_ (or during _the testing period_) and has been approved to be
used in a production environment. Documentation about the used test and validation processes can be
found here: _embed link to Github, GitBook or something else_.

_Additional info here if needed._
```

Eventually, a new production version will be created. In that case, you should:

1. Perform the same steps as before, document test and validation processes that were used and mark
   a production version in the changelog and release notes.
2. Find the previous production version in the changelog and release notes, strikethrough the text
   related to the production version and add a text that points to the new production version, see
   example below.

```markdown
### Production version

~~This version is used in production since _date_! This version has been tested and validated by the
_testing entity_ on _the testing date_ (or during _the testing period_) and has been approved to be
used in the production environment. Documentation about the used test and validation processes can
be found here: _embed link to Github, GitBook or something else_.~~

~~_Additional info here if needed._~~

**This product version was superseded by the version _version number_. **
```

## Labels

### Exporting labels to a project

To export labels from the `irnas-project-template` repo to your own you will need to install and use
GitHub's `gh` command line tool.

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

_The easiest way is to just press enter on every choice and confirm in the web browser._

To clone the labels from the template project to a project of your choice:

```bash
gh label clone IRNAS/irnas-projects-template --repo IRNAS/<repo_of_your_choice>
```

**Important:** Above command will only copy new labels to the destination repo. Existing labels in
the destination repository will not be modified or deleted. To overwrite existing labels use
`--force` flag.
