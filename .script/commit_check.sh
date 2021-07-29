#!/bin/sh

# Color codes
red='\033[0;31m'
yellow='\033[0;33m'
blue='\033[0;34m'
green='\033[0;32m'
NC='\033[0m' # No colors

printf "\n"

if ! [[ $(cat "$1") =~ ^((chore|docs|feat|fix|refactor|style|test)(\([a-zA-Z0-9]+\))?:|Merge\ pull) ]]; then
  printf "  Please use semantic commit messages\n"
  printf "  ${yellow}<type>${NC}(${green}<scope>${NC}): ${blue}<summary>${NC}\n"
  printf "${yellow}     │${green}      │             ${blue}│\n"
  printf "${yellow}     │${green}      │             ${blue}└─> Present tense. Not capitalized. No period at the end. \n"
  printf "${yellow}     │${green}      │\n"
  printf "${yellow}     │${green}      └─> Scope: common|android|ios|other...\n"
  printf "${yellow}     │\n"
  printf "${yellow}     └─> Type: chore, docs, feat, fix, refactor, style or test.\n${NC}"
  printf "\n  Remember\n"
  printf "${yellow}   -----------------------------------------------------\n${NC}"
  printf "${yellow}  |  type FIX  triggers a PATCH increase  (i.e. x.x.X)  |\n${NC}"
  printf "${yellow}  |  type FEAT triggers a MINOR increase  (i.e. x.X.x)  |\n${NC}"
  printf "${yellow}  |  type PERF triggers a MAJOR increase  (i.e. X.x.x)  |\n${NC}"
  printf "${yellow}   -----------------------------------------------------${NC}"
  printf "\n\n"
  exit 1
fi

while read -r line; do
  # Skip comments
  if [ "${line:0:1}" == "#" ]; then
      continue
  fi
  if [ ${#line -gt 72} ]; then
    echo -e "${yellow}Commit messages are limited to 72 characters.${NC}"
    echo -e "The following commit message has ${red}${#line}${NC} characters."
    echo "${line}"
    exit 1
  fi
  done < "${1}"
exit 0
