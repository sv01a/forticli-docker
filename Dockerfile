FROM ubuntu:16.04

ENV VPN_TIMEOUT=30

RUN apt-get update && \
  apt-get install -y expect wget net-tools iproute ipppd iptables ssh && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt/forticlient

COPY forticlient.sh /usr/bin/forticlient
COPY start.sh ./

RUN wget 'https://hadler.me/files/forticlient-sslvpn_4.4.2333-1_amd64.deb' -O forticlient-sslvpn_amd64.deb && \
    dpkg -x forticlient-sslvpn_amd64.deb ./fc && \
    cp -rf ./fc/opt/forticlient-sslvpn/64bit/* /opt/forticlient && \
    rm -rf *.deb ./fc &&\
    chmod +x /usr/bin/forticlient && \
    chmod +x ./start.sh

CMD [ "./start.sh" ]