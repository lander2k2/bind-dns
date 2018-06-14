#!/bin/bash

set -e

: "${MASTER_IP:?Env variable MASTER_IP must be set and not empty}"
: "${SLAVE_IP:?Env variable SLAVE_IP must be set and not empty}"
: "${BASE_DOMAIN:?Env variable BASE_DOMAIN must be set and not empty}"
: "${ZONE_SUBDOMAIN:?Env variable ZONE_SUBDOMAIN must be set and not empty}"
: "${API_SUBDOMAIN:?Env variable API_SUBDOMAIN must be set and not empty}"
: "${API_ELB:?Env variable API_ELB must be set and not empty}"

SERIAL=$(date +"%Y%m%d%H%M%S")

cat > ./db.${ZONE_SUBDOMAIN}.${BASE_DOMAIN} <<EOF
\$ORIGIN ${ZONE_SUBDOMAIN}.${BASE_DOMAIN}.
\$TTL	604800
@	IN	SOA	kns1.${BASE_DOMAIN}. kadmin.${BASE_DOMAIN}. (
     ${SERIAL}		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
; Name servers
	IN	NS	kns1.${BASE_DOMAIN}.
	IN	NS	kns2.${BASE_DOMAIN}.
; A records for name servers
kns1	IN	A	${MASTER_IP}
kns2	IN	A	${SLAVE_IP}
;
${API_SUBDOMAIN}	IN	CNAME	${API_ELB}.
EOF

exit 0

