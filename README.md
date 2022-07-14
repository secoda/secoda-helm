# secoda-helm

This repository contains the official **Helm 3** chart for installing and configuring
Secoda on Kubernetes, based off the community work of [Dan Quackenbush](https://github.com/danquack). For full documentation on all the ways you can deploy
Secoda on your own infrastructure, please see the [Setup
Guide](https://docs.secoda.co/self-hosted-secoda).

## Prerequisites

* This chart requires **Helm 3.0**.
* A PostgreSQL database.
  * Persistent volumes are not reliable - we strongly recommend that a long-term
  installation of Secoda host the database on an externally managed database (for example, AWS RDS).

## Setup

```bash
kubectl create secret docker-registry secoda-dockerhub --docker-server=https://index.docker.io/v1/ --docker-username=secodaonpremise --docker-password=<CUSTOMER_SPECIFIC_PASSWORD> --docker-email=carter@secoda.co --namespace=<OPTIONAL_NAMESPACE>
```

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
1. Add the Secoda Helm repository:

        $ helm repo add secoda https://secoda.github.io/secoda-helm
        "secoda" has been added to your repositories

2. Ensure you have access to the `secoda` chart:

        $ helm search repo secoda/secoda
        NAME         	CHART VERSION	APP VERSION	DESCRIPTION
        secoda/secoda	4.12.0       	4.1.1      	helm x secoda

3. Run this command `git clone https://github.com/secoda/secoda-helm.git`

4. Modify the `examples/predefined-secrets.yaml` file. Replace all values that have a comment next to them.

- Uncomment `ingress.hosts` and change `ingress.hosts.host` to be the hostname where you will access Secoda.
- If you are implementing TLS for your Secoda instance, uncomment `ingress.tls` and:
    - Specify the name of the SSL certificate to use as the value of `ingress.tls.secretName`.
    - Specify an array containing the hostname where you will access Secoda (the same value you configured for `ingress.hosts.host`).

GKE-specific configurations:

- Specify `/*` as the value of `ingress.hosts.paths.path`.
- Comment out `ingress.tls.servicePort` as it is not required.
- (Optional) Follow SQL Auth Proxy [guide](https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine) and enable `cloudSqlAuthProxy.enabled` and modify `cloudSqlAuthProxy.databaseName`.

5. Now you're all ready to install Secoda:
        $ gcloud container clusters get-credentials <CLUSTER> --region <REGION> # If using GKE
        $ helm repo update
        $ helm install my-secoda secoda/secoda -f predefined-secrets.yaml


## Contributing

```
brew install pre-commit
pre-commit install
asdf install semver latest
```