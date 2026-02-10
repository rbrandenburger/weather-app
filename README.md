# Remington's Weather App

## Developer Setup Guide

### Requirements
- Ruby 3.1.6
- Bundler 2.5.18

<br>

1. Install gems with bundler

```sh
bundle install
```

2. Migrate the SQLite database
```sh
bin/rails db:migrate
```

3. Start the Rails server
```sh
bin/rails s -p 3000
```

Tests can be run with RSpec:
```sh
bundle exec rspec
```
---

## Deploying a New Container 
1. Stop currently running container:
```sh
sudo docker ps
sudo docker stop <container-name>
```

2. Start new container:
```sh
sudo docker run -d -p 5001:5001 --env-file .env -v weather_data:/rails/storage <name>:<tag>
```
