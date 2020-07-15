# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change.

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Some help

If you make changes in your local environment and want to update that changes to the dotfiles repo, here is a code that can help you.

```python
#!/usr/bin/env python
"""
Executable module that copy all home changes to dotfiles repo

Functions:
    main
"""
import os
import pathlib
from shutil import copyfile
from typing import NoReturn, Tuple


EXCLUDED_FILES = (
    'CODE_OF_CONDUCT.md',
    'CONTRIBUTING.md',
    'LICENSE',
    'README.md',
    'screenshot.png',
    'SECURITY.md',
    'setup.sh',
)
EXCLUDED_DIRS = (
    '.github',
    '.git',
    'docs',
    'Pictures',
    'Workspaces',
)


def main(excluded_files: Tuple[str], excluded_dirs: Tuple[str]) -> NoReturn:
    """
    Copy all home changes to dotfiles repo

    Args:
        excluded_files: relative path of files to exclude
        excluded_dirs: relative path of dirs to exclude
    """

    root = pathlib.Path.cwd()

    if root.name != 'dotfiles':
        raise Exception('Need to be in dotfiles repo')

    excluded_filespath = [root.joinpath(filepath) for filepath in excluded_files]
    excluded_dirspath = [root.joinpath(dirpath) for dirpath in excluded_dirs]
    files_to_update = []
    for subdir, dirs, files in os.walk(root):
        del dirs
        subdir_path = pathlib.Path(subdir)

        if subdir_path in excluded_dirspath or any((dirpath in subdir_path.parents for dirpath in excluded_dirspath)):
            continue

        files_to_update.extend(
            (subdir_path.joinpath(file) for file in files if subdir_path.joinpath(file) not in excluded_filespath)
        )

    relative_paths = [pathlib.Path(file).relative_to(root) for file in files_to_update]
    home = pathlib.Path.home()
    for file in relative_paths:
        copyfile(home.joinpath(file), root.joinpath(file))


if __name__ == "__main__":
    main(EXCLUDED_FILES, EXCLUDED_DIRS)
```
