#!/bin/bash

read -p "Wallet Adını Girin: " wallet_name
read -p "Validator Adresini Girin: " validator_address

apt install jq -y

function check_jailed {
  result=$(rapidd query staking validator $validator_address --output json)
  jailed=$(echo $result | jq -r '.jailed')
  if [[ "$jailed" == "true" ]]; then
    echo "Validator $validator_address JAILED. $jailed"
    unjail_validator
  else
    echo "Validator $validator_address NOT JAILED. $jailed"
  fi
}

function unjail_validator {
  echo "unjail..."
  rapidd tx slashing unjail --broadcast-mode=block --from=$wallet_name --gas=auto --gas-adjustment=1.5 --fees=44659140000000000arapid -y
}

while true; do
  check_jailed
  sleep 5
done
