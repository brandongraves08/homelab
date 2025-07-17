# Homelab on OpenShift

This repository contains **GitOps-managed** manifests for my self-hosted media homelab running on an OpenShift cluster.

## Components
| Category | Stack | Source Path |
|----------|-------|-------------|
| Media | Jellyfin, Radarr, Sonarr | `openshift/argocd/apps/` |
| Storage | Synology NFS (`nfs-storage` SC) | `openshift/base/pvcs.yaml` |
| GitOps | Red Hat OpenShift GitOps (Argo CD) | operator subscription (manual) |
| Monitoring | User-workload monitoring, Grafana dashboards | `openshift/extras/monitoring` |
| Logging | Loki stack | `openshift/extras/apps/loki.yaml` |
| TLS | cert-manager (self-signed / future ACME) | `openshift/extras/apps/cert-manager.yaml` |
| Backups | Velero (PVC configs) | `openshift/extras/apps/velero.yaml` |
| DNS | **CoreDNS** internal zone `homelab.lan` → ingress | `openshift/extras/coredns/` |
| Quotas | ResourceQuota & LimitRange | `openshift/extras/quotas/` |

## Network & DNS
* Base domain: `homelab.lan` (private).
* CoreDNS rewrites `*.homelab.lan` to the OpenShift ingress wildcard (`*.apps.$CLUSTER_DOMAIN`).
* Unknown queries forward to home router `192.168.2.1`.
* Service node ports: UDP 53 → 30553, TCP 53 → 30554. Point LAN DHCP DNS to any cluster node IP.

## Bootstrap sequence
1. **homelab-base** – applies namespace & PVCs (Argo CD Application).
2. **openshift/argocd** – deploys media apps.
3. **homelab-extras** – deploys monitoring, cert-manager, Loki, Velero, CoreDNS, quotas.

## Usage
```bash
# Access Argo CD UI
oc get route openshift-gitops-server -n openshift-gitops

# Default app URLs (internal only)
https://jellyfin.homelab.lan
https://radarr.homelab.lan
https://sonarr.homelab.lan
```

See individual directories for detailed configuration.
