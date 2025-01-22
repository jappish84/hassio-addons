# Changelog

## 1.1.1
- Extended verification of propagation from 120s to 600s
- Removed unnecessary removal of TXT record prior to new deployment

## 1.1.0
- Allow wildcard alias options for Dynu DNS.

## 1.0.9

- fix unbound variable.

## 1.0.8

- fix unbound variable.

## 1.0.7

- Only renew certificates, if it will expire in one month and domains in certificate changed.
- Improve the logs related.

## 1.0.6

- Only renew certificates, if it will expire in one month and domains in certificate changed.

## 1.0.5

- Only update the DDNS, if Public IP was pulled from internet
- Better logging when IP changed.

## 1.0.4

- Update some debugging logs.

## 1.0.3

- Fix bug of changing domains in the config

## 1.0.2

- Only issue renew, if certificate is going to expire in less than a month.
- Reset let's encrypt folder, if domains are changed.
- Now you can also include * sub-domains of DuckDNS and Dynu. 

## 1.0.1

- Improve the error handling and code comments

## 1.0.0

- Update the certificate refresh to 12 hrs

## 0.0.9

- improved error handling

## 0.0.8

- improved error handling

## 0.0.7

- Fix for log level

## 0.0.6

- Fix log level bug.

## 0.0.5

- Added log level.

## 0.0.4

- Added the missing deploy_hook.sh script

## 0.0.1

- Initial version
