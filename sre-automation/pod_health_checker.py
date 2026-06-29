from kubernetes import client, config


# connect to EKS using kubeconfig()
config.load_kube_config()

api = client.CoreV1Api()

pods = api.list_pod_for_all_namespaces()

for pod in pods.items:

    namespace = pod.metadata.namespace
    name = pod.metadata.name
    status = pod.status.phase

    print(namespace, name, status)


    if status != "Running":
        print("ALERT: unhealthy pod found")
