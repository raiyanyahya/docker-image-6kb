FROM ubuntu:18.04 as builder
RUN apt update
RUN apt install -y make yasm as31 nasm binutils 
COPY . .
RUN make release
# https://github.com/upx/upx
COPY ./upx-3.96-amd64_linux/upx upx
RUN ./upx --brute asmttpd

### run stage ###
FROM scratch
COPY --from=builder /asmttpd /asmttpd
COPY /web_root/index.html /web_root/index.html
CMD ["/asmttpd", "/web_root", "8080"]
