# Docker Development Setup

## Quick Start

1. **Copy environment variables:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your Strava API credentials.

2. **Build the Docker image:**
   ```bash
   docker compose build jekyll
   ```

3. **Start development environment:**
   ```bash
   docker compose up jekyll
   ```

4. **Access the site:**
   - Main site: http://localhost:4000
   - LiveReload will automatically refresh on file changes

## Available Services

### Main Jekyll Service
```bash
# Build image first (only needed once or after Gemfile changes)
docker compose build jekyll

# Start main development server
docker compose up jekyll

# Start in background
docker compose up -d jekyll

# View logs
docker compose logs -f jekyll
```

### Development Tools Container
```bash
# Build tools image (shares same Dockerfile as jekyll service)
docker compose build tools

# Start tools container for running tasks
docker compose --profile tools up -d tools

# Run Strava data fetch
docker compose exec tools bundle exec rake strava:clubrides

# Run production build
docker compose exec tools bundle exec jekyll build --config _config.yml,_config_prod.yml

# Run any other rake tasks
docker compose exec tools bundle exec rake strava:members
```

### Optional Nginx Proxy
```bash
# Start with nginx proxy for production testing
docker compose --profile nginx up jekyll nginx

# Access via nginx: http://localhost:8080
```

## Common Development Tasks

### Install new gems
```bash
# Add gem to Gemfile, then rebuild image
docker compose build jekyll
docker compose up jekyll
```

### Run shell in container
```bash
docker compose exec jekyll sh
```

### Clean rebuild
```bash
docker compose down -v
docker compose build --no-cache jekyll
docker compose up jekyll
```

## Environment Variables

Set these in your `.env` file:
- `STRAVA_CLIENT_ID`: Your Strava app client ID
- `STRAVA_CLIENT_SECRET`: Your Strava app client secret  
- `STRAVA_API_REFRESH_TOKEN`: Your Strava refresh token
- `STRAVA_API_CLUB_ID`: Your cycling club ID

## File Watching & LiveReload

The container uses:
- `--force_polling`: For file change detection in Docker
- `--livereload`: Automatic browser refresh on changes
- `--incremental`: Faster rebuilds
- `--drafts`: Include draft posts

## Troubleshooting

### Port conflicts
If port 4000 is in use, change the port mapping in docker-compose.yml:
```yaml
ports:
  - "4001:4000"  # Use different host port
```

### Bundle install issues
```bash
# Clear bundle cache and rebuild
docker compose down -v
docker compose build --no-cache jekyll
docker compose up jekyll
```

### Strava API errors
- Check your `.env` file has correct credentials
- Ensure Strava app is configured properly
- Check container logs for API errors