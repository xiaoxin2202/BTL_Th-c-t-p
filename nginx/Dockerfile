# Sử dụng image Ubuntu 22.04 làm base
FROM ubuntu:22.04

# Cài đặt Nginx và các gói cần thiết
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Sao chép file cấu hình Nginx (nếu cần)
#COPY ./my-nginx.conf /etc/nginx/nginx.conf
#COPY index.html /var/www/html
RUN cat /etc/nginx/nginx.conf

#COPY nginx.conf /etc/nginx
COPY index.html /var/www/html
COPY default /etc/nginx/sites-available

RUN cat /etc/nginx/sites-available/default
#RUN cat /etc/nginx/nginx.conf
# Mở cổng 80
EXPOSE 80
EXPOSE 85
EXPOSE 5000

# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]
#FROM public.ecr.aws/nginx/nginx:mainline

#ADD index.html /etc/nginx/html/index.html
#ADD nginx.conf /etc/nginx/nginx.conf

