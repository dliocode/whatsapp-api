# Use the official Node.js Alpine image as the base image
FROM node:21-alpine

RUN apk --no-cache add curl

# Set the working directory
WORKDIR /usr/src/app

# Install Chromium
ENV CHROME_BIN="/usr/bin/chromium-browser" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
    NODE_ENV="production"
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    udev \
    ttf-freefont \
    chromium \
    ffmpeg

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm ci --only=production --ignore-scripts

# Copy the rest of the source code to the working directory
COPY . .

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost:3000/ping || exit 1

# Expose the port the API will run on
EXPOSE 3000

# Start the API
CMD ["npm", "start"]