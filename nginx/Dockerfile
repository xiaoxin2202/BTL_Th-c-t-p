# Sử dụng image Ubuntu 22.04 làm base
FROM ubuntu:22.04

# Cài đặt Nginx và các gói cần thiết
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean

# Sao chép file cấu hình Nginx (nếu cần)
#COPY ./my-nginx.conf /etc/nginx/nginx.conf
#COPY index.html /var/www/html

COPY index.html /var/www/html

COPY deploy /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-avaiable/deploy /etc/nginx/sites-enabled/
RUN nginx -s reload
RUN nginx -t

# Mở cổng 80
EXPOSE 80
EXPOSE 85
EXPOSE 8080
EXPOSE 8090
EXPOSE 3000

# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]
#FROM public.ecr.aws/nginx/nginx:mainline

#ADD index.html /etc/nginx/html/index.html
#ADD nginx.conf /etc/nginx/nginx.conf

