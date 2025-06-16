# OpenShift Homelab Manifests

This directory contains all Kubernetes/OpenShift resources managed by Argo CD for the homelab cluster.

Layout:

- `base/` – common namespace, storage and other baseline resources.
- `argocd/` – Argo CD AppProject and Application definitions.
- `extras/` – future monitoring, certificates, external-dns, backup, logging, etc.

All manifests are applied via GitOps; commit changes and Argo CD will keep the cluster in sync.
