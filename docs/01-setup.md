# Setup Guide

This guide walks through the initial setup required for the RHEM demo environment.

## Prerequisites

- GitHub account with repository access
- Red Hat subscription credentials
- Local development environment with:
  - Git
  - FlightCtl CLI
  - Virtualization software (KVM, VirtualBox, or VMware)
  - 4GB+ available RAM

## Repository Configuration

### 1. Fork and Clone Repository

```bash
git clone https://github.com/luisarizmendi/rhem-demo
cd rhem-demo
```

### 2. Enable GitHub Actions Permissions

Navigate to **Repository Settings** → **Actions** → **General**:

1. Under **Workflow permissions**, select:
   - ✅ **Read repository contents and packages permissions**
2. Click **Save**

### 3. Configure Red Hat Registry Credentials

Add your Red Hat credentials as repository secrets:

1. Go to **Repository Settings** → **Secrets and variables** → **Actions**
2. Add these **Repository secrets**:
   - `RH_USERNAME`: Your Red Hat registry username
   - `RH_PASSWORD`: Your Red Hat registry password


## Local Environment Setup

### 1. Install FlightCtl CLI

```bash
# Download from FlightCtl releases
curl -L -o flightctl https://github.com/flightctl/flightctl/releases/latest/download/flightctl-linux-amd64
chmod +x flightctl
sudo mv flightctl ~/.local/bin/flightctl
```

### 2. Prepare VM Environment

Ensure your virtualization software can:
- Create VMs with 1.5-2.5GB RAM
- Boot from ISO files
- Provide network connectivity to VMs

### 3. Storage Requirements

Ensure adequate disk space for:
- VM disk images (~20GB per VM)
- ISO files (~2GB each)
- Container image cache

## Next Steps

Once setup is complete, proceed to [RHEM Deployment](02-rhem-deployment.md) to prepare your management environment.