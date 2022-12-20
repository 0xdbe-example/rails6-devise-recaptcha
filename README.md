# Rails 6.X: Devise with recaptcha


## Deploy locally

- Install and start Postgresql

- Create user in postgresql

```
$ sudo -u postgres createuser --pwprompt --createdb rails
```

- Set env vars in ``.envrc`` file

```
export DATABASE_HOSTNAME='*************'
export DATABASE_NAME='*************'
export DATABASE_PASSWORD='*************'
export DATABASE_USERNAME='rails'
export NODE_OPTIONS='--openssl-legacy-provider'
export SECRET_KEY_BASE='*************'
export RECAPTCHA_SITE_KEY='*************'
export RECAPTCHA_SECRET_KEY='*************'
```

- Load env vars using direnv

```
direnv allow
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