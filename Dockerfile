FROM ubuntu:latest
RUN apt update --fix-missing
RUN apt -y upgrade
RUN apt install -y build-essential git libpcre3-dev libssl-dev zlib1g-dev ffmpeg libxml2-dev wget
RUN wget http://nginx.org/download/nginx-1.23.2.tar.gz
RUN tar -zxvf nginx-1.23.2.tar.gz
RUN wget https://github.com/kaltura/nginx-vod-module/archive/refs/tags/1.30.tar.gz
RUN tar -zxvf 1.30.tar.gz
WORKDIR /nginx-1.23.2
RUN ./configure \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/run/nginx.pid \
    --sbin-path=/usr/sbin/nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-file-aio \
    --with-threads \
    --with-stream \
    --with-cc-opt="-O3 -mpopcnt" \
    --add-module=../nginx-vod-module-1.30
RUN make && make install
WORKDIR  /etc/nginx
RUN mv nginx.conf nginx.conf.old 
RUN wget https://raw.githubusercontent.com/glen-s-abraham/nginx-vod-conf/master/conf/nginx.conf
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]


