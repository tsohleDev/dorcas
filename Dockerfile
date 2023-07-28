FROM node:alpine

# Set working directory
WORKDIR /tsohle/toDocker

# Copy all file to working directory
COPY . .

# Install dependencies
RUN yarn install --production

# Run app
CMD ["node", "src/index.js"]

# Expose port
EXPOSE 3000