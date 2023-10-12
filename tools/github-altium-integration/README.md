# Github and Altium integration

Altium does not allow for easy integration with Github. It does, however, commit its changes to the Altium365 cloud. This is a simple workaround, which takes the latest Altium commit and pushes it to a selected Github repository.

**The workaround is implemented in a `batch` file, which can only be run on Windows.**

## How it works

1. The user is prompted to enter the local path to the Altium project.
2. The program checks if a `.git-remote` file exists in the project directory. If it does not, the user is prompted to enter the remote Github repository URL.
3. The default Altium365 remote URL is changed to the Github remote URL.
4. Changes are pushed to the master branch of Github repository.
5. The remote URL is changed back to the original Altium remote URL.

## How to run

The program should be placed in some directory. Take note of the path and run the program. For example:

```bash
C:\Users\User\Desktop\execute_git_commit.bat
```

The program accepts a `reset` keyword, which resets the remote Github URL, prompting the user to enter it again. For example:

```bash
C:\Users\User\Desktop\execute_git_commit.bat reset
```

## Planned Work

- [ ] Bug fixes found during the usage of the program.
- [ ] Setup script, which installs the program to some location and adds it to the PATH. This would allow for easy execution from any directory.