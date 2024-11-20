# Sử dụng image Ubuntu 22.04 làm base
FROM ubuntu:22.04

# Cài đặt Nginx và các gói cần thiết
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get install curl -y

# Sao chép file cấu hình Nginx (nếu cần)
# COPY ./my-nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html

# Mở cổng 80
EXPOSE 80
EXPOSE 85
EXPOSE 8080
EXPOSE 8090
EXPOSE 3000


# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]



