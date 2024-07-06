Neovim Configuration for MacBook Pro M3.

<img width="790" alt="Screenshot 2024-06-19 at 12 51 03" src="https://github.com/inarvos/Neovim-Mac-Pro-M3/assets/37037175/ab0aa901-d050-4ec2-a996-e36b0ea430ac">
 


Welcome to the ultimate Neovim configuration. This repository provides a highly optimized setup for Python, C, C#, C++, and Java development, and seamless integration with VSCode.



Overview:

This repository features a meticulously crafted Neovim setup designed to enhance your coding experience. The configuration includes a wide array of plugins, custom keybindings, and comprehensive settings, all documented to ensure ease of use and customization.

![image](https://github.com/inarvos/Neovim-Mac-Pro-M3/assets/37037175/ecce67d0-6738-4767-a574-e25e4f1fa2ad)
 


Key Features:

- Plugin Management:
  - Packer: Efficient plugin management with [Packer](https://github.com/wbthomason/packer.nvim), making it easy to install, update, and manage plugins.

- Core Configurations:
  - General Settings:
    - UTF-8 encoding to ensure compatibility with a wide range of text files.
    - Auto-indentation based on file type to maintain consistent code formatting.
    - Enhanced search capabilities with case-insensitive search by default, switching to case-sensitive if an uppercase letter is used.
    - Mouse support enabled across all modes for ease of use.
    - Backup, undo, and swap files are handled appropriately to prevent data loss.
    - Timeout settings adjusted for better responsiveness and user experience.
    - Integration of file explorers for intuitive and efficient file management.
    - A lot more...



<img width="1255" alt="Screenshot 2024-06-19 at 13 26 07" src="https://github.com/inarvos/Neovim-Mac-Pro-M3/assets/37037175/47977065-b97c-4029-9bc5-817187c38343">
 


Development Enhancements:
- Language Server Protocol (LSP):
  - Configured LSP support for Python, C, C#, C++, Lua, and Java.
  - `nvim-lspconfig` for easy integration and setup of language servers.
  - Automatic installation of LSP servers using `nvim-lsp-installer`.

- Autocompletion:
  - `nvim-cmp` providing intelligent autocompletion integrated with sources like LSP, buffers, and paths.
  - Snippet support with `LuaSnip`.

- Syntax Highlighting & Formatting:
  - Tree-sitter for advanced syntax highlighting and code folding.
  - Prettier for consistent code formatting across files.

- Version Control:
  - Git integration with Fugitive for essential Git commands within Neovim.
  - Gitsigns providing visual Git indicators and inline blame information.

VSCode Integration:
- Neovim Integration with VSCode:
  - Seamlessly integrate Neovim as the backend for VSCode using the [vscode-neovim](https://github.com/asvetliakov/vscode-neovim) extension.
  - Enjoy the power and flexibility of Neovim within the VSCode environment, combining the best of both editors using `settings.json` and `keybindings.json` in the vscode folder.



<img width="1699" alt="Screenshot 2024-06-19 at 13 04 59" src="https://github.com/inarvos/Neovim-Mac-Pro-M3/assets/37037175/50163928-122e-4912-a6f2-f8e2099686e3">
 



User Interface:
- Visual Enhancements:
  - Multiple colorschemes to suit different preferences.
  - Customizable status line using Lualine.
  - 24-bit RGB color support for a vibrant coding environment.

- Keybindings & Shortcuts:
  - Custom key mappings for improved efficiency.
  - Streamlined navigation, window management, and terminal integration.

Utility Functions:
- Functions to reload Neovim configurations seamlessly.
- Check plugin installations and set key mappings easily.
- Thoroughly commented configuration files explaining each setting and plugin for easy customization.



<img width="1111" alt="Screenshot 2024-06-19 at 13 11 00" src="https://github.com/inarvos/Neovim-Mac-Pro-M3/assets/37037175/702a2d06-9fd7-4f64-a2e1-4ef999cd1f83">
 


Installation & Setup:

  1. Clone the repository:
    git clone https://github.com/inarvos/Neovim-Mac-Pro-M3.git ~/.config/nvim

  2. Install Packer:
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim

  3. Install Plugins:
    Open Neovim and run :PackerInstall.

  4. LSP Configuration:
    Ensure that language servers are installed for the desired programming languages (you can use my [terminal repository](https://github.com/inarvos/terminal)).

  5.	VSCode Integration:
    Install the [vscode-neovim](https://github.com/asvetliakov/vscode-neovim) extension in VSCode and configure it to use Neovim.

<img width="1728" alt="Screenshot 2024-07-06 at 13 49 46" src="https://github.com/inarvos/Neovim-Mac-Pro-M3/assets/37037175/44de8a03-d81c-4598-b25c-bac168f13355">



Comments and Documentation:

Each configuration file is thoroughly commented to explain the purpose and functionality of the settings and plugins used. This makes it easy for anyone to understand and customize the setup according to their needs.
