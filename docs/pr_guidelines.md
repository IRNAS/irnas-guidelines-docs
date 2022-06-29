# PR guidelines
## Commits
- Commits need to be grouped together into sensible units.
- The code needs to be buildable in every commit.

## PRs
- Clean the code before submitting it for the review:
	- rebase back to state of the development branch,
	- then logically stage changes (group, split or rewrite commits), 
	- and note that any in progress code should be stashed
- When opening a PR, write a clear description about the code, what it's trying to achieve, add links to documentation, issues, etc. 
- Also add instructions for the reviewer:
	- order in which he should look at the files
	- which files and/or commits are a priority

## Review
As a reviewer, especially pay attention to:
- Docstrings and comments,
- Function and enum names - they need to make sense and be descriptive enough.

Review should be made per commit, starting with the oldest. You should look at the files in each commit in the following order:
1. header files (.h),
2. code files (.c, .cpp, etc.),
3. usage and/or sample files (main.c, wrappers, etc.)

