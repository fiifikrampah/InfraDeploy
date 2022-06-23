# Set the base image
FROM ubuntu:bionic-20220531

# Specify Packer, Ansible and Terraform versions
ARG PACKER_VERSION="1.8.1"
ARG ANSIBLE_VERSION="2.11.12"
ARG TERRAFORM_VERSION="1.2.1"
ARG DEBIAN_FRONTEND=noninteractive

# Add metadata
LABEL maintainer="Fiifi Krampah <fiifi.krampah@gmail.com>"
LABEL packer_version=${PACKER_VERSION}
LABEL terraform_version=${TERRAFORM_VERSION}
LABEL ansible_version=${ANSIBLE_VERSION}

# Specify some environment variables
ENV PACKER_VERSION=${PACKER_VERSION}
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}
ENV ANSIBLE_VERSION=${ANSIBLE_VERSION}
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Update ansd install the required packages
RUN apt update \
    && apt install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt install -y curl python3.9 python3-nacl python3-pip libffi-dev unzip openssh-client openssh-server git\
    && pip3 install ansible-core==${ANSIBLE_VERSION} \
    && curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && curl -LO https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip '*.zip' -d /usr/local/bin \
    && rm *.zip \
    && apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set /home as the pwd as the project will be mounted to /home
WORKDIR /home

# Run bash in the container
CMD    ["/bin/bash"]