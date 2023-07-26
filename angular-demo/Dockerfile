# stage 1 angular
FROM node:20-alpine AS build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# stage 2 Serve Application using Nginx Server

FROM nginx:alpine
COPY --from=build /app/dist/angular-demo/ /usr/share/nginx/html

EXPOSE 80