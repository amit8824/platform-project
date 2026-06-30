from kubernetes import client, config
from common.logger import logger

def connect():
    config.load_kube_config()
    logger.info("Connected to Kubernetes")

if __name__ == "__main__":
    connect()