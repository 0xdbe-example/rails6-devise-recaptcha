variable "billing_account_id" {
  type        = string
  default     = ""
  description = "Identifier of you Billing Account already existing in your Organization"
}

variable "organization_id" {
  type        = string
  description = "Identifier of your organization on GCP"
}

variable "project_long_name" {
  type        = string
  description = "Name of your application, project, product or service."
}

variable "project_short_name" {
  type        = string
  description = "Short name of your project using abbreviations or acronyms."
  validation {
    condition     = can(regex("^\\w+$", var.project_short_name))
    error_message = "Project short name can only consist of letters and numbers."
  }
}

variable "secret_key_base" {
  type        = string
  description = "Master key for rails application"
}

variable "recaptcha_site_key" {
  type        = string
  description = "Site key for reCaptcha"
}

variable "recaptcha_secret_key" {
  type        = string
  description = "Secret key for reCaptcha"
}
