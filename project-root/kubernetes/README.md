
Requirements
Provisioned infrastructure from previous task (Terraform: 1 control plane + 1 worker node, private subnet)

Kubernetes set up via kubeadm

1x control plane, 1x worker

Networking plugin (Calico or Flannel)

Metrics Server

🛠️ Technologies Used
kubeadm (for cluster bootstrapping)

containerd (container runtime)

Calico (networking plugin)

Metrics Server (for cluster metrics)

 Steps to Deploy
 Prepare the Nodes (control plane + worker)
On Both Nodes:

sudo apt update && sudo apt install -y apt-transport-https curl
sudo modprobe overlay
sudo modprobe br_netfilter
Enable required kernel modules:

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
Install containerd:

sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
2. Install Kubernetes Components

sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

Control Plane Initialization
On the control plane node:


sudo kubeadm init --pod-network-cidr=192.168.0.0/16
After successful init:


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

Install Network Plugin (Calico)

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml
Join Worker Node
On the worker node, run the command provided by kubeadm init, e.g.:


sudo kubeadm join <control-plane-ip>:6443 --token <token> \
    --discovery-token-ca-cert-hash sha256:<hash>
You can re-generate this with:


kubeadm token create --print-join-command
Deploy Metrics Server
On the control plane node:


kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
Patch insecure TLS for kubelet:


kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

Check Node Status

kubectl get nodes
Check Pods

kubectl get pods -A
Verify Metrics Server

kubectl top nodes
kubectl top pods
