variable "client_id" {
  description = "the Azure Application ID, which identifies your application"
  type = string
  sensitive = true
}

variable "client_secret" {
  description = "Azure Application Secret, which serves as the application's password"
  type = string
  sensitive = true
}

variable "subscription_id" {
  description = "Azure account subrciption ID"
  type = string
  sensitive = true
}

variable "tenant_id" {
  description = "Azure account tenant ID"
  type = string
  sensitive = true
} 
  