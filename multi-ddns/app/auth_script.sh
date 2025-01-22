#!/usr/bin/env bashio

source /api_lib.sh

# bashio::log.level "debug"

# This script is called during the authentication phase to create the DNS TXT record.

DUCKDNS_TOKEN=${Duck_Token}
DYNU_TOKEN=${Dynu_Token}
domain="$CERTBOT_DOMAIN"
TXT_NAME="_acme-challenge"
TXT_VALUE="$CERTBOT_VALIDATION"

bashio::log.debug "Domain $domain: TXT record challenge: ${TXT_VALUE}"

if [[ $domain != *"*."* ]]; then
    if [[ $domain == *"duckdns.org" ]]; then
        bashio::log.debug "Domain $domain: DuckDNS deploy challenge..."

        # Remove old TXT record from DuckDNS. However this is not necessary, as it will be always override!
        #rm_duck_txt_record "$domain" "$DUCKDNS_TOKEN"

        deploy_duck_txt_record "$domain" "$DUCKDNS_TOKEN" "$TXT_VALUE"
    else
        bashio::log.debug "Domain $domain: DynuDNS deploy challenge..."
        
        # Getting the Dynu DNS domain IDs
        DOMAINID=$(get_dynu_domain_id $domain $DYNU_TOKEN)
        if [ $? -eq 0 ]; then
            # Deleting any left over TXT records for the Dynu domain
            rm_dynu_txt_records "$domain" "$DYNU_TOKEN" "$DOMAINID"

            # Deploy the TXT record challenge for the Dynu domain
            deploy_dynu_txt_record "$domain" "$DYNU_TOKEN" "$TXT_VALUE" "$DOMAINID"
        else
            bashio::log.warning "Domain $domain: Can't deploy TXT DNS records without the domain ID!!!!"
        fi
    fi
else
    bashio::log.debug "Domain $domain: Skipping challenge for * domains..."
    bashio::log.debug "Wait for 60 sec"
    sleep 60
fi

# Add a delay to ensure DNS propagation
bashio::log.debug "Domain $domain: Waiting for DNS propagation..."
sleep 120  # Wait for 120 seconds

# Verify the deployment of the TXT record
verify_challenge "$domain" "$TXT_VALUE"
if [ $? -eq 0 ]; then
    bashio::log.debug "Domain $domain: TXT record verified successfully."
else
    bashio::log.warning "Domain $domain: Initial verification failed. Waiting for additional DNS propagation..."
    sleep 120  # Wait for an additional 120 seconds

    # Verify the deployment of the TXT record again
    verify_challenge "$domain" "$TXT_VALUE"
    if [ $? -eq 0 ]; then
        bashio::log.debug "Domain $domain: TXT record verified successfully after additional wait."
    else
        bashio::log.warning "Domain $domain: Failed to verify TXT record after additional wait."
    fi
fi