# secoda-helm

[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/retool)](https://artifacthub.io/packages/search?repo=retool)

This repository contains the official **Helm 3** chart for installing and configuring
Secoda on Kubernetes. For full documentation on all the ways you can deploy
Secoda on your own infrastructure, please see the [Setup
Guide](https://docs.secoda.co/self-hosted-secoda).

## Prerequisites

* This chart requires **Helm 3.0**.
* A PostgreSQL database.
  * Persistent volumes are not reliable - we strongly recommend that a long-term
  installation of Secoda host the database on an externally managed database (for example, AWS RDS).

## Setup

Once your database cluster is created, connect to it and then create the keycloak user and two seperate databases on it.

```bash
psql -h <HOST> -U postgres
```

```bash
create database keycloak;
create database secoda;
create user keycloak with encrypted password 'xxxx';
grant all privileges on database keycloak to keycloak;
grant all privileges on database secoda to keycloak;
```

## Usage
1. Add the Retool Helm repository:

        $ helm repo add retool https://charts.retool.com
        "retool" has been added to your repositories

2. Ensure you have access to the `retool` chart:

        $ helm search repo retool/retool
        NAME         	CHART VERSION	APP VERSION	DESCRIPTION               
        retool/retool	4.0.0        	2.66.2     	A Helm chart for Kubernetes
3. Run this command `git clone https://github.com/tryretool/retool-helm.git`

4. Modify the `values.yaml` file:

* Set values for `config.encryptionKey` and `config.jwtSecret`. They should each be a different long, random string that you keep private. See our docs on [Environment Variables](https://docs.retool.com/docs/environment-variables) for more information on how they are used.

* Set `image.tag` with the version of Retool you want to install (i.e. a version in the format X.Y.Z). See our guide on [Retool Release Versions](https://docs.retool.com/docs/updating-retool-on-premise#retool-release-versions) to see our most recent version.

* Set `config.licenseKey` with your license key.

* To force Retool to send the auth cookies over HTTP, set `config.useInsecureCookies` to `true`. Leave the default value of `false` if you will use https to connect to the instance.

5. Now you're all ready to install Retool:

        $ helm install my-retool retool/retool -f values.yaml

## Additional Configuration

### Externalize database
Modify `values.yaml`:

* Disable the included postgresql chart by setting `postgresql.enabled` to `false`. Then specify your external database through the `config.postgresql.\*` properties at the top of the file.

### gRPC
1. Create a `configMap` of the directory which contains your `proto` files.

        $ kubectl create configmap protos --from-file=<protos-path>

2. Modify `values.yaml`:

        extraVolumeMounts:
          - name: protos
          mountPath: /retool_backend/protos
          readOnly: true

        extraVolumes:
          - name: protos
          configMap:
            name: protos

        env:
          PROTO_DIRECTORY_PATH=/retool_backend/protos

### Ingress
Modify `values.yaml`:

- Uncomment `ingress.hosts` and change `ingress.hosts.host` to be the hostname where you will access Retool.
- If you are implementing TLS for your Retool instance, uncomment `ingress.tls` and:
    - Specify the name of the SSL certificate to use as the value of `ingress.tls.secretName`.
    - Specify an array containing the hostname where you will access Retool (the same value you configured for `ingress.hosts.host`).

GKE-specific configurations:

- Specify `/*` as the value of `ingress.hosts.paths.path`.
- Comment out `ingress.tls.servicePort` as it is not required.

# Chart information

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| annotations | object | `{}` |  |
| datastores.secoda.admin_password | string | `"881f9297e9eec136"` |  |
| datastores.secoda.db_host | string | `"34.122.71.123"` |  |
| datastores.secoda.db_password | string | `"qew7bpe5ytr0HGKcuq"` |  |
| datastores.secoda.existing_secret | string | `""` |  |
| datastores.secoda.private_key | string | `"LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBeGtIVE0zYkhSRk1ZaWYvUzlreUFQTGRIMHdBcGY3aGsrU3lNanY2U1VIdXlmSUlCCnozSWZBcWRONEFxYkVmNXNpOWY4ZHNHaWdsK0o3cVFOdGtzd01LSXlCdmZ5U2Y1RWxEQ2J6djVkNTJGOGxNaysKUGttR1N4QkdibjNncmJsMVRuc3ovcmpjTEJVWUlsUW91VFlEKzY3L3Q5dC9PeDRFR2NRL0ZWZEhpbVZkVjFDcQpuTGlGTU9YOWxVT1MyWW0wRFg5WjhjeGxaQ2w5M3lWNG1QZmxkNFdYakpPQU84Yk15MWVxTDlQK2E3RnBSOWdNCi9nODREMmFCKzNFZ0QvdEJxczZmMTM2RVVDUTZqaWxjK2UrWjdKUDZBOUR0akR0ZFdTK2F1cndLUUNhMUpudDQKQlUrSCthZmp5UEZ0eFZIV1VFNUZuV0pjQUFYYzd1V0szYzgxRndJREFRQUJBb0lCQUdQNjZpRjM4d0czemhZNQoxdyt5Z0xFZDFMREowaVBBdjlzUTVrbHVoQ2JtV3BxRGpab3ArUTJEaGJoSVlPOXdHUmxrOE1LSzRBTlRYdUhrCkJhNDZ1TEN0K3dDY3BhaysreUtvYU1xNGFHNjVNUFJ2a0Y0bEFmNTAxSy8vOXdCbEdJMWRnRmtpckpYbWhXYzYKZmRiNU1JVUtPWmRrc0FNR0hoZElhbSsrdGl0S0U3bTBhdjlCQ1FLVXpuRFFQMk5Qc3JPOUFPbURUTG1JSUxRdApiMmIzN3p4aXF5L2lWemM0VXRIdDNneDdCVW5vdFB2aUlIMjRFalVIdkdKMFJKZUFnSnl2OCt5YVFoZ2hza2hJCkVqdDhZRmtvcm4wVzZwbldVN0E5QUFnTXpOcllBL1BjWXYyQkRoZk8yMjNZL0ZHR2pTMC9wTkRjbnRwRXl0SVUKOW16eklBRUNnWUVBNTdwN0tNZGxIYnZEYkgzdFV3aUVTcXhSYzk5N2RhNGdLZE1sNGtlNzM4OVJLL0hiNE51WApPUG0rQnI2NDh3MUFGdGp5YkkrZkM5cERMOHZGUjhGb09rU1RzdmtsOUJzRGNHMklJZXRacGw4TXJEWGJlYjRWCk9PZ2lxd2IveGZRQm5sc2pDN1J3NHM5S0UxSGZKNU15VEFxTVV0VTd0Nk5nNDFWVW1iYXliUmNDZ1lFQTJ3WFoKMnRuZFZ3b1N6Y1puTGh6b0RnZVA3TTV5Q2szSlRLTzFFMUVKeCsrTGNMNUtNa0Y0Szg0L3BiOVVrUm4wT0VOZgpTNkdTWlBYbXdNdWEvMVVPandVUDNvRGlHOGpYeGlscExZVkxOSTg5ZVNyaDYzVUlubThudkI5RnI3d29rWWt0CmhTSm82VnBxRHdQYlJ3ZEVPQTlJVXB3RS93OE1vd3FFaDN3V2VBRUNnWUVBcjNEK1ljZGxCUGZ0WXl5TUM3dDgKL1ZRdGJ2OGFaK1JuTVlOTlFWNXlIV2JHMi9DSE9sekd4em85NXJscktZazBwcGVtSXc4eHFUV2NmSWxZV1pWUwpwaHJaZ0QwbHdRVGF1N29Sd1N5QWVYZXBEcERRRkFJWDZ6ZkZWNXM2OXRKZ2oxWU0ySVhLbWMyN0ZabDh6R2VqClF2TVJmbjAyY3poYzJJRDRSbENPRWcwQ2dZQjNHZWxyM3dsRDZaQnNJYlcrRjY0QTR3L2E0RENYZGRFL1FjNlgKNEh1SEk3WVo2d0NCNzZRZmZocVNVVWIxV0wyN1VyZWhjdzBlcGJHRHFiUnhvSms0SUxLT2RsdCtiR3Nac1M4bQp0OU03azZFRUlOT1ZyS0N4TnhUT2NkcjlRejUwVmJwUktYTVBZa0ZHUlB5YTFWSzlnV0g4dWlibFpCT2xIWFVRCkQrUlFBUUtCZ1FDVC8yUmV1RGNpWDlkWG4wN2d1dU9UZ25PTUhMQUJUQ0J3V0RBNjZQdVFkYWtYMjZxM3NWNmYKV0I5enlpMUkwQUpRdFJOeWhIYzhWRUdRanhHZXk3MXNrOGl3bm9xK0tWeW5OenpFOEpRNUxXb0hMOFU2ZTlmbwpOSFdVazZxbXpYZnZSTUt3NW9mbHUzejBKTlRnRExiMnkzc1FkT2toei84QlorSjk4aWs1Rnc9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo="` |  |
| datastores.secoda.public_key | string | `"LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF4a0hUTTNiSFJGTVlpZi9TOWt5QQpQTGRIMHdBcGY3aGsrU3lNanY2U1VIdXlmSUlCejNJZkFxZE40QXFiRWY1c2k5Zjhkc0dpZ2wrSjdxUU50a3N3Ck1LSXlCdmZ5U2Y1RWxEQ2J6djVkNTJGOGxNaytQa21HU3hCR2JuM2dyYmwxVG5zei9yamNMQlVZSWxRb3VUWUQKKzY3L3Q5dC9PeDRFR2NRL0ZWZEhpbVZkVjFDcW5MaUZNT1g5bFVPUzJZbTBEWDlaOGN4bFpDbDkzeVY0bVBmbApkNFdYakpPQU84Yk15MWVxTDlQK2E3RnBSOWdNL2c4NEQyYUIrM0VnRC90QnFzNmYxMzZFVUNRNmppbGMrZStaCjdKUDZBOUR0akR0ZFdTK2F1cndLUUNhMUpudDRCVStIK2FmanlQRnR4VkhXVUU1Rm5XSmNBQVhjN3VXSzNjODEKRndJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tCg=="` |  |
| datastores.secoda.secret_key | string | `"73c6c359-6832-49c0-bd2e-cd156be4e059"` |  |
| dnsConfig | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| global.env | list | `[]` |  |
| global.image.pullPolicy | string | `"IfNotPresent"` |  |
| global.image.registry | string | `"secoda"` |  |
| global.image.tag | string | `"4"` |  |
| global.resources | object | `{}` |  |
| global.securityContext | object | `{}` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.enabled | bool | `false` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| services.api.args[0] | string | `"-c"` |  |
| services.api.args[1] | string | `"./server.sh"` |  |
| services.api.command[0] | string | `"/bin/sh"` |  |
| services.api.env | list | `[]` |  |
| services.api.image.name | string | `"on-premise-api"` |  |
| services.api.image.pullPolicy | string | `""` |  |
| services.api.image.registry | string | `""` |  |
| services.api.image.tag | string | `""` |  |
| services.api.ports[0].containerPort | int | `5007` |  |
| services.api.readinessProbe.tcpSocket.port | int | `5007` |  |
| services.api.resources.limits.cpu | string | `"1024m"` |  |
| services.api.resources.limits.memory | string | `"2048Mi"` |  |
| services.api.resources.requests.cpu | string | `"1024m"` |  |
| services.api.resources.requests.memory | string | `"2048Mi"` |  |
| services.api.securityContext | object | `{}` |  |
| services.auth.args[0] | string | `"start --auto-build --http-relative-path /auth --hostname-strict false --proxy edge --spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true --import-realm"` |  |
| services.auth.env[0].name | string | `"KC_DB_USERNAME"` |  |
| services.auth.env[0].value | string | `"postgres"` |  |
| services.auth.env[1].name | string | `"KC_DB"` |  |
| services.auth.env[1].value | string | `"postgres"` |  |
| services.auth.env[2].name | string | `"KEYCLOAK_ADMIN"` |  |
| services.auth.env[2].value | string | `"admin"` |  |
| services.auth.image.name | string | `"on-premise-auth"` |  |
| services.auth.image.pullPolicy | string | `""` |  |
| services.auth.image.registry | string | `""` |  |
| services.auth.image.tag | string | `""` |  |
| services.auth.livenessProbe | object | `{}` |  |
| services.auth.ports[0].containerPort | int | `8080` |  |
| services.auth.ports[1].containerPort | int | `8443` |  |
| services.auth.readinessProbe.httpGet.path | string | `"/auth/realms/secoda/.well-known/openid-configuration"` |  |
| services.auth.readinessProbe.httpGet.port | int | `8080` |  |
| services.auth.readinessProbe.initialDelaySeconds | int | `90` |  |
| services.auth.readinessProbe.periodSeconds | int | `10` |  |
| services.auth.readinessProbe.timeoutSeconds | int | `5` |  |
| services.auth.resources.limits.cpu | string | `"512m"` |  |
| services.auth.resources.limits.memory | string | `"3072Mi"` |  |
| services.auth.resources.requests.cpu | string | `"512m"` |  |
| services.auth.resources.requests.memory | string | `"2048Mi"` |  |
| services.auth.securityContext | object | `{}` |  |
| services.frontend.args | list | `[]` |  |
| services.frontend.env | list | `[]` |  |
| services.frontend.image.name | string | `"on-premise-frontend"` |  |
| services.frontend.image.pullPolicy | string | `""` |  |
| services.frontend.image.registry | string | `""` |  |
| services.frontend.image.tag | string | `""` |  |
| services.frontend.livenessProbe.initialDelaySeconds | int | `30` |  |
| services.frontend.livenessProbe.tcpSocket.port | int | `443` |  |
| services.frontend.livenessProbe.timeoutSeconds | int | `5` |  |
| services.frontend.ports[0].containerPort | int | `443` |  |
| services.frontend.ports[0].name | string | `"https"` |  |
| services.frontend.readinessProbe | object | `{}` |  |
| services.frontend.resources.requests.cpu | string | `"512m"` |  |
| services.frontend.resources.requests.memory | string | `"1024m"` |  |
| services.frontend.securityContext | object | `{}` |  |
| services.redis.command[0] | string | `"redis-server"` |  |
| services.redis.env | list | `[]` |  |
| services.redis.image.name | string | `"redis"` |  |
| services.redis.image.pullPolicy | string | `""` |  |
| services.redis.image.registry | string | `""` |  |
| services.redis.image.tag | string | `"6.2"` |  |
| services.redis.livenessProbe | object | `{}` |  |
| services.redis.ports[0].containerPort | int | `6379` |  |
| services.redis.readinessProbe.tcpSocket.port | int | `6379` |  |
| services.redis.resources.limits.cpu | string | `"512m"` |  |
| services.redis.resources.limits.memory | string | `"1024Mi"` |  |
| services.redis.resources.requests.cpu | string | `"512m"` |  |
| services.redis.resources.requests.memory | string | `"1024Mi"` |  |
| services.redis.securityContext | object | `{}` |  |
| services.worker.args[0] | string | `"-c"` |  |
| services.worker.args[1] | string | `"./worker.sh"` |  |
| services.worker.command[0] | string | `"/bin/sh"` |  |
| services.worker.env | list | `[]` |  |
| services.worker.image.name | string | `"on-premise-api"` |  |
| services.worker.image.pullPolicy | string | `""` |  |
| services.worker.image.registry | string | `""` |  |
| services.worker.image.tag | string | `""` |  |
| services.worker.ports[0].containerPort | int | `5007` |  |
| services.worker.readinessProbe.tcpSocket.port | int | `5007` |  |
| services.worker.resources.limits.cpu | string | `"2048m"` |  |
| services.worker.resources.limits.memory | string | `"4096Mi"` |  |
| services.worker.resources.requests.cpu | string | `"1024m"` |  |
| services.worker.resources.requests.memory | string | `"2048Mi"` |  |
| services.worker.securityContext | object | `{}` |  |
| tolerations | list | `[]` |  |

