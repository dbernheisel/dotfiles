#!/usr/bin/env bash
exec 2> "$XDG_RUNTIME_DIR/waybar-playerctl.log"
IFS=$'\n\t'

while true; do
  player_status=$(playerctl status 2> /dev/null)
  while read -r playing line; do
    # json escaping
    line="${line//\"/\\\"}"
    case $playing in
      Paused)
        class="paused"
        text='<span size=\"smaller\">'"$line"'</span>'
        ;;
      Playing)
        class="playing"
        text='<small>'"$line"'</small>'
        ;;
      *)
        class="stopped"
        text='<span>⏹</span>'
        ;;
    esac
    printf '{"class":"%s","text":"%s","tooltip":"%s"}\n' \
      "$class" "$text" "$playing" || break 2

  done < <(
    playerctl --follow metadata --player %any --format \
      $'{{status}}\t{{markup_escape(artist)}} - {{markup_escape(title)}}' &
    echo $! > "$XDG_RUNTIME_DIR/waybar-playerctl.pid"
  )

  # no current players
  # exit if print fails
  echo '{"class":"stopped","text":"⏹"}' || break
  sleep 15
done

kill "$(< "$XDG_RUNTIME_DIR/waybar-playerctl.pid")"
