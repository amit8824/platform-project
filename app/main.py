from fastapi import FastAPI
from prometheus_client import Counter, generate_latest
from fastapi.responses import Response
import socket


app = FastAPI()


REQUEST_COUNT = Counter(
    "platform_requests_total",
    "Total API Requests"
)


@app.get("/")
def home():

    REQUEST_COUNT.inc()

    return {
        "service": "platform-api",
        "status": "running",
        "version": "v5"
    }


@app.get("/health")
def health():

    return {
        "status": "healthy"
    }


@app.get("/hostname")
def hostname():

    return {
        "pod": socket.gethostname()
    }


@app.get("/metrics")
def metrics():

    return Response(
        generate_latest(),
        media_type="text/plain"
    )