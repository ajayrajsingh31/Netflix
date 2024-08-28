FROM node:16.17.0-alpine as builder
WORKDIR /opt/dwl_frontend       # Automatically creates the directory
COPY package.json yarn.lock ./  # Copy from the current host directory
RUN yarn install

COPY ./ ./                      # Copy current host directory into current image directory
ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"
RUN yarn build

FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /opt/dwl_frontend/dist .
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
