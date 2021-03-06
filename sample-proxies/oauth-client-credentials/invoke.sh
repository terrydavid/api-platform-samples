#!/bin/bash

echo Using org and environment configured in /setup/setenv.sh

echo Be sure to run scripts under ./setup/provisioning

source ../../setup/setenv.sh

#curl "http://$org-$env.$api_domain/altitude?country=us&postalcode=08008"

echo Get app profile

echo "Enter your password for the Apigee Enterprise organization $org, followed by [ENTER]:"

read -s password

echo "Fetching consumer key and secret for joe-app"
ks=`curl -u "$username:$password" "$url/v1/o/$org/developers/joe@weathersample.com/apps/joe-app" 2>/dev/null | egrep "consumer(Key|Secret)"`
key=`echo $ks | awk -F '\"' '{ print $4 }'`
secret=`echo $ks | awk -F '\"' '{ print $8 }'`

echo "Requesting access token"

token=`curl -k -u "$key:$secret" "https://$org-$env.$api_domain/weatheroauth/accesstoken?grant_type=client_credentials" 2>/dev/null | grep access_token | awk -F '\"' '{ print $4 } '`

echo "Invoking API with access token $token"

curl -k -H "Authorization: Bearer $token" "https://$org-$env.$api_domain/weatheroauth/forecastrss?w=12797282"

echo "Access token is $token"