# Nginx Web Server Deployment with Ansible

## Description
This playbook installs and configures an nginx web server on the Candidate Test VM (3.248.170.28). It configures HTTP and HTTPS with a self-signed certificate and serves a simple HTML page showing the server hostname.

---

## Prerequisites
- Access to the Candidate Test VM via SSH with the provided key.
- Ansible installed on your local machine.
- Network access to the server's public IP.

---

## Deployment Steps

1. Clone this repository or copy the ansible directory to your local machine.

2. Update `inventory.ini` if necessary with your private key path and username.

3. Run the playbook:


ansible-playbook -i inventory.ini playbook.yml

