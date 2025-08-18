# Demo Preparation Guide

Complete these steps before running your demo to ensure smooth execution.

## Image Preparation

### 1. Prepare APP v1 and Device v1 definitions

Create version 1 (baseline) of both device image definitions (`kvm` and `kiosk`) and the example application (Postgres).

1. Copy the `config.yaml` file that you created after the [RHEM Deployment](02-rhem-deployment.md).

```bash
# Copy RHEM config to image directories
cp config.yaml devices/kvm/
cp config.yaml devices/kiosk/
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



### 5. Create Installable Artifacts for Device v1

Use `bootc-image-builder` to create ISO files from both device v1 images (`kvm` and `kiosk`).

The easiest way is to use a subscribed RHEM machine. You can follow the instructions shown in the [Flightctl project repository](https://github.com/flightctl/flightctl/blob/main/docs/user/getting-started.md#provisioning-a-device-with-a-bootable-container-image) or use scripts such as the ones in the [`bootc-build-scenarios`](https://github.com/luisarizmendi/bootc-build-scenarios) repo.




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