Neovim Configuration for MacBook Pro M3

<img width="853" alt="image" src="https://github.com/inarvos/Neovim-Mac-Pro-M3/assets/37037175/98eadf13-0f16-449b-8982-8cd435dbf740">


Welcome to my Neovim configuration repository! This is my current setup, tailored for Python development. This configuration is under active development and continuously evolving to support additional languages and improve functionality.



Overview

- Plugin Manager: https://github.com/wbthomason/packer.nvim
- Current Focus: Python programming
- Future Plans: Extend support for C, C#, C++, and Java


![image](https://github.com/inarvos/Neovim-Mac-Pro-M3/assets/37037175/ecce67d0-6738-4767-a574-e25e4f1fa2ad)



Features

- Core Configurations:

This configuration sets Neovim to use UTF-8 encoding for compatibility and includes sensible defaults like showing both absolute and relative line numbers for better navigation. It enables smart and auto-indentation to maintain code consistency and enhances search capabilities with case-insensitive search that respects case when necessary. Mouse support is enabled in all modes to improve usability. File Explorers are included for intuitive file navigation.

- Coding:

For coding, this setup includes powerful plugins such as 'nvim-lspconfig' for Language Server Protocol (LSP) configurations, currently supporting Python through Pyright and Lua for Neovim development. It also features autocompletion via 'nvim-cmp', integrated with sources for LSP, buffers, paths, and more. Code formatting is handled by Prettier, ensuring consistent code style across files. The configuration leverages Tree-sitter for enhanced code highlighting and folding, making it easier to read and navigate complex codebases.
Additionally, it includes comprehensive Git integration with plugins like Fugitive and Gitsigns, providing essential Git commands and visual indicators within Neovim.

- Keybindings and Design:

Custom key mappings are set to improve efficiency. Navigation, window management, and terminal integration are streamlined with thoughtful keybindings. For visual enhancements, multiple colorschemes are available, alongside a customizable status line provided by Lualine. This setup ensures a pleasant and productive coding environment with support for 24-bit RGB colors and various other UI improvements.

- Utility Functions and Comments:

Utility functions are included to reload Neovim configurations on the fly, check if plugins are installed, and set key mappings easily. Each configuration file is thoroughly commented to explain the purpose and functionality of the settings and plugins used, making it easy to understand and customize the setup.



Comments and Documentation

Each configuration file is thoroughly commented to explain the purpose and functionality of the settings and plugins used. This makes it easy for anyone to understand and customize the setup according to their needs.
