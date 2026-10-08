#!/usr/bin/env bash
# ==============================================================================
# Script tự động cấu hình Nginx Reverse Proxy cho Spring Boot
# Bài 4 - DevOps Session 07
# ==============================================================================

set -e

echo "=== [1/6] Tạo thư mục chứa trang tĩnh /var/www/html/ ==="
sudo mkdir -p /var/www/html

echo "=== [2/6] Sao chép tệp index.html sang /var/www/html/ ==="
sudo cp -f index.html /var/www/html/index.html
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

echo "=== [3/6] Sao chép tệp cấu hình sang /etc/nginx/sites-available/ ==="
sudo mkdir -p /etc/nginx/sites-available
sudo mkdir -p /etc/nginx/sites-enabled
sudo cp -f spring-proxy.conf /etc/nginx/sites-available/spring-proxy.conf

echo "=== [4/6] Kích hoạt cấu hình (Tạo liên kết mềm symlink) ==="
# Gỡ liên kết cấu hình mặc định (nếu có) để tránh xung đột cổng 80
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "Gỡ bỏ cấu hình mặc định default để tránh xung đột..."
    sudo rm -f /etc/nginx/sites-enabled/default
fi

# Tạo liên kết mềm
sudo ln -sf /etc/nginx/sites-available/spring-proxy.conf /etc/nginx/sites-enabled/spring-proxy.conf

echo "=== [5/6] Kiểm tra cú pháp cấu hình Nginx (nginx -t) ==="
sudo nginx -t

echo "=== [6/6] Reload Nginx để áp dụng cấu hình mới ==="
sudo systemctl reload nginx || sudo service nginx reload

echo ""
echo "============================================================"
echo "           KIỂM TRA HOẠT ĐỘNG HỆ THỐNG"
echo "============================================================"
echo "1. Kiểm tra truy cập trang tĩnh (HTTP 200):"
curl -I http://localhost/

echo ""
echo "2. Kiểm tra nội dung trang tĩnh:"
curl -s http://localhost/ | grep -E "An Hải Dũng|Họ và Tên|Nginx Reverse Proxy Active"

echo ""
echo "3. Kiểm tra Reverse Proxy chuyển tiếp sang Spring Boot (/api/health):"
curl -I http://localhost/api/health || true

echo ""
echo "=== HOÀN TẤT CẤU HÌNH BÀI 4 THÀNH CÔNG! ==="
