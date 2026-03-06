# Stage 1: Build Stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production || { echo 'npm ci failed'; exit 1; }
COPY . .
RUN npm run build || { echo 'npm run build failed'; exit 1; }

# Stage 2: Production Stage
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
    CMD curl --fail http://localhost/ || { echo 'Nginx health check failed'; exit 1; }
CMD ["nginx", "-g", "daemon off;"]
