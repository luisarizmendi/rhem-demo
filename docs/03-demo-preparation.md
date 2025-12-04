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

**Note:** If you already run this demo you might want to delete the previous v1 and v2 device and artifact images that you want to use to preserve `v1` and `v2` instead of `v3` or `v4`.


Push the changes to trigger the GitHub Actions workflow.

```bash
git add .
git commit -m "APP and device v1 images"
git push
```


### 3. Prepare APP v2 and Device v2 definitions

1. Make the v2 changes in the image that you want to use in the demo, for example `kiosk` (e.g., add `tmux` package in the `Containerfile`)

**Note**: `Microshift` image has been configured to keep always the same version number. You can change it by modifying the `keep_version` value to `false` in the `.buildconfig` file.

2. Make the v2 changes in the application example (e.g., using version 9.6 intead 9.5 of the `pgadmin` container image in `apps/compose/postgres/Containerfile`)



### 4. Build APP v2 and Device v2 images

Push the changes to trigger the GitHub Actions workflow.

```bash
git add .
git commit -m "APP and device v2 images"
git push
```



### 5. Installable Artifacts for Device v1

Once the build is completed, you can extract installable artifacts (ISOs, disk images, etc.) from the artifact container images:

```bash
# Example: Extract an anaconda-iso artifact
mkdir artifacts
podman create --name temp-container ghcr.io/<your user>/device-<image name>-anaconda-iso:v1-amd64
podman cp temp-container:/ ./artifacts/

# The installable files will be in ./artifacts/
ls -la artifacts/bootiso/
```

**Note**: All generated images, including the artifact images, can be listed in the `Packages` section in GitHub.


### 6. Check v1 usage in Fleet definition

Check that you have v1 for both the device image and the APP in your fleet definition files.



## Pre-Demo Test Run

**Strongly recommended:** Run through the entire demo once before presenting:

1. Boot a VM from ISO
2. Complete enrollment process
3. Assing it to a fleet and wait for changes to be applied
4. Test configuration management  
5. Test applications
6. Perform OS upgrade

If using Microshift:

7. Add `site=emea` and `function=pos` to Microshift and add it to `stores` ClusterSet
8. Test Microshift applications (`hello` and `pos`)

This identifies any issues and helps with timing.


## Next Steps

With preparation complete, you're ready to run the [Demo Script](04-demo-script.md).