#!/bin/sh

BLANK='#00000000'
OVERLAY='#00000033'
TEXT='#C5C8C6FF'
KEYINPUT='#79DE79CC'
WRONG='#FB6962CC'
VERIFYING='#A8E4EFCC'

i3lock \
--insidever-color=$OVERLAY   \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$OVERLAY \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$TEXT        \
--line-color=$BLANK          \
--separator-color=$TEXT   \
\
--verif-color=$VERIFYING     \
--wrong-color=$WRONG         \
--time-color=$TEXT        \
--date-color=$TEXT        \
--layout-color=$TEXT      \
--keyhl-color=$KEYINPUT      \
--bshl-color=$KEYINPUT       \
\
--screen 1                   \
--blur 10                    \
--clock                      \
--indicator                  \
--time-str="%H:%M:%S"        \
--date-str="%Y-%m-%d"
