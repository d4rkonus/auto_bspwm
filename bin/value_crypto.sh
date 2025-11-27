#!/bin/sh

API="https://api.kraken.com/0/public/Ticker"

quote=$(curl -sf $API?pair=BTCEUR | jq -r ".result.XXBTZEUR.c[0]")
quote=$(LANG=C printf "%.2f" "$quote")

formatted=$(echo "$quote" | awk '{printf "%'\''0.2f", $1}' | sed 's/\\./,/;:a;s/\\B[0-9]\\{3\\}\\>/.&/;ta')
echo -e " $formatted€"