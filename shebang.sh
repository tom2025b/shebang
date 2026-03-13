#!/usr/bin/env bash
#
# MIT License
#
# Copyright (c) 2026 Thomas Lane
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ============================================================
#  shebang.sh — Cyndi Lauper "She Bop" terminal disco
#  She bop, she bop. Loop until Ctrl+C.
# ============================================================

# ── ANSI helpers ──────────────────────────────────────────
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'
CLEAR_SCREEN='\033[2J'
HIDE_CURSOR='\033[?25l'
SHOW_CURSOR='\033[?25h'

COLORS=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$PURPLE" "$CYAN" "$WHITE")

# ── She Bop lyrics ────────────────────────────────────────
LYRICS=(
  "I was sitting in the Hollywood bleachers"
  "She bop, she bop"
  "Well, I see them every week"
  "She bop, he bop, a-we bop"
  "I hope he's gonna speak"
  "I bop, you bop, a-they bop"
  "He looked at me and I looked at him"
  "Be bop be bop a lula lula"
  "He smiled and I said, 'Me-wow'"
  "She bop, she bop — don't stop!"
  "Well, I got it from the magazine"
  "She bop!"
  "I found the answer in a mag"
  "He bop, she bop, everybody bops"
  "They always say be good"
  "Do I wanna go too far?"
  "She bop— she bop!"
  "Will God strike me blind for this?"
  "I bop, you bop, a-we bop"
  "Is she really going out with him?"
  "She bop, he bop, and we bop!"
  "I'll be walking down the aisle"
  "She bop, bop bop bop bop!"
  "And I like it like that"
)

BOPS=(
  "she bop"
  "you bop"
  "everybody bops"
  "he bop"
  "we bop"
  "bop bop bop!"
  "SHE BOP!"
  "YOU BOP!"
  "EVERYBODY BOPS!"
  "a-we bop"
  "be bop be bop"
)

# ── Utilities ─────────────────────────────────────────────
rand_color() {
  echo -e "${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
}

rand_int() {
  # rand_int MIN MAX
  echo $(( RANDOM % ($2 - $1 + 1) + $1 ))
}

move_cursor() {
  # move_cursor ROW COL
  printf '\033[%d;%dH' "$1" "$2"
}

# ── Terminal dimensions ───────────────────────────────────
get_dims() {
  ROWS=$(tput lines 2>/dev/null || echo 24)
  COLS=$(tput cols  2>/dev/null || echo 80)
}

# ── Cleanup / exit handler ────────────────────────────────
cleanup() {
  printf "${SHOW_CURSOR}"
  printf '\033[2J\033[H'   # clear screen, home
  # Fade-out message centered
  get_dims
  local msg="She bop\xe2\x80\xa6 fades away."
  local col=$(( (COLS - ${#msg}) / 2 ))
  local row=$(( ROWS / 2 ))
  move_cursor "$row" "$col"
  printf "${PURPLE}${msg}${RESET}\n\n"
  tput cnorm 2>/dev/null
  exit 0
}

trap cleanup INT TERM

# ── Main disco loop ───────────────────────────────────────
main() {
  get_dims

  printf "${HIDE_CURSOR}"
  printf "${CLEAR_SCREEN}"

  local frame=0
  local lyric_idx=0

  while true; do
    get_dims

    # ── Draw a full-screen lyric line ──────────────────
    local lyric="${LYRICS[$lyric_idx]}"
    local lrow=$(rand_int 1 "$ROWS")
    local lcol=$(rand_int 1 $(( COLS - ${#lyric} > 1 ? COLS - ${#lyric} : 1 )) )
    local lcolor
    lcolor=$(rand_color)

    move_cursor "$lrow" "$lcol"
    printf "${lcolor}${lyric}${RESET}"

    # ── Scatter random bop phrases ─────────────────────
    local num_bops=$(rand_int 3 7)
    for (( i=0; i<num_bops; i++ )); do
      local bop="${BOPS[$((RANDOM % ${#BOPS[@]}))]}"
      local brow=$(rand_int 1 "$ROWS")
      local bcol=$(rand_int 1 $(( COLS - ${#bop} > 1 ? COLS - ${#bop} : 1 )) )
      local bcolor
      bcolor=$(rand_color)

      move_cursor "$brow" "$bcol"
      printf "${bcolor}${bop}${RESET}"
    done

    # ── Occasionally paint a block of chaos ───────────
    if (( frame % 5 == 0 )); then
      for (( i=0; i<4; i++ )); do
        local br=$(rand_int 1 "$ROWS")
        local bc=$(rand_int 1 "$COLS")
        local bc2
        bcolor=$(rand_color)
        move_cursor "$br" "$bc"
        printf "${bcolor}*${RESET}"
      done
    fi

    # ── Advance lyric ──────────────────────────────────
    lyric_idx=$(( (lyric_idx + 1) % ${#LYRICS[@]} ))
    (( frame++ ))

    sleep 0.08
  done
}

main
