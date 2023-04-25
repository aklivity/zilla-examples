#!/bin/bash
BOLD='\033[1;97m'
END='\033[0m'

echo -e "${BOLD}The status of horizontal pod autoscaling${END}"
echo -e "${BOLD}----------------------------------------${END}\n"

echo -e "${BOLD}HorizontalPodAutoscaler:${END}"
kubectl get hpa --namespace zilla-autoscaling
echo

echo -e "${BOLD}Deployment:${END}"
kubectl get deployment zilla --namespace zilla-autoscaling
echo

echo -e "${BOLD}Pods:${END}"
kubectl get pods --namespace zilla-autoscaling --selector app.kubernetes.io/instance=zilla