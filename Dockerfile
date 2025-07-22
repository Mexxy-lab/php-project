# Stage 1: Build Stage
FROM php:8.1-cli AS build

WORKDIR /usr/src/app

# Copy only package files first to leverage Docker cache
COPY composer*.json ./

# Copy the rest of the source code
COPY . .

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install all dependencies (including devDependencies)
RUN composer install --no-dev

# Stage 2: Production Image
FROM php:8.1-cli

WORKDIR /usr/src/app

# Copy only the required files from build stage
COPY --from=build /usr/src/app ./

# Expose app port
EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]