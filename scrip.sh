#create GPU node pool
gcloud container clusters create gpu-gke \
  --accelerator type=nvidia-tesla-v100,count=3 \
  --zone us-central1-c

#install Nvidia GPU driver
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml

#create new deployment
kubectl apply -f predict-job.yaml

#expose service
kubectl expose deployment predict --type=LoadBalancer --name=predict-service

#check service external IP address
kubectl get svc predict-service

#configure horizontal pod scaling
kubectl apply -f predict-hpa.yaml

#check hpa status
kubectl get hpa

#test the service
curl -X POST -F file=@"/absolute_path/92E141F8-36E4-4331-BB2EE42AC8674DD3_source.jpg" http://external_ip:5000/predict