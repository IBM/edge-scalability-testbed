#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
#set -x

SCRIPT_DIR=$(realpath $(dirname "${BASH_SOURCE[0]}"))
export EASYRSA_PKI="$SCRIPT_DIR"/pki/ca
MASTER_IP=192.168.1.1

# Generate server certificate and key. 
# usually the first IP from the service CIDR that is specified as the --service-cluster-ip-range argument for both the API server and the controller manager component.
MASTER_CLUSTER_IP=$MASTER_IP

easyrsa --subject-alt-name="IP:${MASTER_IP},"\
"IP:${MASTER_CLUSTER_IP},"\
"IP:127.0.0.1,"\
"DNS:localhost,"\
"DNS:kubernetes,"\
"DNS:kubernetes.default,"\
"DNS:kubernetes.default.svc,"\
"DNS:kubernetes.default.svc.cluster,"\
"DNS:kubernetes.default.svc.cluster.local,"\
"DNS:limani-deviceserver,"\
"DNS:limani-deviceserver.limani-system,"\
"DNS:limani-deviceserver.limani-system.svc,"\
"DNS:limani-deviceserver.limani-system.svc.cluster,"\
"DNS:limani-deviceserver.limani-system.svc.cluster.local,"\
"DNS:placeholder.awsglobalaccelerator.com" \
--days=10000 \
build-server-full server nopass

echo "start the server with"
echo "--client-ca-file="$EASYRSA_PKI"/ca.crt"
echo "--tls-cert-file="$EASYRSA_PKI"/issued/server.crt"
echo "--tls-private-key-file="$EASYRSA_PKI"/private/server.key"