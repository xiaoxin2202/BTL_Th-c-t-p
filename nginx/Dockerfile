# Sử dụng image Ubuntu 22.04 làm base
FROM ubuntu:latest

# Cài đặt Nginx và các gói cần thiết
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean

# Sao chép file cấu hình Nginx (nếu cần)
# COPY ./my-nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html
COPY Default /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-avaiable/Default /etc/nginx/sites-enabled/

RUN cat /etc/nginx/sites-available/Default
RUN ls /etc/nginx/
# Mở cổng 80
EXPOSE 80
EXPOSE 85
EXPOSE 8080
EXPOSE 8090
EXPOSE 3000


# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]



