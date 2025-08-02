Nginx Web Server Deployment with Ansible

Description
This Ansible playbook installs and configures an NGINX web server on the provided Candidate Test VM (3.248.170.28). It supports both HTTP and HTTPS using a self-signed certificate, and serves a basic HTML page showing the server's hostname.

The playbook is structured using Ansible roles, a template for the index.html, and a group-based inventory.

Prerequisites
Ensure the following are set up before running the playbook:

SSH access to the target VM (you have the public IP + SSH private key)

Ansible installed locally (ansible --version to verify)

VM is accessible on ports 22 (SSH), 80 (HTTP), and 443 (HTTPS)

📁 Directory Structure

ansible-webserver/
─ inventory.ini                     # Inventory file with target host
─ web.yml                           # Main playbook entry point
─ roles/
    nginx/
       tasks/
        main.yml                     # Task definitions (install, configure nginx)
       templates/
        index.html.j2                # HTML template served by nginx
       files/
          cert.pem                    # Self-signed SSL cert
           key.pem                    # SSL private key
       handlers/
         main.yml                   # Nginx service restart handler


What the Playbook Does
Installs nginx

Places a custom index.html using the Jinja2 template

Copies SSL certificate and key to /etc/nginx/ssl/

Configures NGINX to:

Serve HTTP (port 80)

Redirect to HTTPS (port 443)

Serve a hostname-rendered page via HTTPS

Ensures nginx is running and enabled

Configurable Inventory (inventory.ini)

[candidate]
3.248.170.28 ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/id_rsa


Deployment Steps
Clone or copy this repository locally:


git clone <repo-url> && cd ansible
Review and edit inventory.ini if needed.

Run the playbook:


ansible-playbook -i inventory.ini web.yml

Once completed:

Visit http://<IP> → should redirect to HTTPS

Visit https://<IP> → should show an HTML page with the server's hostname

SSH into the machine and run:


curl -k https://localhost

Externall access: https://3.248.170.28/


