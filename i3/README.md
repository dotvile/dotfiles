# i3 Layout

This folder keeps the EndeavourOS look, but the bindings are organized to feel closer to Aerospace.

## Structure

- `config`: tiny entrypoint that only includes `conf.d/*.conf`
- `conf.d/00-variables.conf`: shared variables, workspaces, colors, monitor names
- `conf.d/10-appearance.conf`: visual appearance, gaps, colors, bar, floating rules
- `conf.d/20-workspaces.conf`: app-to-workspace placement rules
- `conf.d/30-autostart.conf`: wallpaper, notifications, auth agent, display setup
- `conf.d/90-bindings.conf`: your actual interaction model and shortcuts
- `i3blocks.conf`: EndeavourOS bar modules
- `scripts/`: helper scripts used by the bar and keybindings
- `keybindings`: short human-readable cheat sheet

## Editing

If you want to change how i3 looks, edit `10-appearance.conf`.

If you want to change how i3 feels, edit `90-bindings.conf`.

If monitor names change, update `00-variables.conf`.

## File manager

The default file manager shortcut is now terminal-based:

- `Super + n` launches `yazi` inside a dedicated WezTerm window

The launcher script is:

- `~/Development/dotfiles/_bin/fm`

The i3 workspace assignment for that window class lives in:

- `20-workspaces.conf`

## Reload

Use:

- `Super + Shift + c` to reload config
- `Super + Shift + r` to restart i3
