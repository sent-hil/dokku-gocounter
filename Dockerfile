FROM amd64/alpine:3.7

# Without this goatcounter won't start.
RUN apk --update --no-cache add tzdata
ENV TZ America/Los_Angeles

# Get 1.3.1
RUN wget https://github.com/zgoat/goatcounter/releases/download/v1.3.1/goatcounter-v1.3.1-linux-amd64.gz
RUN gunzip goatcounter-v1.3.1-linux-amd64.gz
RUN mv goatcounter-v1.3.1-linux-amd64 goatcounter
RUN chmod a+x goatcounter

# Run at port 5000 (dokku's default)
# Run without tls, dokku letencrypt plugin will take care of it.
ENTRYPOINT ./goatcounter serve -listen 0.0.0.0:5000 -automigrate -tls none -db "$GOATCOUNTER_DB"
