# rhel bootc image

This image includes libvirt to run virtual machines and it contains several custom scripts to show a management worflow example.

---

## Features

This image includes:

- **Flightctl agent** - Enables management of the device through **Red Hat Edge Manager**.

- **Dynamic File Retrieval** - The `get-files.sh` script (located in `/usr/local/bin`) downloads files from HTTP sources or container registries, with configuration managed via `/etc/get-files.yaml`.

- **First Boot Automation** - The `first-boot.sh` script (in `/usr/local/bin`) runs on initial device boot and performs:
  - Hostname configuration based on MAC address using `set-hostname-from-mac.sh`
  - File downloads using `get-files.sh`

- **Hook-Based File Monitoring** - The `hook-files.sh` script (in `/usr/local/bin`) monitors files and directories, triggering actions configured in `/usr/lib/flightctl/hooks.d/afterupdating`. Uses the same configuration files as the flightctl-agent, ensuring compatibility with Red Hat Edge Manager. The script automatically disables itself once the device is enrolled to avoid conflicts with Red Hat Edge Manager's native hook feature.

---

## Extracting Installable Artifacts (ISO)

The GitHub Actions workflow creates two types of outputs:

1. **Bootc container image**: [ghcr.io/luisarizmendi/device-rhel:{label}](https://github.com/luisarizmendi/rhem-demo/pkgs/container/device-rhel)
2. **Artifact container image**: [ghcr.io/luisarizmendi/device-rhel-anaconda-iso:{label}](https://github.com/luisarizmendi/rhem-demo/pkgs/container/device-rhel-anaconda-iso)

To extract installable artifacts (ISOs, disk images, etc.) from the artifact container images:

```bash
# Example: Extract an anaconda-iso artifact
mkdir artifacts
podman create --name temp-container ghcr.io/luisarizmendi/bootc-rhel-anaconda-iso:v1-amd64
podman cp temp-container:/ ./artifacts/

# The installable files will be in ./artifacts/
ls -la artifacts/bootiso/
```

---

## Device Requirements

- Safe minimum (without additional VMs) will be 2 cores and 2 GB of memory and 20GB disk
- Network connectivity

---

## Pre-Build Configuration

### 1. Red Hat Edge Manager Config

You should include your specific Red Hat Edge Manager config file under `/etc/flightctl/config.yaml` before building your image to enable fully automated onboarding. 


```bash
flightctl login --username=<your_user> --password=<your_password> --insecure-skip-tls-verify https://<rhem_api_server_url>

flightctl certificate request --signer=enrollment --expiration=365d --output=embedded > config.yaml
```

If you don't want to rebuild the image, you can change the built-in file with one containing your values after installing the device as a post-boot action. This will automatically trigger the flightctl-agent restart thanks to the hook-files.sh monitoring script.

---

## Post-Boot Configuration

After the device boots, you can customize the following components:


### Flightctl / Red Hat Edge Manager

The image includes an embedded configuration for zero-touch provisioning with enrollment. You can modify this configuration after installation, and the `hook-files.sh` script will automatically restart the flightctl-agent to apply the changes.


