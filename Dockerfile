# Bước 1: Chọn môi trường chạy là Tomcat 9 và Java 8 (Khớp với cấu hình NetBeans của bạn)
FROM tomcat:9.0-jdk8-openjdk

# Bước 2: Dọn dẹp các ứng dụng mặc định để tránh xung đột
RUN rm -rf /usr/local/tomcat/webapps/*

# Bước 3: Copy file .war từ thư mục dist vào thư mục chạy của Tomcat
# Chú ý: Đổi tên thành ROOT.war để web chạy trực tiếp tại đường dẫn gốc (/)
COPY dist/ntXuanSystem.war /usr/local/tomcat/webapps/ROOT.war

# Bước 4: Mở cổng 8080 để Render có thể truy cập
EXPOSE 8080

# Bước 5: Lệnh khởi động server
CMD ["catalina.sh", "run"]