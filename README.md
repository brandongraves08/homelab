# 📦 Homelab GitOps Deployment with OpenShift + ArgoCD

Welcome to the Homelab GitOps repository! This project defines and manages a modern self-hosted media environment deployed on **Red Hat OpenShift** using **ArgoCD** for GitOps, and **Helm charts from TrueCharts** for application delivery.

---

## 🏗️ Lab Overview

This homelab consists of:

| Component       | Description                                      |
|----------------|--------------------------------------------------|
| **OpenShift**   | Cluster platform (running on Proxmox VMs)        |
| **ArgoCD**      | GitOps controller for declarative app delivery   |
| **TrueCharts**  | OCI-based Helm charts for homelab apps           |
| **Apps**        | Plex, Radarr, Sonarr, Sabnzbd, Overseerr         |
| **Storage**     | Backed by NFS or hostPath PVCs                   |
| **Git Source**  | This repo serves as the source of truth          |

---

## 📂 Current Repo Structure

```
.
├── README.md
├── applications/           # ArgoCD Application definitions
│   ├── plex.yaml
│   ├── radarr.yaml
│   ├── sonarr.yaml
│   ├── sabnzbd.yaml
│   ├── root-app.yaml     # Parent app that manages all apps
│   └── routes-app.yaml    # Application to manage routes
├── charts/
│   └── values/           # Helm values for each application
│       ├── plex-values.yaml
│       ├── radarr-values.yaml
│       ├── sonarr-values.yaml
│       └── sabnzbd-values.yaml
├── homelab-config/
│   └── openshift/        # OpenShift cluster configuration
│       ├── client-ca.crt
│       └── kubeconfig
├── routes/               # OpenShift Route definitions
│   ├── plex.yaml
│   ├── radarr.yaml
│   ├── sonarr.yaml
│   └── sabnzbd.yaml
├── scripts/              # Utility scripts
│   ├── validate.sh      # Linux validation script
│   └── validate.ps1     # Windows validation script
├── storage/              # PVC definitions
│   └── pvc.yaml
├── .gitignore            # Excludes sensitive files
├── argocd.yaml           # ArgoCD instance definition
├── credentials.md        # EXCLUDED FROM GIT - Local credentials
└── windsurf.yaml         # Validation rules
```

```
.
├── applications/
│   ├── plex.yaml
│   ├── radarr.yaml
│   ├── sonarr.yaml
│   └── sabnzbd.yaml
├── charts/
│   └── values/
│       ├── plex-values.yaml
│       ├── radarr-values.yaml
│       └── sonarr-values.yaml
├── storage/
│   └── pvc.yaml
├── homelab-config/
│   └── openshift/
│       ├── client-ca.crt
│       └── kubeconfig
└── README.md
```

- **`applications/`**: ArgoCD `Application` CRs, one per app  
- **`charts/values/`**: Helm values files for TrueCharts apps  
- **`storage/`**: PVC definitions for config/media volumes  

---

## 🚀 GitOps Deployment Flow

1. OpenShift cluster is running on Proxmox with 3 nodes.
2. ArgoCD is installed via OperatorHub in the `media` namespace.
3. ArgoCD watches this repo for applications and values.
4. Changes are committed to GitHub repository.
5. ArgoCD detects changes and can sync applications manually or automatically.
6. Each app is deployed from **TrueCharts' OCI Helm registry**.
7. Persistent storage is mapped via PVCs in the `media` namespace.
8. Networking is exposed via OpenShift Routes.

---

## 🔁 Planned Applications

| App       | Chart Source (OCI)                        | Helm Values Path                    |
|-----------|-------------------------------------------|-------------------------------------|
| Plex      | `oci://tccr.io/truecharts/plex`           | `charts/values/plex-values.yaml`   |
| Radarr    | `oci://tccr.io/truecharts/radarr`         | `charts/values/radarr-values.yaml` |
| Sonarr    | `oci://tccr.io/truecharts/sonarr`         | `charts/values/sonarr-values.yaml` |
| Sabnzbd   | `oci://tccr.io/truecharts/sabnzbd`        | `charts/values/sabnzbd-values.yaml`|

---

## ⚙️ Planned OpenShift Configuration

- PVCs created for `/config` and `/data` per app
- Optional SCC bindings or `anyuid` usage for media apps
- Routes or NodePorts used to expose web interfaces

---

## 💡 Windsurf Rule Ideas

For Windsurf repo validation, consider rules such as:

- `Ensure all ArgoCD applications point to HEAD or a semver tag`
- `All charts must use persistent volumes`
- `Warn if claimToken is not set for Plex`
- `Validate Helm value files are named <app>-values.yaml`
- `Ensure Route definitions exist for exposed services`

---

## 📬 Contributions

This project is intended for personal/homelab use. PRs welcome if they improve automation or compatibility for similar setups.

---

## 🔄 GitOps Workflow Usage

### Initial Setup

1. Clone this repository to your local machine
2. Push to your GitHub repository (public or private)
3. Ensure ArgoCD has access to the repository
4. Apply the root application to start syncing:
   ```bash
   oc apply -f applications/root-app.yaml
   ```
5. Log in to ArgoCD UI to monitor deployments

### Making Changes

1. Make changes to the appropriate files locally
2. Run validation script to ensure compliance:
   ```bash
   # Linux/Mac
   ./scripts/validate.sh
   
   # Windows
   .\scripts\validate.ps1
   ```
3. Commit and push changes to GitHub
4. Sync applications in ArgoCD UI (or configure auto-sync)

### Accessing Services

All services are exposed via OpenShift Routes. Access URLs can be found in the ArgoCD UI or by running:
```bash
oc get routes -n media
```

## 🧪 Coming Soon

- Monitoring with Prometheus/Grafana
- Automatic Helm chart update detection with Renovate
- Backup integration with Velero or Restic

---

## 📎 License

MIT License