# Sử dụng image Ubuntu 22.04 làm base
FROM ubuntu:22.04

# Cập nhật package list và cài đặt các package cần thiết
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release

# Thêm NodeSource PPA để cài đặt Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# Kiểm tra phiên bản Node.js và npm
RUN node -v && npm -v

# Thiết lập thư mục làm việc
WORKDIR /usr/src/app

# Sao chép package.json và package-lock.json (nếu có)
COPY package*.json ./

# Cài đặt các dependencies
#RUN apt-get install -y npm

# Sao chép mã nguồn ứng dụng vào container
COPY . .

# Expose cổng ứng dụng (thay đổi cổng nếu cần)
EXPOSE 80
EXPOSE 85
EXPOSE 8080
EXPOSE 8090
EXPOSE 3000

# Khởi động ứng dụng
CMD ["node", "app.js"]  # Thay đổi 'app.js' thành file khởi động của bạn