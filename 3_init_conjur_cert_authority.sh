#!/bin/bash
set -euo pipefail

. utils.sh

announce "Initializing Conjur certificate authority."

set_namespace $CONJUR_NAMESPACE_NAME 

$cli exec $POD_NAME -- export AUTHENTICATOR_ID=$AUTHENTICATOR_ID
$cli exec $POD_NAME -- export CONJUR_ACCOUNT=$CONJUR_ACCOUNT

$cli exec $POD_NAME -- cat >>/root/initCA.sh<<EOF
#!/bin/bash
set -e
#AUTHENTICATOR_ID='<AUTHENTICATOR_ID>'
#CONJUR_ACCOUNT='<CONJUR_ACCOUNT>'

openssl genrsa -out ca.key 2048

CONFIG="
[ req ]
distinguished_name = dn
x509_extensions = v3_ca
[ dn ]
[ v3_ca ]
basicConstraints = critical,CA:TRUE
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
"

# Generate root CA certificate
openssl req -x509 -new -nodes -key ca.key -sha1 -days 3650 -set_serial 0x0 -out ca.cert \
  -subj "/CN=conjur.authn-k8s.$AUTHENTICATOR_ID/OU=Conjur Kubernetes CA/O=$CONJUR_ACCOUNT" \
  -config <(echo "$CONFIG")

# Verify cert
openssl x509 -in ca.cert -text -noout

# Load variable values
conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/ca/key "$(cat ca.key)"
conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/ca/cert "$(cat ca.cert)"
EOF

$cli exec $POD_NAME -- /root/initCA.sh

echo "Certificate authority initialized."
