#!/bin/bash

NAMESPACE="sre"
DEPLOYMENT="swype-app"
MAX_RESTARTS_ALLOWED=3

echo "$NAMESPACE ($DEPLOYMENT) : Monitoring pod to check that restarts if any is not more than $MAX_RESTARTS_ALLOWED ..."
while true
do
  CURRENT_RESTART_COUNT=$(kubectl get pod -l app=${DEPLOYMENT} -n ${NAMESPACE} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")
  echo "CURRENT_RESTART_COUNT= $CURRENT_RESTART_COUNT"
  if [[ $CURRENT_RESTART_COUNT -gt $MAX_RESTARTS_ALLOWED ]]
  then
    echo "Maximum restarts exceeded for this pod. Now scaling down the replicas for this pod in the deployment resource to 0"
    kubectl scale --replicas=0 deployment/${DEPLOYMENT} -n ${NAMESPACE}
    break
  fi
  sleep 60
done
