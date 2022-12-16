# Rails 6.X: Devise with recaptcha

## Deploy

### Local

- Set env vars in .env file

```
RECAPTCHA_SITE_KEY=************
RECAPTCHA_SECRET_KEY=************
DATABASE_USERNAME=rails
DATABASE_PASSWORD=************
DATABASE_HOSTNAME=localhost
DATABASE_NAME=rails
NODE_OPTIONS=--openssl-legacy-provider
```

- Install Postgresql

- Create user in postgresql

```
$ sudo -u postgres createuser --pwprompt --createdb rails
```

- Create database in postgresql

```
$ rails db:create
$ rails db:migrate RAILS_ENV=development
```

- Start

```
rails server
```