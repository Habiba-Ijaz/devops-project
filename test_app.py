from app import app


def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.get_json()["status"] == "ok"


def test_health():
    client = app.test_client()
    response = client.get("/health")
    assert response.get_json()["status"] == "healthy"


def test_metrics():
    client = app.test_client()
    client.get("/")
    response = client.get("/metrics")
    assert b"app_requests_total" in response.data


def test_greeting_from_env(monkeypatch):
    monkeypatch.setenv("GREETING", "Salam")
    client = app.test_client()
    assert client.get("/").get_json()["message"] == "Salam"
