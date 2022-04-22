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

[This](https://dev.to/brad_beggs/vs-code-vertical-rulers-for-prettier-code-3gp3) article shows how to setup rulers in VS Code.

