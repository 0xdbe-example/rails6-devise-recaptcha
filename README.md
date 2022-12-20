# Rails 6.X: Devise with recaptcha


## Deploy locally

- Subscribe to reCaptchaV3: https://www.google.com/recaptcha/

- Install and start Postgresql

- Create user in postgresql

```
$ sudo -u postgres createuser --pwprompt --createdb rails
```

- Generate ``secret key base`` for Rails app

```
bundle exec rails secret
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

## Deploy on GCP

### Create infra

- install ``glcoud`` cli

- Subscribe to reCaptchaV3: https://www.google.com/recaptcha/

- Generate ``secret key base`` for Rails app

```
bundle exec rails secret
```

- Define infra parameters in ``cloud/gcp/terraform/terraform.tfvars``:

```
billing_account_id   = "************"
organization_id      = "************"
project_short_name   = "rdrc"
project_long_name    = "Rail-Devise-reCaptcha"
recaptcha_site_key   = "************"
recaptcha_secret_key = "************"
secret_key_base      = "************"
```

- Create infra (running time: 20 minutes due to database creation)

```
cd cloud/gcp/terraform/
terraform init
terraform apply
```

- Terraform generate ``app.yaml`` and ``envrc.gcp`` with all needed values

### Database migration

- open terminal in root project dir

- rename ``envrc.gcp`` to ``envrc`` then load env vars 

```
direnv allow
```

- Install Cloud SQL Auth Proxy

```
curl -L https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 --output cloud_sql_proxy
chmod +x cloud_sql_proxy
```

- Run Cloud SQL Auth Proxy

```
cloud_sql_proxy -instances="$DATABASE_CONNECTION_NAME"=tcp:5432
```

**Note:** Cloud SQL Auth Proxy uses TCP/3307 port, check your firewall settings in case of error

- Run database migration (in another terminal with env vars loaded)

```
bundle exec rake db:migrate
```

### Deploy

- Deploy application

```
gcloud app deploy
```

- Add application hostname in allowed hostname for reCapcha v3