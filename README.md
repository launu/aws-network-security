# AWS Network Security Lab — Bastion Host Architecture

Terraform configuration for a segmented AWS network that uses a bastion host (jump box) to control access to a private instance, plus a simpler single-instance exercise.

## What this demonstrates

- **Bastion host pattern.** Only one instance (`Bastion`) is reachable from the internet. A second instance (`Instance`) has no direct public access — it can only be reached by RDP, and only from the bastion.
- **Least-privilege security groups.** The bastion's security group allows inbound RDP (3389) from a single source IP. The internal instance's security group allows inbound RDP only from the *bastion's security group ID* — not from any IP address — so traffic has to pass through the bastion first.
- **Subnet and routing.** A dedicated subnet and route table were created and associated, with a route to an internet gateway for outbound access.

## Files

- **`NetworkLevelSecurity.tf`** — the bastion host lab: subnet, route table, two security groups (bastion + internal instance), and two EC2 instances.
- **`VMs-Cloud.tf`** — a simpler exercise: a single EC2 instance with a security group restricting inbound RDP to one source IP.

## Notes

- Source IPs have been replaced with `YOUR_IP/32` placeholders. Replace with your own IP before running `terraform apply`.
- These were built in a personal/coursework AWS environment. The VPC, AMI, and subnet IDs are specific to that environment and won't resolve in a different AWS account without updating them.

## Usage

```
terraform init
terraform plan
terraform apply
```

Requires an AWS account, an existing VPC and internet gateway, and an EC2 key pair matching the `key_name` used in each file.
