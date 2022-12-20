module "gcp_project" {
  source             = "git::https://github.com/0xdbe-terraform/terraform-gcp-project.git?ref=v1.1.1"

  organization_id    = var.organization_id
  billing_account_id = var.billing_account_id
  project_short_name = var.project_short_name
  project_long_name  = var.project_long_name
}

module "gcp_app_engine" {
  source              = "git::https://github.com/0xdbe-terraform/terraform-gcp-app-engine.git?ref=v1.0.2"
  
  iap_enable           = false
  location_id          = "europe-west"
  project_id           = module.gcp_project.project_id
}

module "gcp_sql_database" {
  source                     = "git::https://github.com/0xdbe-terraform/terraform-gcp-sql-database.git?ref=v1.0.3"
  location_id                  = "europe-west1"
  project_id                   = module.gcp_project.project_id
  project_number               = module.gcp_project.project_number
  role_cloudsql_editor_members = [
    "serviceAccount:${module.gcp_project.project_id}@appspot.gserviceaccount.com"
  ]
  depends_on = [
    module.gcp_app_engine
  ]
}

resource "local_file" "app" {
    content = templatefile("${path.module}/app.yaml.tftpl", {
        database_connection_name = module.gcp_sql_database.database_connection_name
        database_name            = module.gcp_sql_database.database_name
        database_password        = module.gcp_sql_database.database_password
        database_username        = module.gcp_sql_database.database_username
        recaptcha_secret_key     = var.recaptcha_secret_key
        recaptcha_site_key       = var.recaptcha_site_key
        secret_key_base          = var.secret_key_base

    })
    filename = "${path.module}/../../../app.yaml"
}

resource "local_file" "envrc" {
    content = templatefile("${path.module}/envrc.gcp.tftpl", {
        database_connection_name = module.gcp_sql_database.database_connection_name
        database_instance        = module.gcp_sql_database.database_instance
        database_name            = module.gcp_sql_database.database_name
        database_password        = module.gcp_sql_database.database_password
        database_username        = module.gcp_sql_database.database_username
        project_id               = module.gcp_project.project_id
        recaptcha_secret_key     = var.recaptcha_secret_key
        recaptcha_site_key       = var.recaptcha_site_key
        secret_key_base          = var.secret_key_base
    })
    filename = "${path.module}/../../../.envrc.gcp"
}