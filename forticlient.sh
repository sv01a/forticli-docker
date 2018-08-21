#!/usr/bin/expect -f
set timeout $env(VPN_TIMEOUT)

send [exec echo $env(VPN_CERT) | base64 -d > /opt/forticlient/cert.crt]

set timeout -1
match_max 100000
spawn /opt/forticlient/forticlientsslvpn_cli --server $env(VPN_HOST) --vpnuser $env(VPN_USERNAME) --pkcs12 /opt/forticlient/cert.crt --keepalive
send -- "\r"
expect "Password for VPN:"
send -- "$env(VPN_PASSWORD)\r"
expect "Password for PKCS#12:"
send -- "$env(VPN_CERT_PASSWORD)\r"

expect -exact "STATUS::Connecting..."

# In case of invalid certificate
expect -exact "Would you like to connect to this server? (Y/N)" {
  send -- "Y\n"
}

# Expect tunnel to actually start
expect {
  "STATUS::Tunnel running" {
  } timeout {
    send_user -- "Failed to bring tunnel up after $env(VPNTIMEOUT)s\n"
    exit 1
  }
}

# Expect tunnel to stop but not exit
set timeout -1
expect {
  "STATUS::Tunnel closed" {
    exit 1
  }
  eof {
    exit
  }
}