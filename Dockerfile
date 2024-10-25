# Use the official Node.js image.
# https://hub.docker.com/_/node
FROM node:18

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Install dependencies. using npm ci for faster installs with lockfile
RUN npm ci

# Copy local code to the container image.
COPY . .

# Build the app for production
RUN npm run build

# Install 'serve' to serve the production build
RUN npm install -g serve

# Tell the port number the container should expose.
EXPOSE 80

# Run the web service on container startup.
CMD ["npm", "start"]


