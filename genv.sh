#!/bin/zsh

ENV_FILE="$(pwd)/.env"

if [ -f "$ENV_FILE" ]; then
	echo -e "\033[0;36mUsing .env @ $ENV_FILE\033[0m"
elif [ -f "$1" ]; then
	ENV_FILE="$1"
	echo -e "\033[0;36mUsing .env @ $1\033[0m"
else
	echo -e "\033[0;31mFailed to find .env\033[0m"
	exit 1
fi

FILENAME="env.d.ts"

echo "declare namespace NodeJS {" > $FILENAME
echo "\texport interface ProcessEnv {" >> $FILENAME

grep -Eo '^.+?=' .env | awk '{$1=$1};1' | grep -v '#' | sed 's/.$//' | awk '{$1=$1};1' | while read -r line; do
	echo "\t\t$line: string;" >> $FILENAME
done

echo "\t}" >> $FILENAME
echo "}" >> $FILENAME