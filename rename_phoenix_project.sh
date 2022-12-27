#!/bin/bash
export LC_CTYPE=C
export LANG=C

# How to run:
# 1. Ensure you've checked your files into a git repo (`git init .`, `git add -A`, `git commit -m 'first'`)
# 2. Modify these two values to your new app name
NEW_NAME="Ectoprint"
NEW_OTP="ectoprint"
# 3. Execute the script in terminal: `sh rename_phoenix_project.sh`

set -e

if ! command -v ack &>/dev/null; then
	echo "\`ack\` could not be found. Please install it before continuing (Mac: brew install ack)."
	exit 1
fi

CURRENT_NAME="Ectoprint"
CURRENT_OTP="Ectoprint"

ack -l "$CURRENT_NAME" --ignore-file=is:rename_phoenix_project.sh | tee -a
ack -l "$CURRENT_OTP" --ignore-file=is:rename_phoenix_project.sh | tee -a

git mv lib/"$CURRENT_OTP" lib/"$NEW_OTP"
git mv lib/"$CURRENT_OTP".ex lib/"$NEW_OTP".ex
git mv lib/"${CURRENT_OTP}"_web lib/"${NEW_OTP}"_web
git mv lib/"${CURRENT_OTP}"_web.ex lib/"${NEW_OTP}"_web.ex

# Uncomment this if you have written tests in the folder test/Ectoprint
# git mv test/$CURRENT_OTP test/$NEW_OTP

git mv test/"${CURRENT_OTP}"_web test/"${NEW_OTP}"_web
