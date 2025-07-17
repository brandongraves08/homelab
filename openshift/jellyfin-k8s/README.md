# Jellyfin for Kubernetes/OpenShift

This repository contains Kubernetes manifests for deploying Jellyfin on OpenShift.

## Components

- **Deployment**: Runs the Jellyfin container with appropriate resource limits
- **Service**: Exposes Jellyfin on port 8096
- **PersistentVolumeClaims**: 
  - `jellyfin-config`: Stores Jellyfin configuration (1Gi)
  - `jellyfin-media`: Stores media files (10Gi)
- **Route**: Exposes Jellyfin externally via OpenShift Route

## Deployment

These manifests are intended to be deployed using ArgoCD with the following application definition:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: jellyfin
  namespace: openshift-gitops
spec:
  destination:
    namespace: media
    server: https://kubernetes.default.svc
  project: default
  source:
    repoURL: https://github.com/brandongraves08/jellyfin-k8s.git
    targetRevision: main
    path: manifests
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

## Configuration

The Jellyfin deployment uses the following configuration:
- Image: `jellyfin/jellyfin:10.8.10`
- Storage: Uses the `nfs-storage` storage class
- Exposed via OpenShift Route at: `jellyfin.apps.openshift.thelab.lan`
