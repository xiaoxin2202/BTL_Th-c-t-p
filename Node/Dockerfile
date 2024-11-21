# Sử dụng Ubuntu 22.04 làm base image
FROM ubuntu:22.04

# Cài đặt Node.js và npm
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép package.json và package-lock.json trước
COPY package*.json ./

# Cài đặt các phụ thuộc
RUN npm install --production

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Expose port mà ứng dụng sẽ chạy
EXPOSE 3000

# Chạy ứng dụng
CMD ["node", "app"]
