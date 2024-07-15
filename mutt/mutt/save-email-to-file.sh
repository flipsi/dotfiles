#!/usr/bin/env bash
# Save piped email to "$1/YYYY-MM--DD SUBJECT.eml"

set -e

# Don't overwrite existing file
set -o noclobber

message=$(cat)

mail_date=$(<<<"$message" grep -oPm 1 '^Date: ?\K.*')
formatted_date=$(date -d"$mail_date" +%Y-%m-%d)
# Get the first line of the subject, and change / to ∕ so it's not a subdirectory
subject=$(<<<"$message" grep -oPm 1 '^Subject: ?\K.*' | sed 's,/,∕,g')

# decode base64 (UTF-8) headers
if [[ "$subject" =~ ^=\?[Uu][Tt][Ff]-8\?B\?.*?= ]]; then
  nofront="${subject#=\????-8\?B\?}"
  todecode="${nofront%\?=}"
  subject="$(<<<"$todecode" base64 --decode)"
fi

if [[ $formatted_date == '' ]]; then
  echo Error: no date parsed
  exit 1
elif [[ $subject == '' ]]; then
  echo Warning: no subject found
fi

base64_block_header='Content-Transfer-Encoding: base64'
base64_block_footer='^--.*' # TODO: does this work? what about multiple base64 blocks?
base64_block_if_any=$(sed -n -E -e "/$base64_block_header/,/$base64_block_footer/p" <(echo "$message"))
base64_message_if_any=$(sed -E -e "/^$base64_block_header$/d" -e "/^--/d" <(echo "$base64_block_if_any"))
base64_message_encoded="$(<<<"$base64_message_if_any" base64 --decode)"

filename="$1/$formatted_date $subject.eml"
# filename="$1/$formatted_date $subject $(date +%s).eml" # for debugging
echo "$message" > "$filename"
echo "$base64_message_encoded" >> "$filename"
echo Email saved to file "$filename"
