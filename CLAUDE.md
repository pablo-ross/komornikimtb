# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Jekyll-based website for Komorniki MTB Team, a local cycling organization in Poland. The site features:
- Blog posts about cycling events and activities
- Strava API integration to display recent club rides
- Netlify CMS for content management
- Partner/sponsor pages
- Member profiles with Strava integration

## Development Commands

### Local Development (Native)
```bash
# Install dependencies
bundle install

# Start local development server with live reload
bundle exec jekyll serve --watch --livereload
# Alternative using script
./_scripts/localhost.sh
```

### Docker Development (Recommended)
```bash
# Copy environment variables
cp .env.example .env
# Edit .env with your Strava API credentials

# Build the Docker image (one-time setup)
docker compose build jekyll

# Start development environment
docker compose up jekyll
# Available at http://localhost:4000 with live reload

# Start in background
docker compose up -d jekyll

# View logs
docker compose logs -f jekyll
```

### Build Commands
```bash
# Development build
bundle exec jekyll build

# Production build
JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config_prod.yml

# Production build with Strava data refresh
bundle exec rake strava:clubrides && JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config_prod.yml

# Using production script
./_scripts/production.sh
```

### Strava Integration
```bash
# Native
bundle exec rake strava:clubrides --trace
bundle exec rake strava:members

# Docker (using tools container)
docker compose build tools
docker compose --profile tools up -d tools
docker compose exec tools bundle exec rake strava:clubrides
docker compose exec tools bundle exec rake strava:members
```

## Architecture

### Key Directories
- `_posts/`: Blog posts in Markdown format with YAML front matter
- `_pages/`: Static pages (about, contact, etc.)
- `_layouts/`: HTML layout templates
- `_includes/`: Reusable HTML components
- `_lib/`: Ruby modules for Strava API integration
- `_data/`: YAML data files for Strava activities and members
- `_strava_members/`: Individual member profile pages
- `_scripts/`: Build and deployment scripts
- `admin/`: Netlify CMS configuration
- `assets/`: Static assets (images, CSS, JS)

### Content Management
- Uses Netlify CMS for content editing (accessible at `/admin`)
- Posts are created in `_posts/` with filename format `YYYY-MM-DD-title.md`
- Categories: Aktualności, Zawody, Wyprawy, Spotkania, Sponsorzy, Treningi, Wydarzenia
- Authors: "ola" and "tomek" defined in `_config.yml`

### Strava Integration
The site integrates with Strava API to display:
- Recent club rides in tabular format on `/jezdzimy` page
- Individual member activities and profiles
- Requires environment variables: `STRAVA_CLIENT_ID`, `STRAVA_CLIENT_SECRET`, `STRAVA_API_REFRESH_TOKEN`, `STRAVA_API_CLUB_ID`
- API keys can be stored in `./.var-keys/` directory or environment variables

### Collections
- `strava_members`: Collection for cyclist member profiles with Strava data

### Deployment
- Deployed on Netlify
- Production builds triggered by git pushes
- Special Strava webhook builds refresh cycling data
- Uses `_config_prod.yml` for production-specific settings

## Environment Setup

### Docker Development (Recommended)
The project uses a Dockerfile-based setup for optimal development experience:

#### Quick Start
1. Copy `.env.example` to `.env` and configure Strava API credentials
2. Build the image: `docker compose build jekyll`
3. Start development: `docker compose up jekyll`
4. Access site at http://localhost:4000 with live reload

#### Docker Architecture
- **Dockerfile**: Pre-built image with Ruby 3.1, Node.js 18, ImageMagick, and all dependencies
- **jekyll**: Main development server with live reload and volume caching
- **tools** (profile): Container for running rake tasks and builds
- **nginx** (profile): Optional reverse proxy for production-like testing

#### Common Docker Commands
```bash
# Initial build (one-time or after Gemfile changes)
docker compose build jekyll

# Basic development
docker compose up jekyll

# Run Strava tasks
docker compose build tools
docker compose --profile tools up -d tools
docker compose exec tools bundle exec rake strava:clubrides

# Production build test
docker compose exec tools bundle exec jekyll build --config _config.yml,_config_prod.yml

# Shell access
docker compose exec jekyll sh

# Clean rebuild
docker compose down -v && docker compose build --no-cache jekyll && docker compose up jekyll
```

#### Docker Benefits
- **Fast startup**: Dependencies pre-installed during build
- **Consistent environment**: Ruby 3.1, Node.js 18, ImageMagick, all gems
- **Layer caching**: Optimized Dockerfile for faster rebuilds
- **Volume caching**: Persistent gem and Jekyll caches

### Required Environment Variables
```bash
STRAVA_CLIENT_ID=your_client_id
STRAVA_CLIENT_SECRET=your_client_secret  
STRAVA_API_REFRESH_TOKEN=your_refresh_token
STRAVA_API_CLUB_ID=your_club_id
```

### Key Configuration Files
- `_config.yml`: Main Jekyll configuration
- `_config_prod.yml`: Production overrides
- `admin/config.yml`: Netlify CMS configuration
- `Gemfile`: Ruby dependencies including Jekyll plugins
- `Dockerfile`: Docker image definition with Ruby 3.1, Node.js 18, ImageMagick
- `docker-compose.yml`: Multi-service development environment
- `.env.example`: Template for environment variables

### Technical Stack
- **Jekyll**: 4.3.1 (static site generator)
- **Ruby**: 3.1 (via Docker)
- **Node.js**: 18.x (JavaScript runtime for minification)
- **ImageMagick**: For image processing via jekyll-resize plugin
- **Bootstrap**: 4.4.1 (CSS framework)

### Important Plugins
- jekyll-paginate: For paginated post listings
- jekyll-seo-tag: SEO optimization
- jekyll-minifier: Asset minification (requires Node.js)
- jekyll-leaflet: Map integration
- jekyll-archives: Category/tag archives
- jekyll-resize: Image resizing (requires ImageMagick)