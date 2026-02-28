# Stage 1: Build Stage
# Changed from 18 to 20 to satisfy Vite 7 requirements
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci 
COPY . .
RUN npm run build

# Stage 2: Production Stage
FROM nginx:stable-alpine
# Vite outputs to 'dist' by default, so this should be correct
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]