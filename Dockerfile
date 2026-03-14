# Sử dụng Tomcat 9 và Java 8 (khớp với dự án của bạn)
FROM tomcat:9.0-jdk8-openjdk

# Xóa các ứng dụng mẫu để tránh nặng server
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war vào Tomcat và đổi tên thành ROOT.war để chạy ở trang chủ (/)
COPY dist/ntXuanSystem.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]