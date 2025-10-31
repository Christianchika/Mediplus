# Use Node.js base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy app source code
COPY . .

# Expose the port your Node app uses
EXPOSE 3000

# Command to run your app
CMD ["npm", "start"]

