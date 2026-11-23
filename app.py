from flask import Flask, jsonify, request, Response
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

REQUESTS = Counter("app_requests_total", "Total requests", ["path"])


@app.after_request
def count_request(response):
    if request.path != "/metrics":
        REQUESTS.labels(path=request.path).inc()
    return response


@app.route("/")
def home():
    return jsonify(message="Hello from my DevOps project", status="ok")


@app.route("/health")
def health():
    return jsonify(status="healthy")


@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
