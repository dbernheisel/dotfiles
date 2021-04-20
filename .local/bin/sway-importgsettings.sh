#!/bin/sh

# usage: sway-importsettings.sh
config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
if [ ! -f "$config" ]; then exit 1; fi

gnome_schema="org.gnome.desktop.interface"

gtk_theme="$(grep 'gtk-theme-name' "$config" | cut -d'=' -f2)"
gsettings set "$gnome_schema" gtk-theme "$gtk_theme"

icon_theme="$(grep 'gtk-icon-theme-name' "$config" | cut -d'=' -f2)"
gsettings set "$gnome_schema" icon-theme "$icon_theme"

cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | cut -d'=' -f2)"
gsettings set "$gnome_schema" cursor-theme "$cursor_theme"

cursor_size="$(grep 'gtk-cursor-theme-size' "$config" | cut -d'=' -f2)"
gsettings set "$gnome_schema" cursor-size "$cursor_size"

font_name="$(grep 'gtk-font-name' "$config" | cut -d'=' -f2)"
gsettings set "$gnome_schema" font-name "$font_name"
