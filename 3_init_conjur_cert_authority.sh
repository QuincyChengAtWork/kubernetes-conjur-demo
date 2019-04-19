#!/bin/bash
set -euo pipefail

. utils.sh

announce "Initializing Conjur certificate authority."

set_namespace $CONJUR_NAMESPACE_NAME 

$cli cp ./initCA.sh $POD_NAME:/root

$cli exec $POD_NAME -- /root/initCA.sh $AUTHENTICATOR_ID $CONJUR_ACCOUNT

echo "Certificate authority initialized."
