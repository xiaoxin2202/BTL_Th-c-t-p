# Sử dụng hình ảnh Ubuntu 22.04 làm nền
FROM ubuntu:22.04

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt Node.js từ NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Thiết lập thư mục làm việc
WORKDIR /usr/src/app

# Sao chép package.json và package-lock.json (nếu có)
COPY package*.json ./

# Cài đặt các phụ thuộc
RUN npm install

# Sao chép mã nguồn vào container
COPY . .

# Mở cổng mà ứng dụng sẽ lắng nghe
EXPOSE 3000

# Lệnh để chạy ứng dụng
CMD ["node", "server.js"]

