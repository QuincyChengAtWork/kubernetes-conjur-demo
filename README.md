# kubernetes-conjur-demo

This repo demonstrates an app retrieving secrets from a Conjur cluster running
in Kubernetes or OpenShift. The numbered scripts perform the same steps that a
user has to go through when setting up their own applications.

**Note:** These demo scripts is customized for Conjur OSS for Minikube on Katacoda

More details at https://katacoda.com/quincycheng/conjur-oss-on-minikube


## Demo Applications
The test app is based on the `cyberark/demo-app` Docker image
([GitHub repo](https://github.com/conjurdemos/pet-store-demo)). It is deployed
with a PostgreSQL database and the DB credentials are stored in Conjur.
The app uses Summon at runtime to retrieve the credentials it needs to connect
with the DB, and it authenticates to Conjur using the access token provided by
the authenticator sidecar.

There are three iterations of this app that are deployed:
- App with sidecar authenticator client (to provide continuously refreshed Conjur access tokens)
- App with init container authenticator client (to provide a one-time Conjur access token on start)
- Secretless app with [Secretless Broker](https://github.com/cyberark/secretless-broker)
  deployed as a sidecar, managing the credential retrieval / injection for the app

