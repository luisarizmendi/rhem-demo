# Demo Preparation Guide

Complete these steps before running your demo to ensure smooth execution.

## Image Preparation

### 1. Prepare APP v1 and Device v1 definitions

Create version 1 (baseline) of both device image definitions (`kvm` and `kiosk`) and the example application (Postgres).

1. Copy the `config.yaml` file that you created after the [RHEM Deployment](02-rhem-deployment.md).

```bash
# Copy RHEM config to image directories
cp config.yaml devices/rhel-kvm/files/etc/flightctl/config.yaml
cp config.yaml devices/kiosk/files/etc/flightctl/config.yaml
cp config.yaml devices/microshift/files/etc/flightctl/config.yaml
```

2. Introduce any change in any file under `apps/postgres`, for example add a space or a comment.



### 2. Build APP v1 and Device v1 images

Push the changes to trigger the GitHub Actions workflow.

```bash
git add .
git commit -m "APP and device v1 images"
git push
```


### 3. Prepare APP v2 and Device v2 definitions

1. Make the v2 changes in both device definition files (e.g., add cockpit package)

2. Make the v2 changes in the application example (e.g., using version 9.6 intead 9.5 of the pgadmin container image)



### 4. Build APP v2 and Device v2 images

Push the changes to trigger the GitHub Actions workflow.

```bash
git add .
git commit -m "APP and device v2 images"
git push
```



### 5. Installable Artifacts for Device v1


To extract installable artifacts (ISOs, disk images, etc.) from the artifact container images:

```bash
# Example: Extract an anaconda-iso artifact
mkdir artifacts
podman create --name temp-container ghcr.io/luisarizmendi/device-<image name>-anaconda-iso:v1-amd64
podman cp temp-container:/ ./artifacts/

# The installable files will be in ./artifacts/
ls -la artifacts/bootiso/
```




## Pre-Demo Test Run

**Strongly recommended:** Run through the entire demo once before presenting:

1. Boot a VM from KVM ISO
2. Complete enrollment process
3. Test configuration management  
4. Deploy and upgrade applications
5. Perform OS upgrade
6. Verify fleet management

This identifies any issues and helps with timing.


## Next Steps

With preparation complete, you're ready to run the [Demo Script](04-demo-script.md).