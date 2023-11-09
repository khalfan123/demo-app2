# Stage 1: Build the Angular app using Node.js
FROM node:latest as builder

WORKDIR /app

# Copy the package.json and package-lock.json to the container
COPY package*.json ./

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Install app dependencies
RUN npm install

# Copy the Angular app source code to the container
COPY . .

# Build the Angular app
RUN ng build

#Stage 2: Create a lightweight Nginx image to serve the Angular app
FROM nginx:latest

# Remove the default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the built Angular app from the builder stage to the Nginx server directory
COPY --from=builder /app/dist/demo-app2/* /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
