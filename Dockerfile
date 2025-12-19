# ---------- Build Stage ----------
FROM node:16.17.0-alpine AS builder

WORKDIR /app

# Copy only package.json
COPY package.json ./

# Install dependencies
RUN yarn install

# Copy application source
COPY . .

# Build-time environment variables
ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

# Build the app
RUN yarn build


# ---------- Production Stage ----------
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

# Remove default nginx files
RUN rm -rf ./*

# Copy build output
COPY --from=builder /app/dist .

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]

