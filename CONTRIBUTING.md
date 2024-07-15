# Contributing to Nyx Converter

The rules are quite simple.

## Issue
- First, make sure that there is a [issue](https://github.com/xaus-group/nyx_converter/issues) that you decide to solve

## Fork the Repository
- Head over to the [nyx_converter](https://github.com/xaus-group/nyx_converter) repository on GitHub.
- Click on "Fork" to create your own copy of the repository.

## Clone your Fork
- Open your terminal and use git clone to clone your forked repository to your local machine.
```bash
git clone https://github.com/xaus-group/nyx_converter.git
```

## Install Dependencies
- Navigate to your cloned directory then run `pub get` to install the project dependencies.

## Create a Branch
- Use `git checkout -b <branch-name>` to create a new branch for your changes.
- Make sure that the `<branch-name>` includes the issue tag (e.g., 11-fix-bug-xyz, 11-add-feature-abc)

## Implement your Changes
- Make your code changes and write unit tests for your changes.

## Commit your Changes
- Use `git add <filename>` to add specific files to the staging area or `git add .` to add all modified files.
- Run `git commit -m "<commit message>"` to commit your changes with a clear and concise commit message.

## Push your Changes
Use `git push origin <branch-name>` to push your changes to your forked repository.



## Pull requests
- you open a pull request which should be named the same as issue.
- Click on "Pull requests" and then "New pull request".
- Select the branch containing your changes and create a pull request.

## Additional Notes
- **Testing:** Please ensure your changes are covered by unit tests and passed by github actions.
- **Documentation:** If your contribution includes new features, consider updating the documentation accordingly.

