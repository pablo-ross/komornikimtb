FROM ruby:3.1-slim

# Set environment variables
ENV JEKYLL_ENV=development
ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_HOME=/usr/local/bundle

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      git \
      imagemagick \
      libmagickwand-dev \
      curl \
      && rm -rf /var/lib/apt/lists/*

# Install Node.js 18.x (for JavaScript runtime)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /srv/jekyll

# Copy Gemfile and Gemfile.lock first for better caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --retry 3 --jobs 4

# Expose ports
EXPOSE 4000 35729

# Default command for development
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--watch", "--livereload", "--force_polling", "--incremental", "--drafts"]