FROM golang:alpine AS builder
WORKDIR /DNSlog-GO
COPY . /DNSlog-GO
ENV ARG argName
ENV GOPROXY https://goproxy.cn,direct
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -trimpath -ldflags="-w -s" main.go

FROM alpine AS runner
WORKDIR /DNSlog-GO
COPY --from=builder /DNSlog-GO/main .
COPY --from=builder /DNSlog-GO/config.yaml .
RUN  cat /root/.docker/config.json
    
EXPOSE 53/udp 8000
ENTRYPOINT ["./main"]
