variable "resource_group_name" {
  type        = string
  description = "rg name"
  default     = "Devopsrg"

}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "subscription_id" {
    type        = string
    description = "Azure subscription ID"
 }
