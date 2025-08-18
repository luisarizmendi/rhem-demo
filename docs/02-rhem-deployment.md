# RHEM Deployment Guide

This guide covers deploying Red Hat Edge Manager for the demo environment.

**Requirements:**
- Docker or Podman
- kind (Kubernetes in Docker)  
- Helm 3.x

## Standalone Deployment Steps

Follow the steps in the [Getting Started guide in the Flightctl repo](https://github.com/flightctl/flightctl/blob/main/docs/user/getting-started.md).

Remember to obtain the config.yaml file:


```bash
flightctl login <API_URL> --insecure-skip-tls-verify --web
flightctl certificate request --signer=enrollment --expiration=365d --output=embedded > config.yaml

```

## Demo Environment Notes

**Important:** When presenting, explain that:
- This is a standalone deployment for demo purposes. It uses less resources and you can deploy the latest capabilities in development 
- Production deployments integrate with existing Red Hat platforms

## Next Steps

With RHEM deployed and accessible, proceed to [Demo Preparation](03-demo-preparation.md) to build your demo images and environment.