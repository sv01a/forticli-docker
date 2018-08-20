FROM ubuntu:16.04

RUN apt-get update && \
  apt-get install -y expect wget ssh && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt/forticlient

COPY start.sh ./

RUN wget 'https://hadler.me/files/forticlient-sslvpn_4.4.2333-1_amd64.deb' -O forticlient-sslvpn_amd64.deb && \
    dpkg -x forticlient-sslvpn_amd64.deb ./forticlient && \
    cp -rf ./forticlient/opt/forticlient-sslvpn/64bit/* /opt/forticlient && \
    rm -rf *.deb ./forticlient &&\
    chmod +x ./start.sh

CMD [ "./start.sh" ]
