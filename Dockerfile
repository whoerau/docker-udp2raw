FROM debian:latest

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y vim wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV UDP2RAW_VERSION 20190716.test.0

WORKDIR /app/udp2raw

RUN wget https://github.com/wangyu-/udp2raw-tunnel/releases/download/$UDP2RAW_VERSION/udp2raw_binaries.tar.gz \  
  && tar -xzvf udp2raw_binaries.tar.gz \
  && chmod +x udp2raw_amd64 \
  && cp udp2raw_amd64 /usr/local/bin \
  && rm -rf /app/udp2raw

ENV LOCAL_ADDR 0.0.0.0:4097
ENV REMOTE_ADDR 127.0.0.1:4096 
ENV PASSWORD ChangeMe!!!
ENV RAW_MODE faketcp
ENV ARGS -s #-c

CMD exec udp2raw_amd64 \
    $ARGS \
    -l $LOCAL_ADDR \
    -r $REMOTE_ADDR \
    -k $PASSWORD \
    -a \
    --raw-mode $RAW_MODE \
    --fix-gro 
