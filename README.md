# DevOps Project

A small Flask web app used to practice the full DevOps flow: tests, Docker, a CI/CD pipeline and deployment with Terraform.

![CI](https://github.com/Habiba-Ijaz/devops-project/actions/workflows/ci.yml/badge.svg)

## What it does

- `GET /` returns a JSON greeting
- `GET /health` returns `{"status": "healthy"}` (used for health checks)

## Tech used

- Python and Flask
- pytest
- Docker
- GitHub Actions (CI/CD)
- Docker Hub
- Terraform and AWS EC2

## How the pipeline works

```
git push  ->  test  ->  build + /health check  ->  publish image to Docker Hub
```

- `test` runs pytest
- `build` builds the Docker image, runs it and checks `/health`
- `publish` pushes the image to Docker Hub, only on pushes to `main` (skipped on pull requests)

## Run it locally

```
pip install -r requirements.txt pytest
python -m pytest
python app.py
```

With Docker:

```
docker build -t devops-project .
docker run -p 5000:5000 devops-project
```

Then open http://localhost:5000

## Deploy to AWS with Terraform

The `terraform/` folder creates a security group and an EC2 instance that installs Docker and runs the published image.

```
cd terraform
terraform init
terraform plan
terraform apply
terraform destroy   # always clean up afterwards
```

Needs AWS credentials configured on your machine. This creates real AWS resources, so destroy them when you are done.

## What I learned

How the pieces of a DevOps workflow fit together: automated tests, containers, a pipeline that only publishes tested code, and infrastructure described as code.
