#!/usr/bin/expect -f
set force_conservative 0  ;
if {$force_conservative} {
    set send_slow {1 .1}
    proc send {ignore arg} {
            sleep .1
            exp_send -s -- $arg
    }
}

send [exec echo $env(VPN_CERT) | base64 -d > ./cert.crt]

set timeout -1
match_max 100000
spawn ./forticlientsslvpn_cli --server $env(VPN_HOST) --vpnuser $env(VPN_USERNAME) --pkcs12 ./cert.crt
send -- "\r"
expect "Password for VPN:"
send -- "$env(VPN_PASSWORD)\r"
expect "Password for PKCS#12:"
send -- "$env(VPN_CERT_PASSWORD)\r"
expect -exact "\r
STATUS::Setting up the tunnel\r
STATUS::Connecting...\r"
send -- "Y\r"
expect eof
