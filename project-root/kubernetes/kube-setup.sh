cat kube-setup.sh
#!/bin/bash

set -e

echo "[1/5] Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "[2/5] Loading kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter

echo "[2/5] Making kernel modules persistent..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

echo "[2/5] Applying sysctl params..."
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

echo "[3/5] Installing containerd dependencies..."
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

echo "[3/5] Adding Docker's GPG key for containerd..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/containerd.gpg

echo "[3/5] Adding Docker apt repository..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "[3/5] Installing containerd..."
sudo apt update
sudo apt install -y containerd

echo "[3/5] Configuring containerd to use SystemdCgroup..."
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

echo "[4/5] Adding Kubernetes APT repository..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/k8s.gpg
echo 'deb [signed-by=/etc/apt/keyrings/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/k8s.list

echo "[5/5] Installing kubeadm, kubelet, and kubectl..."
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[6/6] Initializing Kubernetes control plane..."
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 | tee kubeadm-init.log

echo " Kubernetes control plane initialized."

# Save the join command to a file
grep "kubeadm join" kubeadm-init.log -A 2 > kubeadm-join-command.sh
chmod +x kubeadm-join-command.sh
echo " Join command saved to kubeadm-join-command.sh"

# Set up kubeconfig for current user
echo "onfiguring kubectl access for user: $USER"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo " Installing Calico CNI..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml

echo " Installing metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo " Patching metrics-server for insecure TLS..."
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

echo " Kubernetes setup complete!"
echo
echo "Run this command on worker nodes to join the cluster:"
cat kubeadm-join-command.sh


echo "Kubernetes prerequisites setup complete."