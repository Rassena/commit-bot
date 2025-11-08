#!/usr/bin/env bash
#
# Commit Bot by Steven Kneiser
#
# > https://github.com/theshteves/commit-bot
#
# Deploy locally by adding the following line to your crontab:
# 0 22 * * * /bin/bash /<full-path-to-your-folder>/code/commit-bot/bot.sh
#
# Edit your crontab in vim w/ the simple command:
# crontab -e
#
# Deploying just on your computer is better than a server if you want
# your commits to more realistically mirror your computer usage.
#
# ...c'mon, nobody commits EVERY day ;)
#
info="Commit: $(date)"
echo "OS detected: $OSTYPE"

case "$OSTYPE" in
    darwin*)
        cd "`dirname $0`" || exit 1
        ;;

    linux*)
        cd "$(dirname "$(readlink -f "$0")")" || exit 1
        ;;

    *)
        echo "OS unsupported (submit an issue on GitHub!)"
        ;;
esac

# Array of zodiac signs
signs=(aries taurus gemini cancer leo virgo libra scorpio sagittarius capricorn aquarius pisces)


# Pick a random number from 1 to 12
rand_repeat=$((RANDOM % 13))
echo $rand_repeat
# Create dir
mkdir -p Horoscope


if ($rand_val>0); then
	for i in $(seq 1 $rand_repeat); 
	do
	    random_sign=${signs[$RANDOM % ${#signs[@]}]}

	    # File path for the sign
	    file_path="Horoscope/${random_sign}.txt"

	    # Fetch horoscope and append with timestamp
	    echo "[$(date)] Fetching horoscope for $random_sign..."
	    curl -s "https://ohmanda.com/api/horoscope/$random_sign/" | jq '.' >> "$file_path"
	    echo >> "$file_path"  # Add empty line between entries

		# Detect current branch (main, master, etc)
		branch=$(git rev-parse --abbrev-ref HEAD)

		# Ship it
		git add $file_path
		git commit -m "$info"
		git push origin "$branch"
	done
fi
cd -
