#!/bin/bash

verification=$(gpg --verify "hashes.test" 2>&1)

grep "Good signature" <<< $verification || echo dieeee

signature_date_line=$(echo "$verification" | grep "Signature made")

signed_date=$(echo "$signature_date_line" | awk '{print $4, $5, $6, $7, $8}')
real_date=$(date -d "$signed_date" +"%Y%m%d")
other_date=$(date +"%Y%m%d")

if [ $real_date -le $other_date ];
then
    echo "bad"
fi
