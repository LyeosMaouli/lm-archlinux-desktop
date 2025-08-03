# Fonts

Font files for Hyprland desktop environment.

## Directory Structure
- `JetBrainsMono/` - JetBrains Mono font files
- `NerdFonts/` - Nerd Font variants with icon support

## JetBrains Mono
1. Download from: https://www.jetbrains.com/lp/mono/
2. Extract font files to `JetBrainsMono/` directory
3. Install: `sudo cp JetBrainsMono/*.ttf /usr/share/fonts/TTF/`
4. Update cache: `fc-cache -fv`

**Required:** Regular, Bold, Italic, BoldItalic, Light, Medium variants

## Nerd Fonts
1. Download from: https://www.nerdfonts.com/font-downloads
2. Recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font, Source Code Pro Nerd Font
3. Extract to `NerdFonts/` directory
4. Install: `sudo cp NerdFonts/*.ttf /usr/share/fonts/TTF/`
5. Update cache: `fc-cache -fv`

**Usage:** Provides icon glyphs for Waybar, terminal prompts, file managers, status indicators

## Configuration
Fonts are configured in:
- `configs/ansible/roles/hyprland_desktop/templates/kitty.conf.j2`
- Waybar configuration files
- GTK font settings