# Wallpapers

Wallpaper collections for Hyprland desktop environment.

## Structure
- `landscape/` - Landscape wallpapers (1920x1080, 2560x1440, 3840x2160)
- `abstract/` - Abstract and artistic wallpapers
- `nature/` - Nature and scenery wallpapers  
- `minimal/` - Minimalist wallpapers
- `dark/` - Dark theme wallpapers
- `default.jpg` - Default fallback

## Formats
JPEG, PNG, WebP

## Configuration
Configured in `configs/ansible/roles/hyprland_desktop/templates/hyprpaper.conf.j2`

## Adding Wallpapers
1. Place files in appropriate subdirectories
2. Update hyprpaper config if needed
3. Set permissions to 644
