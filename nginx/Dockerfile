# Sử dụng image Ubuntu 22.04 làm base
FROM nginx:latest

# Cài đặt Nginx và các gói cần thiết


# Sao chép file cấu hình Nginx (nếu cần)
# COPY ./my-nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html
#COPY Default /etc/nginx/sites-available

# Mở cổng 80
EXPOSE 80
EXPOSE 85
EXPOSE 8080
EXPOSE 8090
EXPOSE 3000


# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]



