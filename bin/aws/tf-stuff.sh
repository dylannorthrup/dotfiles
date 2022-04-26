#!/bin/bash

get-aws-ips -y | tee out
terraform init && \
  terraform plan -out my.plan && \
  terraform apply my.plan

