FROM debian:latest as builder

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

#ARG UDP2RAW_VERSION=20200715.0
#RUN UDP2RAW_VERSION=`wget -qO- -t1 -T2 --no-check-certificate "https://api.github.com/repos/wangyu-/udp2raw-tunnel/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g' `

WORKDIR /app
RUN wget https://github.com/wangyu-/udp2raw-tunnel/releases/latest/download/udp2raw_binaries.tar.gz \
  && tar -xzvf udp2raw_binaries.tar.gz


FROM debian:stable-slim
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y iptables \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/udp2raw_amd64 /usr/local/bin
RUN chmod +x /usr/local/bin/udp2raw_amd64

ENV LOCAL_ADDR 0.0.0.0:4097
ENV REMOTE_ADDR 127.0.0.1:4096
ENV PASSWORD ChangeMe!!!
ENV RAW_MODE faketcp
ENV ARGS -a -s #-c

CMD exec udp2raw_amd64 \
    $ARGS \
    -l $LOCAL_ADDR \
    -r $REMOTE_ADDR \
    -k $PASSWORD \
    --raw-mode $RAW_MODE \
    --fix-gro
