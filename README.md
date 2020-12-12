# influxdb-telegraf-grafana-on-docker

This repository demonstrates setting up InlfuxDB - Telegraf - Grafana on Docker hosted on a AWS EC2 instance.

This represents a variation of the TICK stack (Telegraf, InfluxDB, Chronograf, Kapacitor) where we replace Chronograf with Grafana for visualization.

## Run Locally

To run this; execute the usual Terraform lifecycle of commands to spin up infrastructure resources (`init`, `plan`, `apply`)

Optionally; for myself i've created a `local.tfvars` listing all the variables expected where I can pass in on the CLI.

```bash
AWS_PROFILE=__PROFILE__ terraform init -var-file local.tfvars
AWS_PROFILE=__PROFILE__ terraform plan -var-file local.tfvars
AWS_PROFILE=__PROFILE__ terraform apply -var-file local.tfvars
```

## Author

Colin But