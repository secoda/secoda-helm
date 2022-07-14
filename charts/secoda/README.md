# secoda

![Version: 4.33.0](https://img.shields.io/badge/Version-4.33.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.10.5](https://img.shields.io/badge/AppVersion-4.10.5-informational?style=flat-square)

Kubernetes Helm chart for Secoda

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| annotations | object | `{}` |  |
| dnsConfig | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| global.env | list | `[]` |  |
| global.image.pullPolicy | string | `"IfNotPresent"` |  |
| global.image.registry | string | `"secoda"` |  |
| global.image.tag | string | `"4"` |  |
| global.resources | object | `{}` |  |
| global.securityContext | object | `{}` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.enabled | bool | `false` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| service.type | string | `"NodePort"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| services.api.args | list | `[]` |  |
| services.api.command | list | `[]` |  |
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
| services.frontend.ports[1].containerPort | int | `80` |  |
| services.frontend.ports[1].name | string | `"http"` |  |
| services.frontend.readinessProbe | object | `{}` |  |
| services.frontend.resources.requests.cpu | string | `"512m"` |  |
| services.frontend.resources.requests.memory | string | `"1024m"` |  |
| services.frontend.securityContext | object | `{}` |  |
| services.redis.command[0] | string | `"redis-server"` |  |
| services.redis.env | list | `[]` |  |
| services.redis.image.name | string | `"redis"` |  |
| services.redis.image.pullPolicy | string | `""` |  |
| services.redis.image.registry | string | `"docker.io"` |  |
| services.redis.image.tag | string | `"6.2"` |  |
| services.redis.livenessProbe | object | `{}` |  |
| services.redis.ports[0].containerPort | int | `6379` |  |
| services.redis.readinessProbe.tcpSocket.port | int | `6379` |  |
| services.redis.resources.limits.cpu | string | `"512m"` |  |
| services.redis.resources.limits.memory | string | `"1024Mi"` |  |
| services.redis.resources.requests.cpu | string | `"512m"` |  |
| services.redis.resources.requests.memory | string | `"1024Mi"` |  |
| services.redis.securityContext | object | `{}` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
