FROM nginx:1.21.1
    WORKDIR /usr/share/nginx/html
    COPY index.html index.html
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]