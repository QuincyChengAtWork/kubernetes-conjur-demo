#!/bin/bash
set -euo pipefail

. utils.sh

announce "Initializing Conjur certificate authority."

set_namespace $CONJUR_NAMESPACE_NAME 

chmod +x ./initCA.sh

$cli cp ./initCA.sh $$cli_pod_name:/root

$cli exec $$cli_pod_name -- /root/initCA.sh $AUTHENTICATOR_ID $CONJUR_ACCOUNT

echo "Certificate authority initialized."
