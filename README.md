# Ignoreit 🫥
A neovim plugin to generate .gitignore file and place it in your project root. The gitignore content is fetched from https://www.toptal.com/developers/gitignore/api/

# Dependencies

- curl
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

# Supported Platforms
Only tested on archlinux, with neovim v0.10.4. Older neovim should work.

# Usage
- `Gitignore`: Generate gitignore file iteratively. A telescope window will popup for selecting desired language.
- `Gitignore <lang>`: Generate gitignore file corresponding to `<lang>` language directly.

# Plugin structure

```
.
├── doc
│   ├── ignoreit.txt
│   └── tags
├── LICENSE
├── lua
│   ├── ignoreit
│   │   ├── funcs.lua
│   │   ├── lang_list.lua
│   │   └── rooter.lua
│   └── ignoreit.lua
├── Makefile
├── plugin
│   └── ignoreit_entry.lua
├── README.md
└── tests
    ├── ignoreit
    │   └── test.lua
    └── minimal_init.lua
```
