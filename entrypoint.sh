#!/bin/bash
echo "${INPUT_KUBECONFIG}" > /kubeconfig
export KUBECONFIG=/kubeconfig
export AWS_ACCESS_KEY_ID="$INPUT_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$INPUT_AWS_SECRET_ACCESS_KEY"

action=${INPUT_ACTION:-apply}
bash /stack.yaml.sh | kubectl $action -f -

