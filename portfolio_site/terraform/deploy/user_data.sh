#!/bin/bash
# This user-data script sets up a Rails environment on a fresh Ubuntu EC2 instance
# and deploys the portfolio blog application.  It is executed automatically
# during instance initialization.  Update <YOUR_REPO_URL> with the URL of the
# Git repository containing this project.

set -eux

# Update package index and install prerequisites
sudo apt-get update -y
sudo apt-get install -y build-essential libpq-dev curl gnupg2 git-core software-properties-common

# Install Node.js (needed for Rails asset pipeline) and Yarn
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update -y && sudo apt-get install -y yarn

# Install RVM (Ruby Version Manager) and Ruby
gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
  409B6B1796C275462A1703113804BB82D39DC0E3 \
  7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --ruby
source /etc/profile.d/rvm.sh
rvm install ruby --latest
rvm use ruby --default

# Install Rails
gem install rails -v "~> 7.1.0" --no-document

# Create application directory
APP_DIR="/home/ubuntu/portfolio_site"
sudo mkdir -p "$APP_DIR"
sudo chown ubuntu:ubuntu "$APP_DIR"

# Clone or update the application repository
REPO_URL="<YOUR_REPO_URL>"
if [ -z "$REPO_URL" ] || [ "$REPO_URL" = "<YOUR_REPO_URL>" ]; then
  echo "ERROR: REPO_URL is not set in user_data.sh" >&2
  exit 1
fi

if [ ! -d "$APP_DIR/.git" ]; then
  git clone "$REPO_URL" "$APP_DIR"
else
  cd "$APP_DIR"
  git pull
fi

# Install gem dependencies (production only)
cd "$APP_DIR"
bundle install --without development test

# Set up the database (uses DATABASE_* environment variables if provided)
RAILS_ENV=production bundle exec rails db:create db:migrate

# Precompile assets for production
RAILS_ENV=production bundle exec rails assets:precompile

# Launch the Rails server in the background on port 80
RAILS_ENV=production bundle exec rails server -b 0.0.0.0 -p 80 -d