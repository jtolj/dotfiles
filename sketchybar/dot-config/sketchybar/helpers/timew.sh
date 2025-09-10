#!/bin/sh
# https://github.com/nicolas-martin/awesome-sketchybar/blob/master/plugins/Taskwarrior-Timewarrior.md
IS_ACTIVE=$(timew get dom.active)

if [[ $IS_ACTIVE == 0 ]]; then
  sketchybar --set $NAME label.drawing=off    \
                         icon.padding_left=8 \
                         icon.padding_right=10 \
                         icon.color=0xff7f8490
else
  HAS_TAGS=$(timew get dom.active.tags.count)

  if [[ $HAS_TAGS == 0 ]]; then
    LABEL="•"
  else
    TAGS=$(timew get dom.active.json | jq -r '.tags[]')
    TAGS_ARR=()
    while read -r line; do TAGS_ARR+=("$line"); done <<< "$TAGS"
    DELIM=""
    LABEL=""
    for TAG in "${TAGS_ARR[@]}";
    do
      LABEL="$LABEL$DELIM$TAG"
      DELIM=", "
    done
    LABEL=$(echo "$LABEL" | cut -c 1-25)
  fi

  sketchybar --set $NAME label="${LABEL}"     \
                         label.drawing=on     \
                         icon.padding_left=6  \
                         icon.padding_right=2 \
                         icon.color=0xffe7c664
fi
