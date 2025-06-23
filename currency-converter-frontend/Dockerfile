# Use a base image with Node.js version 22 (alpine variant)
FROM node:22.3-alpine

# Use root user
USER root

# Create the application directory
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Clean npm cache and install global dependencies
RUN npm cache clean --force && npm install -g @quasar/cli

# Install application dependencies
RUN npm install

# Copy the rest of your application files
COPY . .

# Expose the port your app runs on
EXPOSE 9000

# Default command to run the application
CMD ["quasar", "dev"]
