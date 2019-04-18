#!/bin/bash
set -euo pipefail

. utils.sh

announce "Storing Conjur cert for test app configuration."

set_namespace $CONJUR_NAMESPACE_NAME

echo "Retrieving Conjur certificate."

export cli_pod_name="$( kubectl get pods --selector app=conjur-cli --no-headers | awk '{ print $1 }' )"
kubectl cp $cli_pod_name:/root/conjur-quickstart.pem \ssl-certificate

set_namespace $TEST_APP_NAMESPACE_NAME

echo "Storing non-secret conjur cert as test app configuration data"

$cli delete --ignore-not-found=true configmap $TEST_APP_NAMESPACE_NAME

# Store the Conjur cert in a ConfigMap.
$cli create configmap $TEST_APP_NAMESPACE_NAME --from-file=./ssl-certificate

echo "Conjur cert stored."
