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

