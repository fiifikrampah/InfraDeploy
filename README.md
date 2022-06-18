# AWS Infrastructure Provisioning via Terraform + Packer + Ansible

## Objective

To use Packer to generate a custom AWS EC2 Machine Image (AMI),
which is pre-configured via Ansible to install and run apache2,
and is then consumed by Terraform to provision immutable EC2 instances
as web servers.

## Built With

- Ansible
- Packer
- Terraform

## File Structure

```bash
.
├── README.md
├── ansible
│   ├── files
│   │   ├── apache2.conf.j2
│   │   └── index.html.j2
│   ├── playbook.yml
│   └── vars
│       └── default.yml
├── packer
│   ├── builder.pkr.hcl
│   ├── sources.pkr.hcl
│   └── variables.pkr.hcl
└── terraform
```

## Getting Started

### Prerequisites

- Create a free tier AWS account.
- Create an IAM user with programmable access. Copy the Access Key ID and Secret.
- Run `aws configure` via the AWS CLI and paste the Access Key ID and Secret.

## Installation

- Clone the repo:
`git clone https://github.com/fiifikrampah/InfraDeploy`
- Spin up a docker container using the DockerHub image:
`docker run -it --rm -v $(pwd)/InfraDeploy:/home fiifikay09/aws_infra_setup`
- Alternatively, you can build the image locally and spin up a container with that image:
`docker build -t <tag> . && docker run -it --rm -v $(pwd):/home <image>`

## CD setup

A Jenkins pipeline project can be configured to run the steps of the Jenkinsfile to
provision the AWS infrastructure.
Requried Plugins:

- SSH Agent
- Docker
- Docker Commons Plugin
- Docker pipeline
- SSH Credentials plugin
- Git plugin

Additionally, include a git private key, AWS ACCESS ID, and AWS SECRET ACCESS KEY
as Jenkins credentials.
