# Demo Script

A step-by-step guide for running the Red Hat Edge Manager demo. Each section includes timing, key points, and detailed steps.

## Summary

0. [Demo Introduction](#0-demo-introduction-5-minutes)
1. [Building Device Images](#1-building-device-images-10-minutes--background)
2. [Device Onboarding](#2-device-onboarding-10-minutes)
3. [Fleet Management](#3-fleet-management-10-minutes)
4. [Check Configuration Management](#4-check-configuration-management-5-minutes)
5. [Check Application Deployment](#5-check-application-deployment-10-minutes)
6. [Operating System and Application Upgrades](#6-operating-system-and-application-upgrades-10-minutes)
7. [Microshift management with ACM](#7-optional-microshift-management-with-acm-15-minutes)
8. [Demo Wrap-up](#8-demo-wrap-up-5-minutes)

## 0. Demo Introduction (5 minutes)

### Opening Points
- Edge computing challenges: scale, remote locations, limited IT expertise
- Network constraints and security requirements  
- Resource limitations and operational complexity

### Environment Overview
- **Demo setup**: Explain RHEM deployment
- **Production reality**: RHEM integrates with Ansible Automation Platform or ACM
- **Infrastructure**: Single laptop demonstration with VMs simulating edge devices

---

## 1. Building Device Images (10 minutes + background)

### Key Messages
- Bootc leverages container tools and knowledge for OS image creation
- Images embed RHEM agent, certificates, and endpoint configuration
- Alternative: Generic images with runtime configuration via cloud-init
- Container registry benefits: signatures, security scans, distribution



### Demo Steps

1. **Show bootc Images Containerfile**:
   Open one of the Containerfiles under `devices` directory in your repo and show how that `config.yaml` file is embeded into the image, and how the rhem agent is installed.


2. **Demonstrate image building**:
   Introduce a change in the `Containerfile`:

   ```bash
   # Make a visible change (e.g., add zsh package)
   vi `devices/kvm/Containerfile`
   ```

   Push the change into Git:

   ```bash
   git add devices
   git commit -m "Add zsh package"
   git push
   ```

3. **Show GitHub Actions workflow**:
   - Open repository **Actions** tab
   - Point out automated multi-arch builds
   - Explain versioning strategy

4. **Continue with next section** (build runs in background)


![step 1](step-1.png)



### What to Mention
- Two image types: KVM (general purpose) and Kiosk (display applications)
- Subscription handling in GitHub Actions vs. registered RHEL hosts
- Installable artifacts: ISO, QCOW2, AMI, VMDK options

---

## 2. Device Onboarding (10 minutes)

### Key Messages  
- Zero-touch provisioning reduces onsite expertise requirements
- Secure pull-mode communication (no inbound firewall ports needed)
- QR code provides convenient UI access
- Decoupled image and installation artifact approach

### Demo Steps

1. **Create and boot VMs**:

   - Depending on the Images that you want to use, create one or multiple of these machines:

   **Note:** If you want to demo Microshift, create either the `kiosk` or `kvm` VM to show RHEL configuration capabilities and one additional `microshift` VM to demo ACM integration. Maintain the `microshift` VM powered off until you start the Microshift management demo steps.

   These are the recommended resources for each type:

   * Kiosk VM
      - 1.5GB RAM, 2 vCPUs, 20 GB Disk
      - Boot from Kiosk device ISO

   * KVM VM
      - 4GB RAM, 4 vCPUs, 50 GB Disk
      - Boot from KVM device ISO

   * Microshift VM
      - 4GB RAM, 4 vCPUs, 50 GB Disk
      - Boot from Microshift device ISO

   - **Wait time**: ~3:30 minutes

2. **During boot wait, explain**:
   - USB with ISO boot simulation (could be PXE in production) instead of direct QCOW2 usage (for demo propouses)
   - Device pulls image and configures itself
   - Automatic certificate-based authentication

3. **Handle enrollment request**:
   - When the Kiosk APP appears, open RHEM UI
   - Show enrollment request with device details
   - DO NOT accept the enrollment, that will be done in next step

![step 2](step-2.png)


### What to Mention
- No technical expertise required onsite
- Simplified network configuration (outbound-only)
- Scalable across hundreds/thousands of devices


---

## 3. Fleet Management (10 minutes)

### Key Messages
- Scale from individual devices to fleet operations
- Template-based configuration for flexibility
- Git-based fleet definitions (GitOps approach)
- Label-based device assignment and configuration

### Demo Steps

1. **Create fleet from Git**:
   - RHEM UI → `Repositories`
   - Create a repository:
         * Name: `rhem-demo`
         * URL: `https://github.com/<your user>/<your repo>`
         * Sync name: `rhem/fleets`
         * Revision: `main`
         * Path: `/rhem/fleets`
   - Show the `fleet.yaml` file or/and how to create a fleet manually in the UI while waiting for sync completion (~1.5 minutes). 
   - Show fleet in `Fleets` section

2. **Enroll with fleet labels**:
   - Back to `Devices` and click in `Approve`
   - Assign labels for:
     * Your fleet(`kvm`, `kiosk` or `microshift`), e.g `fleet=kiosk`
     * Your site with `site=na` or `site=emea`  
     * Your function with `function=<directory name under configs/function>`, e.g. `function=kiosk-energy`
   - Accept enrollment

   **Note:** The kiosk image has enabled the `kiosk-solvent-recovery` function by default, so if you want to see a change in the APP you should configure your label to a diffent value than that one.

3. **Wait for drift detection**:
   - Explain drift detection process
   - Wait until the `Update status` is "Up-to-date" (~1 minute)

   **Note:** If you have in your `fleet.yaml` any other image version different than the one that it is installed by default with the ISO (`<name>:latest-<arch>`) there will be a System upgrade that will take more time (~6.5 minutes) since it needs to download the new image. 


![step 3](step-3.png)

### What to Mention
- Single fleet definition supports multiple configurations
- Reduces management overhead
- Consistent policy application
- Flexible device categorization



---

## 4. Check Configuration Management (5 minutes)

### Key Messages
- Runtime configuration preferred over build-time when needed
- Git-based configuration management (GitOps benefits) such as change tracking and rollback capabilities
- Site-specific or security-sensitive configurations must be in runtime, not in image

### Demo Steps

1. **Show configuration config in fleet definion**:
   - Open [rhem/fleets/kiosk.yaml](../rhem/fleets/kiosk.yaml) and show the `config` section
   - Click Create a new Fleet in RHEM to show the Configuration management options


2. **Verify configuration**:
   ```bash
   ssh user@device-ip
   # MOTD should display the configured message (`This system is managed by flightctl.`)
   ```

3. **Verify kiosk APP**:
   Depending on the label `function` assigned to the device, you will get an APP or another. See below an example for `kiosk-energy` 


![step 4](step-4.png)


### What to Mention
When to Use Runtime Configuration:
- Site-specific network credentials
- Deployment-specific settings  
- Security credentials (not safe in images)
- Frequently changing parameters




---

## 5. Check Application Deployment (10 minutes)

### Key Messages
- Container applications managed separately from OS lifecycle
- OCI registry distribution for consistency
- Docker Compose for multi-container applications
- Faster update cadence than OS updates

### Demo Steps

1. **Show application definition**:
   Show the compose file and how it's packaged by reviewing repo files under `apps/compose/postgres`

2. **Explain what was deployed into the Fleet**:
   - Open [rhem/fleets/kiosk.yaml](../rhem/fleets/kiosk.yaml) and show the `applications` section
   - Review the values:
     - Image: `ghcr.io/luisarizmendi/app-postgres:v1`
     - Environment variables:
       ```
       POSTGRES_USER=postgres
       POSTGRES_PW=pgredhat
       POSTGRES_DB=postgres
       PGADMIN_MAIL=pgadmin@none.com
       PGADMIN_PW=pgredhat
       ```

3. **Review the deployment**:
   - SSH to the device
   - Check that the images were pulled:
     ```bash
     sudo podman image list
     ```
   - Check that containers are running:
     ```bash
     sudo podman ps
     ```     

4. **Verify application**:
   - Access pgAdmin: `http://device-ip:5050`
   - Login with configured credentials (`pgadmin@none.com` / `pgredhat`)
   - Show pgAdmin version (9.5) by click on the up menu in `Help` > `About pgAdmin 4`
   - Optional: Configure PostgreSQL connection


![step 5](step-5.png)

###  What to Mention
- Independent application lifecycle
- Faster updates than OS changes
- Container ecosystem advantages
- GitOps configuration management




---

## 6. Operating System and Application Upgrades (10 minutes)

### Key Messages
- Bootc enables image-based OS updates
- Atomic updates with rollback capability
- Mobile phone-style OS upgrade experience (reboot needed)
- Combines OS, configuration, and embedded applications

### Demo Steps

1. **Check the running Image version**
   - SSH into the device
   - Check the running version with `sudo bootc status`
   - Follow the Journal `journalctl -u flightctl-agent.service -f` and maintain it visible

2. Update the Fleet configuration
   - Change application and image version to `v2` in fleet definition file that you are using under `rhem/fleets`, for example, if you used `kiosk`:

```yaml
...
    spec:
      applications:
      - envVars:
          PGADMIN_MAIL: pgadmin@none.com
          PGADMIN_PW: pgredhat
          POSTGRES_DB: postgres
          POSTGRES_PW: pgadmin
          POSTGRES_USER: pgredhat
        image: ghcr.io/luisarizmendi/app-postgres:v2
        name: postgres
      config:
...
      os:
        image: ghcr.io/luisarizmendi/device-kiosk:v2

```

3. **Push changes to the repo**:
   ```bash
   git add rhem/
   git commit -m "new fleet version"
   git push
   ```


2. **Monitor upgrade process**:
   - Check the console where you are following the Journal, you will see something like `msg="Fetching OS image: ghcr.io/luisarizmendi/device-kiosk:v2"`
   - Wait until the device downloads new image for the device and the application, stages update and reboots. Time depends on conexion speed but it's something like ~6.5 minutes)
   - Use this time to explain `bootc` and its benefits or coninue with the next step before coming back here.

3. **Verify upgrade**:
   - SSH into the device after the reboot.
   - Check the running version with `sudo bootc status`.
   - If you instelled any new RPM (e.g. `tmux` or `cockpit`) try to use it.
   - Open the pgAdmin application and check the version.

   **Note:** The Application container could take some time to start.


![step 6](step-6.png)


###  What to Mention
- Benefits of bootc upgrades (atomic, consistent, and reproducible updates).


---


## 7. [OPTIONAL] Microshift management with ACM (20 minutes)

**Note:** You need RHEM integrated with ACM to follow these steps.

### Key Messages
- RHEM is integrated with ACM to simplify k8s App management in RHDE
- Zero-Touch Provisioning for k8s APPs after cluster group assignment
- GitOps methodogy management benefits


### Demo Steps

1. **Log into the Microshift VM**
   - Turn on the `microshift` VM and wait until QR appears in the VM console.
   - SSH into the VM with `admin / redhat` (if you didn't change defaults)
   - Run the following command to check all PODs runnin in Microshift: `sudo watch oc get pod -A`
   - Keep the output visible while you go through the next steps.
   - Open a new SSH console and add your pull-secret: `sudo vi /etc/crio/openshift-pull-secret`. You might want to have all PODs in "Running" state.

**Note:** The pull secret was not included [in the image](https://github.com/luisarizmendi/rhem-demo/blob/main/devices/microshift/files/etc/crio/openshift-pull-secret) or [in the fleet configuration](https://github.com/luisarizmendi/rhem-demo/blob/main/rhem/fleets/microshift.yaml) because the GitHub repo is public and there is no secret store configured for it, but the appropiate security measures you won't need this manual step.

2. **Accept enrollment request**:
   - Open RHEM UI in ACM and open the enrollment request.
   - Assign the `microshift` fleet by adding the label `fleet=microshift` and accept the enrollment
   - Check changes in the `watch` command output, you will see how Advance Cluster Management components under `open-cluster-management-agent` namespace are added to Microshift. It could take ~5 minutes to appear since you accepted the device, use that time to explain the different ways that ACM manage applications on top of k8s (policies, ArgoCD).

3. **Assign labels to Microshift and add it to ClusterSet**:
   - In `Infrastructure > Clusters` find the new Microshift cluster . 
   - Check that all Add-ons are ok. Once everything is green, add the following labels to the cluster by click the three dots on the right of the cluster.
     - Your site label, either `site=na` or `site=emea`  
     - Your function label, either `function=pos` or `function=infra`
   - Assign the Microshift cluster to the `stores` ClusterSet in the `Infrastructure > Clusters` menu under `Cluster sets` tab. Click the three dots on the right to the `stores` ClusterSet and click `Manage resource assignments`. Select the Microshift cluster and click "Review" and "Save".

4. **Review device compliance**
   - Go to ACM `Governance` menu. In the the `Policies` tab you can check that the configuration have been applied to the device.
   - Check changes in the `watch` command output that you run before. After some time you will see two new applications. One will be `hello` and the other will depend on your `function` label, it could be either `pos` or `infra`.
   
5. **Review deployed APPs**
   - Run this command in the device to get the routes to the new APPs: `oc get route -A`
   - Open the URL for the `hello` APP. You will see a message that will depend on the labels `site` and `function` that you configured in your cluster.
   - Open the URL for the `pos` or `infra` APP




![step 7](step-7.png)

###  What to Mention
- ACM integration unlocks advanced management features
- Zero-Touch provisioning for Microshift APPs
- You can control what APPs are deployed depending on cluster labels and ClusterSet assignment 
- You can control deployed APP configuration depending on cluster labels and ClusterSet assignment 






---

## 8. Demo Wrap-up (5 minutes)

### Key Takeaways
1. **Intuitive Operations**: User-friendly interface bridges IT skills gap
2. **Flexible Management**: On-premises and cloud deployment options  
3. **Policy-Driven**: Desired-state configuration for consistency
4. **Resilient Architecture**: Pull-mode management works in challenging networks
5. **Edge-Hardened Security**: mTLS communication and identity verification
6. **Proactive Insights**: Built-in monitoring and troubleshooting
7. **Complete Lifecycle**: Onboarding through decommissioning support

Now explain the [RHEM value](05-value-propotitions.md).
