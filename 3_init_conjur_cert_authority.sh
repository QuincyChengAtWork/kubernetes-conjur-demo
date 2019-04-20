#!/bin/bash
set -euo pipefail

. utils.sh

announce "Initializing Conjur certificate authority."

set_namespace $CONJUR_NAMESPACE_NAME 

$cli cp --namespace $CONJUR_NAMESPACE $POD_NAME:/opt/conjur/etc/ssl/ca/ca.key .
$cli cp --namespace $CONJUR_NAMESPACE $POD_NAME:/opt/conjur/etc/ssl/ca/ca.cert .
#$cli cp ./ca.key $cli_pod_name:/root/ca.key
#$cli cp ./ca.crt $cli_pod_name:/root/ca.crt

$cli exec -it --namespace $CONJUR_NAMESPACE $cli_pod_name -- conjur authn login -u admin -p $CONJUR_ADMIN_PASSWORD
$cli exec -it --namespace $CONJUR_NAMESPACE $cli_pod_name -- conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/ca/key "$(cat /root/ca.key)"
$cli exec -it --namespace $CONJUR_NAMESPACE $cli_pod_name -- conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/ca/cert "$(cat /root/ca.cert)"

#chmod +x ./initCA.sh
#$cli cp ./initCA.sh $cli_pod_name:/root
#$cli exec -it $cli_pod_name -- conjur authn login -u admin -p $CONJUR_ADMIN_PASSWORD
#$cli exec $cli_pod_name -- /root/initCA.sh $AUTHENTICATOR_ID $CONJUR_ACCOUNT

echo "Certificate authority initialized."
