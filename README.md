# docker-udp2raw

## .env
```
LOCAL_ADDR=0.0.0.0:4097
REMOTE_ADDR=127.0.0.1:4096 
PASSWORD=ChangeMe!!!
RAW_MODE=faketcp
ARGS=-s #-c
```
## description
### container config
- net=host
- cap-add=NET_ADMIN
- cap-add=NET_RAW
- eg:
  >docker run --net=host --cap-add=NET_ADMIN --cap-add=NET_RAW···
