# Ignoreit 🫥
A neovim plugin to generate .gitignore file and place it in your project root. The gitignore content is fetched from https://www.toptal.com/developers/gitignore/api/

# Dependencies

- curl
- (Optional) [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- (Optional) [snacks.nvim](https://github.com/folke/snacks.nvim)

# Supported Platforms
Only tested on archlinux, with neovim v0.10.4 and v0.11.0. Older neovim may work.

# Usage
- `Gitignore`: Generate gitignore file iteratively. A telescope window will popup for selecting desired language.
- `Gitignore <lang>`: Generate gitignore file corresponding to `<lang>` language directly.

# Configuration

`Ignoreit` has the following configurable options.
```lua

{
    picker_provider = "telescope" | "snacks" | "ui_select" -- (backend to provide picker 
                                                           -- ui when triggering `Gitignore`
                                                           -- command. default: "snacks")
}
```


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
