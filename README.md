# NextGen DevOps Platform: Jenkins, GitOps & Storage

🚀 **One-click end-to-end DevOps platform deployment.** The entire infrastructure, enterprise-grade storage, and platform lifecycle is fully orchestrated via **Ansible** (with **Terraform** executed internally) on **DigitalOcean**. This next-generation iteration bootstraps a Kubernetes (K8s) cluster, a high-availability **Rook Ceph** storage layer, an **Argo CD** GitOps engine, and a **Jenkins** server from scratch using a modular Bash script pipeline, automatically provisioning application build jobs via the Jenkins API and preparing declarative storage volumes.

## 🏗️ Architecture & Workflow

*   **Infrastructure (Terraform inside Ansible):** Ansible acts as the single entry point, triggering Terraform under the hood to automatically provision DigitalOcean droplets and networking. Dynamic inventory is managed entirely in-memory.
*   **Platform Bootstrap (Ansible & Bash):** A comprehensive multi-step configuration playbook coordinates localized system preparations, network policies (Calico), and core components via native Bash scripting layers.
*   **Cloud-Native Storage (Rook Ceph):** Automates the kernel configuration (`rbd` module loading), installs the Rook operator, and provisions a resilient Ceph storage cluster. It maps a dedicated `CephBlockPool` and `StorageClass` to deliver automated Dynamic Storage Provisioning (via PVCs) for target workloads.
*   **Continuous Integration (Jenkins):** Deploys Jenkins via Helm and leverages the Jenkins Remote Access API to programmatically inject the Nginx build pipeline configuration template (`nginx.xml`) directly into the cluster to handle automated CI workflows.
*   **GitOps Continuous Delivery (Argo CD):** Bootstraps Argo CD directly into the cluster to enforce declarative git-centric continuous delivery, implementing the GitOps model for seamless deployment synchronization.
*   **Summary & Output (Final Layer):** The automation process concludes by executing the final script layer. All generated endpoints, credentials, and health statuses are cleanly displayed in the console output.

## 📂 Repository Structure

```text
nextgen-devops-platform-jenkins-gitops-storage/
├── ansible/
│   └── bootstrap.yml               # The master playbook (Runs Terraform & orchestrates the setup)
├── scripts/                        # --- MODULAR PLATFORM PIPELINE ---
│   ├── install_apt_helm.sh         # Installs system dependencies and Helm package manager
│   ├── install_kubernetes.sh       # Provisions Kubernetes Control Plane nodes
│   ├── install_kubernetes_worker.sh# Joins worker nodes to the active K8s cluster
│   ├── install_calico.sh           # Configures Calico CNI networking plugin
│   ├── modprobe_rbd.sh             # Loads the Ceph RADOS Block Device (RBD) kernel module
│   ├── install_k8s_rook.sh         # Deploys the Rook Ceph operator into the cluster
│   ├── conf_ceph_storage.sh        # Configures the underlying Ceph storage pooling layer
│   ├── install_argocd.sh           # Installs and bootstraps the Argo CD platform
│   ├── install_helm_jenkins.sh     # Automates the Jenkins platform deployment via Helm
│   ├── job_build_api.sh            # Executes deployment triggers via Jenkins Remote Access API
│   ├── nginx.xml                   # Jenkins Job configuration XML template for the Nginx pipeline
│   └── final.sh                    # Summarizes cluster state: outputs node IPs, credentials, Jenkins & Argo CD URLs
├── storage/                        # --- CLOUD-NATIVE STORAGE MANIFESTS ---
│   ├── cephblockpool.yaml          # Defines the Ceph logical block storage pool
│   ├── cephstorageclass.yaml       # Configures the K8s StorageClass mapping to Rook Ceph RBD
│   └── pvc_nginx.yaml              # Sample PersistentVolumeClaim for Nginx resilient storage
└── terraform/                      # --- INFRASTRUCTURE AS CODE ---
    ├── main.tf                     # DigitalOcean resource templates (executed by Ansible)
    └── vars.auto.tfvars.example    # Variable template for API access tokens and SSH keys
```

## 🚀 Getting Started

### 1. Prerequisites
Ensure you have the following tools, credentials, and configurations ready before execution:
*   **Ansible** (installed on your local control node)
*   **Terraform** (installed on your local control node)
*   **DigitalOcean Personal Access Token** (Read/Write API token generated from your DigitalOcean cloud console)
*   **SSH Key Pair** (generated locally via `ssh-keygen`)

### 2. Configuration
Navigate to the `terraform/` folder, copy the template variable file, and populate it with your cloud credentials:

```bash
cd terraform
cp vars.auto.tfvars.example vars.auto.tfvars
```

Open `vars.auto.tfvars` and update the placeholders with your actual DigitalOcean API Token and public key location:

```hcl
digitalocean_token = "PUT YOUR ACTUAL TOKEN HERE"
public_key         = "~/.ssh/id_ed25519.pub"
```

### 3. One-Click Deployment
Return to the project root directory. The entire platform lifecycle—from bare-metal cloud provisioning and storage pooling to GitOps bootstrap and CI pipeline rendering—is managed using a single entry point. Execute the primary playbook:

```bash
ansible-playbook ansible/bootstrap.yml
```

### Re-running the Final Script
To re-run the `final.sh` script (provided that the infrastructure is already up and running), execute the following Ansible playbook:

```bash
ansible-playbook bootstrap.yml --tags "terraform,final"
```
*Note: The `terraform` tag is required here to fetch the current state and IP addresses of the existing infrastructure before executing the `final` script tasks.*

**Teardown:** To cleanly destroy all provisioned cloud resources, navigate to the directory and run the destroy command:

```bash
cd terraform
terraform destroy
```
*Note: You will be prompted to type `yes` to confirm the destruction of the resources.*


### 📊 Automation Outputs & Verification
Once the execution hits **Task 15** in the Ansible playbook, the stdout will stream the complete output from `final.sh` directly to your console. This summary provides everything you need to start using the platform immediately:

*   **Ceph Cluster Status:** Real-time health check verification showing whether the storage tier initialized successfully.
*   **Jenkins Web Portal:** The public URL web link alongside the automatically generated administrator username and password.
*   **Argo CD Web Portal:** The public URL web link alongside the secure administrator username and access password.
*   **Cluster Node Registry:** A list of active DigitalOcean droplet IP addresses provisioned during the session.

## 🛠️ Future Improvements (Roadmap)

Planned upgrades to transition this bootstrap into a production-hardened environment:

*   **Rancher Integration:** Implement Rancher for centralized multi-cluster management, unified RBAC, and visual monitoring of infrastructure components.
*   **OS & Cluster Security:** Hardening node operating systems via Ansible (SSH tuning, firewalls) and implementing strict Calico NetworkPolicies.
*   **Grafana & Prometheus Stack:** Deploy a full observability layer with native dashboards to monitor node metrics and Rook Ceph storage IOPS.
*   **Secure Credential Management:** Integrate HashiCorp Vault or Argo CD Sealed Secrets to fully eliminate plaintext passwords and tokens from the repository.

## 📄 License
This project is open-source and available under the terms of the MIT License.

*Note: The technical architecture and automation layers were engineered from scratch. AI tools were utilized to support documentation drafting and architectural review.*
