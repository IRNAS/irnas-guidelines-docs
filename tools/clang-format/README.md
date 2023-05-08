# How to setup clang-format for VS Code for Zephyr/nRF5 development

1. Run below command to install clang related tooling:

```bash
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 14 all
rm llvm.sh
```

2. Run below command to install VS Code extension:

```bash
code --install-extension xaver.clang-format
```

3. Add below lines to your `~/.config/Code/User/settings.json`

```json
    "clang-format.executable": "/usr/bin/clang-format-14",
    "[c]": {
        "editor.defaultForamtter": "xaver.clang-format",
        "editor.detectIndentation": false,
        "editor.tabSize": 8,
        "editor.insertSpaces": false,
        "editor.rulers": [80]
    },
    "files.associations": {
        "*.h": "c"
    }
```

4. Copy `.clang-format` file from this repo to your project.

5. Open VS Code and test formating

## Extra

### Disabling formatting on a piece of code

Sometimes you do not want to format some pieces of code, for example you might
implement large data structures with arrays and structs that better look better
if you apply whitespace manually instead of letting clang-format to do it
automatically.

You can do that by wrapping blocks of code that you don't want to format with
special comments, see example below:

```C
int formatted_code;
/* clang-format off */
    void    unformatted_code  ;
/* clang-format on */
void formatted_code_again;
```

More about this feature can be found
[here](https://clang.llvm.org/docs/ClangFormatStyleOptions.html#disabling-formatting-on-a-piece-of-code).

### Rulers

[This](https://dev.to/brad_beggs/vs-code-vertical-rulers-for-prettier-code-3gp3)
article shows how to setup rulers in VS Code and style them.
