#!/bin/sh

status_code=404
status_text='Not Found'
content_type=text/plain
content_length=9
body='Not Found'

for q in $(echo "$QUERY_STRING" | sed 's/&/ /g'); do
  case $q in 'key='*)
    key="$(httpd -d "$(echo "$q" | cut -d '=' -f 2)")"
    file="$(find /www/secrets -type f -path "$(realpath "/www/secrets/$key")")"
    if [ -n "$file" ]; then
      status_code=200
      status_text=OK
      content_type=application/json
      content_length="$(wc -c "$file" 2> /dev/null | cut -d ' ' -f 1)"
      body="$(cat "$file")"
    fi
    break
  esac
done

cat << EOF
HTTP/1.1 ${status_code} ${status_text}
Content-Type: ${content_type}
Content-Length: ${content_length}

${body}
EOF