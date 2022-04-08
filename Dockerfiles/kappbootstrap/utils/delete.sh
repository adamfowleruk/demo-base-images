#!/bin/sh
kubectl delete -f install-job.yaml

kubectl delete clusterrolebinding/kapp-controller-cluster-role-binding clusterrole/kapp-controller-cluster-role
kubectl delete apiservice/v1alpha1.data.packaging.carvel.dev
kubectl delete crd apps.kappctrl.k14s.io internalpackagemetadatas.internal.packaging.carvel.dev internalpackages.internal.packaging.carvel.dev packageinstalls.packaging.carvel.dev packagerepositories.packaging.carvel.dev
kubectl delete clusterrolebinding/pkg-apiserver:system:auth-delegator
kubectl delete -n kube-system rolebinding/pkgserver-auth-reader
kubectl delete apiservice/v1alpha1.data.packaging.carvel.dev

kubectl delete ns tanzu-cluster-essentials tanzu-package-repo-global kapp-controller

#kubectl replace --raw "/api/v1/namespaces/tanzu-package-repo-global/finalize" -f ./tprg.json
#kubectl replace --raw "/api/v1/namespaces/kapp-controller/finalize" -f ./kc.json
#kubectl replace --raw "/api/v1/namespaces/tanzu-cluster-essentials/finalize" -f ./tce.json
