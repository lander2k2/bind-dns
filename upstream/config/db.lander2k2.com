;
; BIND data file for local loopback interface
;
$ORIGIN lander2k2.com.
$TTL	0
@	IN	SOA	ns1.lander2k2.com. admin.lander2k2.com. (
			      6		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
; Name servers
	IN	NS	ns1.lander2k2.com.
k8s	IN	NS	ns2.lander2k2.com.
; A records for name servers
ns1	IN	A	10.0.21.197
ns2	IN	A	10.0.38.99
;
