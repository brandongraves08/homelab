---
trigger: always_on
---

windsurfVersion: 1

rules:
  # ✅ Ensure all ArgoCD applications have valid fields
  - id: argo-application-structure
    description: "ArgoCD Application must have namespace, repoURL, path, and targetRevision"
    match:
      path: "applications/*.yaml"
    assertions:
      - mustHaveKey: "spec.source.repoURL"
      - mustHaveKey: "spec.source.path"
      - mustHaveKey: "spec.source.targetRevision"
      - mustHaveKey: "spec.destination.namespace"

  # ✅ Ensure all Helm values files follow naming convention
  - id: helm-values-naming
    description: "Helm values files must be named <app>-values.yaml"
    match:
      path: "charts/values/*.yaml"
    assertions:
      - pathMatchesRegex: "^charts/values/[a-z0-9-]+-values\\.yaml$"

  # ✅ Warn if Plex chart is missing a claim token
  - id: plex-claim-token-check
    description: "Plex values file must include a claimToken"
    match:
      path: "charts/values/plex-values.yaml"
    assertions:
      - mustHaveKey: "plex.claimToken"

  # ✅ Ensure every Helm chart defines persistence
  - id: helm-persistence-check
    description: "Helm values files must include persistence config"
    match:
      path: "charts/values/*.yaml"
    assertions:
      - mustHaveKey: "persistence.config"
      - mustHaveKey: "persistence.media"

  # ✅ Optional: Warn if Route is missing for exposed apps
  - id: route-exists-for-exposed-apps
    description: "Apps with service.type=NodePort should also have a Route defined"
    match:
      path: "charts/values/*.yaml"
    condition: "contains(service.main.type, 'NodePort')"
    relatedFiles:
      - searchPath: "routes/*.yaml"
    assertions:
      - relatedFileMustExist: true

settings:
  failOnViolation: false
  logLevel: info
