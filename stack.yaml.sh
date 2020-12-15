#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

indent() {
  local indentSize=2
  local indent=1
  if [ -n "$1" ]; then indent=$1; fi
  pr -to $(($indent * $indentSize))
}

IFS=$'\n'
labels=($INPUT_LABELS)

IFS=$','
ports=($INPUT_METRICS_PORTS)

cat <<EOF 
---		
apiVersion: monitoring.coreos.com/v1		
kind: ServiceMonitor		
metadata:		
  name: ${INPUT_NAME}-svc-monitor
  namespace: ${INPUT_NAMESPACE}
  labels:
$(for i in "${labels[@]}"; do echo "$i" | indent 2; done )
spec:
  selector:
    matchLabels:
$(for i in "${labels[@]}"; do echo "$i" | indent 3; done )
  namespaceSelector:
    matchNames:
      - ${INPUT_NAMESPACE}
  endpoints:
$(for i in "${ports[@]}"; do echo - port: ${i%:*} | indent 2; done )
---
apiVersion: v1		
kind: Endpoints		
metadata:		
  name: ${INPUT_NAME}
  namespace: ${INPUT_NAMESPACE}
  labels:
$(for i in "${labels[@]}"; do echo "$i" | indent 2; done )
subsets:		
  - addresses:		
      - ip: ${INPUT_IP_ADDRESS}
    ports:		
$(for i in "${ports[@]}"; do
 echo - name: ${i%:*}| indent 3;
 echo port: ${i##*:}| indent 4;
done )
---		
apiVersion: v1		
kind: Service		
metadata:		
  name: ${INPUT_NAME}
  namespace: ${INPUT_NAMESPACE}
  labels:
$(for i in "${labels[@]}"; do echo "$i" | indent 2; done )
spec:		
  type: ExternalName		
  externalName: ${INPUT_IP_ADDRESS}
  ports:		
$(for i in "${ports[@]}"; do
 echo - name: ${i%:*}| indent 2;
 echo port: ${i##*:}| indent 3;
 echo protocol: TCP | indent 3;
 echo targetPort: ${i##*:}| indent 3;
done )
EOF
