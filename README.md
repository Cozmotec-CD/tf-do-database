

# tf-do-db
Provides a DigitalOcean Droplet resource. This can be used to create, modify, and delete Droplets.

## Examples

```hcl

provider "digitalocean" {}

locals {
  name        = "app"
  environment = "test"
  region      = "blr1"
}
##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "terraform-do-modules/vpc/digitalocean"
  version     = "1.0.0"
  name        = local.name
  environment = local.environment
  region      = local.region
  ip_range    = "10.10.0.0/16"
}

##------------------------------------------------
## postgresql database cluster module call
##------------------------------------------------
module "postgresql" {
  source                       = "../../"
  name                         = local.name
  environment                  = local.environment
  region                       = local.region
  cluster_engine               = "pg"
  cluster_version              = "15"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  cluster_maintenance = {
    maintenance_hour = "02:00:00"
    maintenance_day  = "saturday"
  }
  databases = ["testdb"]
  users = [
    {
      name = "test"
    }
  ]

  create_pools = true
  pools = [
    {
      name    = "test",
      mode    = "transaction",
      size    = 10,
      db_name = "testdb",
      user    = "test"
    }
  ]

  create_firewall = false
  firewall_rules = [
    {
      type  = "ip_addr"
      value = "0.0.0.0"
    }
  ]
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | >= 2.29.0 |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.4 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.29.0 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | github.com/Cozmotec-CD/tf-do-labels | n/a |
## Resources

| Name | Type |
|------|------|
| [digitalocean_database_cluster.cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_cluster) | resource |
| [digitalocean_database_connection_pool.connection_pool](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_connection_pool) | resource |
| [digitalocean_database_db.database](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_db) | resource |
| [digitalocean_database_firewall.firewall](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_firewall) | resource |
| [digitalocean_database_firewall.replica-firewall](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_firewall) | resource |
| [digitalocean_database_replica.replica-example](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_replica) | resource |
| [digitalocean_database_user.user](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_user) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_restore"></a> [backup\_restore](#input\_backup\_restore) | The day and the start hour of the maintenance window policy | `map(string)` | `null` | no |
| <a name="input_cluster_engine"></a> [cluster\_engine](#input\_cluster\_engine) | Database engine used by the cluster (ex. pg for PostreSQL, mysql for MySQL, redis for Redis, or mongodb for MongoDB) | `string` | `""` | no |
| <a name="input_cluster_maintenance"></a> [cluster\_maintenance](#input\_cluster\_maintenance) | The day and the start hour of the maintenance window policy | `map(string)` | `null` | no |
| <a name="input_cluster_node_count"></a> [cluster\_node\_count](#input\_cluster\_node\_count) | Number of nodes that will be included in the cluster | `number` | `1` | no |
| <a name="input_cluster_private_network_uuid"></a> [cluster\_private\_network\_uuid](#input\_cluster\_private\_network\_uuid) | The ID of the VPC where the database cluster will be located | `string` | `null` | no |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Database Droplet size associated with the cluster (ex. db-s-1vcpu-1gb) | `string` | `"db-s-1vcpu-1gb"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The version of the cluster | `string` | `""` | no |
| <a name="input_create_firewall"></a> [create\_firewall](#input\_create\_firewall) | Controls if firewall should be created | `bool` | `false` | no |
| <a name="input_create_pools"></a> [create\_pools](#input\_create\_pools) | Controls if pools should be created | `bool` | `false` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | A list of databases in the cluster | `list(string)` | `[]` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Flag to control the resources creation. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | List of firewall rules associated with the cluster | `list(map(string))` | `[]` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br/>  "name",<br/>  "environment"<br/>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'terraform-do-modules' or 'hello@clouddrove.com' | `string` | `"terraform-do-modules"` | no |
| <a name="input_mysql_sql_mode"></a> [mysql\_sql\_mode](#input\_mysql\_sql\_mode) | A comma separated string specifying the SQL modes for a MySQL cluster. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_pools"></a> [pools](#input\_pools) | A list of connection pools in the cluster | `list(map(string))` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project that the database cluster is assigned to. If excluded when creating a new database cluster, it will be assigned to your default project. | `string` | `null` | no |
| <a name="input_redis_eviction_policy"></a> [redis\_eviction\_policy](#input\_redis\_eviction\_policy) | A string specifying the eviction policy for a Redis cluster. Valid values are: noeviction, allkeys\_lru, allkeys\_random, volatile\_lru, volatile\_random, or volatile\_ttl | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | DigitalOcean region where the cluster will reside | `string` | `null` | no |
| <a name="input_replica_enable"></a> [replica\_enable](#input\_replica\_enable) | Flag to control the resources creation. | `bool` | `false` | no |
| <a name="input_replica_region"></a> [replica\_region](#input\_replica\_region) | DigitalOcean region where the replica will reside | `string` | `null` | no |
| <a name="input_replica_size"></a> [replica\_size](#input\_replica\_size) | Database Droplet size associated with the replica (ex. db-s-1vcpu-1gb). Note that when resizing an existing replica, its size can only be increased. Decreasing its size is not supported. | `string` | `"db-s-1vcpu-1gb"` | no |
| <a name="input_storage_size_mib"></a> [storage\_size\_mib](#input\_storage\_size\_mib) | Defines the disk size, in MiB, allocated to the cluster | `string` | `null` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of users in the cluster | `list(map(string))` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_pool_host"></a> [connection\_pool\_host](#output\_connection\_pool\_host) | The hostname used to connect to the database connection pool |
| <a name="output_connection_pool_id"></a> [connection\_pool\_id](#output\_connection\_pool\_id) | The ID of the database connection pool |
| <a name="output_connection_pool_password"></a> [connection\_pool\_password](#output\_connection\_pool\_password) | Password for the connection pool's user |
| <a name="output_connection_pool_port"></a> [connection\_pool\_port](#output\_connection\_pool\_port) | Network port that the database connection pool is listening on |
| <a name="output_connection_pool_private_host"></a> [connection\_pool\_private\_host](#output\_connection\_pool\_private\_host) | Same as pool host, but only accessible from resources within the account and in the same region |
| <a name="output_connection_pool_private_uri"></a> [connection\_pool\_private\_uri](#output\_connection\_pool\_private\_uri) | Same as pool uri, but only accessible from resources within the account and in the same region |
| <a name="output_connection_pool_uri"></a> [connection\_pool\_uri](#output\_connection\_pool\_uri) | The full URI for connecting to the database connection pool |
| <a name="output_database_cluster_default_database"></a> [database\_cluster\_default\_database](#output\_database\_cluster\_default\_database) | Name of the cluster's default database |
| <a name="output_database_cluster_default_password"></a> [database\_cluster\_default\_password](#output\_database\_cluster\_default\_password) | Password for the cluster's default user |
| <a name="output_database_cluster_default_user"></a> [database\_cluster\_default\_user](#output\_database\_cluster\_default\_user) | Username for the cluster's default user |
| <a name="output_database_cluster_host"></a> [database\_cluster\_host](#output\_database\_cluster\_host) | The hostname of the database cluster |
| <a name="output_database_cluster_id"></a> [database\_cluster\_id](#output\_database\_cluster\_id) | The id of the database cluster |
| <a name="output_database_cluster_port"></a> [database\_cluster\_port](#output\_database\_cluster\_port) | Network port that the database cluster is listening on |
| <a name="output_database_cluster_private_host"></a> [database\_cluster\_private\_host](#output\_database\_cluster\_private\_host) | Same as host, but only accessible from resources within the account and in the same region |
| <a name="output_database_cluster_uri"></a> [database\_cluster\_uri](#output\_database\_cluster\_uri) | The full URI for connecting to the database cluster |
| <a name="output_database_cluster_urn"></a> [database\_cluster\_urn](#output\_database\_cluster\_urn) | The uniform resource name of the database cluster |
| <a name="output_database_firewall_id"></a> [database\_firewall\_id](#output\_database\_firewall\_id) | A unique identifier for the firewall |
| <a name="output_database_firewall_rule"></a> [database\_firewall\_rule](#output\_database\_firewall\_rule) | A map with rule's uuid, type, value and created\_at params |
| <a name="output_database_replica_firewall_rule"></a> [database\_replica\_firewall\_rule](#output\_database\_replica\_firewall\_rule) | A map with rule's uuid, type, value and created\_at params |
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | The name for the database |
| <a name="output_replica_cluster_default_database"></a> [replica\_cluster\_default\_database](#output\_replica\_cluster\_default\_database) | Name of the replica's default database. |
| <a name="output_replica_cluster_default_password"></a> [replica\_cluster\_default\_password](#output\_replica\_cluster\_default\_password) | Password for the replica cluster's default user |
| <a name="output_replica_cluster_default_user"></a> [replica\_cluster\_default\_user](#output\_replica\_cluster\_default\_user) | Username for the replica cluster's default user |
| <a name="output_replica_cluster_port"></a> [replica\_cluster\_port](#output\_replica\_cluster\_port) | Network port that the database replica is listening on. |
| <a name="output_replica_cluster_private_host"></a> [replica\_cluster\_private\_host](#output\_replica\_cluster\_private\_host) | Same as host, but only accessible from resources within the account and in the same region. |
| <a name="output_replica_cluster_uri"></a> [replica\_cluster\_uri](#output\_replica\_cluster\_uri) | The full URI for connecting to the database replica. |
| <a name="output_replica_host_name"></a> [replica\_host\_name](#output\_replica\_host\_name) | The ID of the database replica created by Terraform. |
| <a name="output_replica_id"></a> [replica\_id](#output\_replica\_id) | The ID of the database replica created by Terraform. |
| <a name="output_user_password"></a> [user\_password](#output\_user\_password) | Password for the database user |
| <a name="output_user_role"></a> [user\_role](#output\_user\_role) | Role for the database user |