FROM node:12.18-alpine As development

# Create and change to the app directory.
WORKDIR /app

# Copying this separately prevents re-running npm install on every code change.
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy local code to the container image.
COPY . .

RUN yarn build

FROM node:12.18-alpine as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --production

COPY . .

COPY --from=development /app/dist ./dist

# Configure and document the service HTTP port.
ENV PORT 8080
EXPOSE $PORT

# Run the web service on container startup.
CMD ["yarn", "start:prod"]
