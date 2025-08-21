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

To allow the workflow to read repository contents and push packages:

1. Go to **Repository Settings** → **Actions** → **General**.
2. Scroll to **Workflow permissions**.
3. Select:
   - ✅ **Read repository contents and packages permissions**
4. Click **Save**.

### 3. Configure Red Hat Credentials

The workflow supports two authentication methods with Red Hat:

#### Option 1: Username/Password (Default)
1. Go to **Repository Settings** → **Secrets and variables** → **Actions**.
2. Add the following **Repository secrets**:
   - `RH_USERNAME`: Your Red Hat username
   - `RH_PASSWORD`: Your Red Hat password

#### Option 2: Organization ID/Activation Key (Optional)
If you prefer to use activation keys:
1. Add these **Repository secrets** instead:
   - `RHT_ORGID`: Your Red Hat organization ID
   - `RHT_ACT_KEY`: Your Red Hat activation key

The workflow will automatically detect which method to use based on available secrets.

### 4. (Optional) Configure Custom Registry Settings

By default, images are pushed to GitHub Container Registry (GHCR). To use a different registry:

1. Go to **Repository Settings** → **Secrets and variables** → **Actions**.
2. Under **Variables**, add any of:
   - `DEST_REGISTRY_HOST`: Custom registry hostname (default: `ghcr.io`)
   - `DEST_REGISTRY_USER`: Custom registry username (default: `github.actor`)
   - `DEST_IMAGE`: Custom image name (default: `{owner}/bootc-example`)
   - `TAGLIST`: Custom tags (default: `latest {sha} {branch}`)
3. Under **Secrets**, add:
   - `DEST_REGISTRY_PASSWORD`: Custom registry password (default: `GITHUB_TOKEN`)

### 5. (Optional) Override Source Registry Credentials

If you need different credentials for pulling from registry.redhat.io:

1. Add these **Repository secrets**:
   - `SOURCE_REGISTRY_USER`: Registry username (defaults to `RH_USERNAME`)
   - `SOURCE_REGISTRY_PASSWORD`: Registry password (defaults to `RH_PASSWORD`)



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