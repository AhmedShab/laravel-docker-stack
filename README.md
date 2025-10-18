# Laravel Docker Stack

A complete Docker setup for running a Laravel application with PHP, MySQL, and Nginx. This project is based on the "Docker & Kubernetes: The Practical Guide" Udemy course.

## Project Structure

```
laravel-docker-stack/
├── dockerfiles/
│   ├── php.dockerfile          # PHP-FPM container for Laravel
│   ├── composer.dockerfile     # Composer container for dependency management
│   └── nginx.dockerfile        # Nginx web server container
├── nginx/
│   ├── nginx.conf              # Nginx configuration
│   └── nginx.config
├── env/
│   └── mysql.env               # MySQL environment variables
├── src/                        # Laravel application (generated)
├── docker-compose.yml          # Docker Compose configuration
└── .gitignore                  # Git ignore rules
```

## Prerequisites

- Docker Desktop (or Docker Engine + Docker Compose)
- Git
- Basic knowledge of Docker and Laravel

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/AhmedShab/laravel-docker-stack.git
cd laravel-docker-stack
```

### 2. Create Environment Files

Create the `env/mysql.env` file with your MySQL credentials:

```bash
mkdir -p env
cat > env/mysql.env << EOF
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=laravel
MYSQL_USER=laravel
MYSQL_PASSWORD=laravel
EOF
```

### 3. Build Docker Images

```bash
docker-compose build
```

### 4. Create Laravel Project

Generate a new Laravel project in the `src/` directory:

```bash
docker-compose run --rm composer create-project --prefer-dist laravel/laravel .
```

### 5. Start the Services

```bash
docker-compose up -d server --build
docker-compose run --rm artisan migrate
docker-compose run --rm artisan key:generate
```

### 6. Access the Application

- **Laravel App**: http://localhost:8000
- **PHP FPM**: http://localhost:3000

## Services

### Nginx (server)
- **Image**: `nginx:stable-alpine`
- **Port**: 8000 (mapped to 80 inside container)
- **Purpose**: Web server that routes requests to PHP-FPM
- **Config**: `./nginx/nginx.conf` mounted to `/etc/nginx/conf.d/default.conf`

### PHP-FPM (php)
- **Dockerfile**: `dockerfiles/php.dockerfile`
- **Port**: 3000
- **Purpose**: Runs PHP application code
- **User**: `laravel` (non-root user for security)
- **Extensions**: PDO, PDO MySQL

### MySQL (mysql)
- **Image**: `mysql:5.7`
- **Purpose**: Database server
- **Credentials**: Loaded from `env/mysql.env`
- **Note**: Not exposed to host (internal communication only)

### Composer (composer)
- **Dockerfile**: `dockerfiles/composer.dockerfile`
- **Purpose**: Manages PHP dependencies
- **Usage**: `docker-compose run --rm composer <command>`

### Artisan (artisan)
- **Dockerfile**: `dockerfiles/php.dockerfile`
- **Purpose**: Run Laravel Artisan commands
- **Usage**: `docker-compose run --rm artisan <command>`

### Node/NPM (npm)
- **Image**: `node:14`
- **Purpose**: Manage JavaScript dependencies and build assets
- **Usage**: `docker-compose run --rm npm <command>`

## Common Commands

### Composer Commands

```bash
# Install dependencies
docker-compose run --rm composer install

# Update dependencies
docker-compose run --rm composer update

# Require a new package
docker-compose run --rm composer require vendor/package
```

### Artisan Commands

```bash
# Run migrations
docker-compose run --rm artisan migrate

# Create a new model
docker-compose run --rm artisan make:model ModelName

# Run tinker (interactive shell)
docker-compose run --rm artisan tinker

# Clear cache
docker-compose run --rm artisan cache:clear
```

### NPM Commands

```bash
# Install dependencies
docker-compose run --rm npm install

# Build assets
docker-compose run --rm npm run build

# Watch for changes
docker-compose run --rm npm run dev
```

### Docker Compose Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f php

# Execute command in running container
docker-compose exec php bash
```

## Key Concepts Learned

### Volume Mounts
- `./src:/var/www/html` - Application code
- `./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro` - Read-only Nginx config
- `:delegated` flag - Performance optimization for Docker Desktop

### Service Dependencies
- Services depend on each other (e.g., `artisan` depends on `mysql`)
- Ensures proper startup order

### Environment Variables
- MySQL credentials stored in `env/mysql.env`

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker-compose logs <service-name>

# Rebuild images
docker-compose build --no-cache
```

### Port Already in Use

If ports 8000 or 3000 are already in use, edit `docker-compose.yml`:

```yaml
ports:
  - "8001:80"  # Change 8000 to 8001
```

### Database Connection Issues

Ensure `env/mysql.env` exists and has correct credentials. The MySQL service name is `mysql` (not localhost).

## File Explanations

### dockerfiles/php.dockerfile
- Installs PHP 8.2 with FPM
- Installs PDO and MySQL extensions
- Creates non-root `laravel` user
- Sets working directory to `/var/www/html`

### dockerfiles/composer.dockerfile
- Uses official Composer image
- Creates non-root `laravel` user
- Ignores platform requirements for compatibility

### dockerfiles/nginx.dockerfile
- Configures Nginx web server
- Routes requests to PHP-FPM

### docker-compose.yml
- Defines all services and their configurations
- Sets up volumes for code and configuration
- Manages environment variables and dependencies

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Laravel Documentation](https://laravel.com/docs)
- [Udemy Course](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/)

## License

This project is open source and available under the MIT License.

