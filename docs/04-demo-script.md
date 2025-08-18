# Demo Script

A step-by-step guide for running the Red Hat Edge Manager demo. Each section includes timing, key points, and detailed steps.

## Demo Introduction (3 minutes)

### Opening Points
- Edge computing challenges: scale, remote locations, limited IT expertise
- Network constraints and security requirements  
- Resource limitations and operational complexity

### Environment Overview
- **Demo setup**: RHEM running on kind (explain this is for demo simplicity)
- **Production reality**: RHEM integrates with Ansible Automation Platform or ACM
- **Infrastructure**: Single laptop demonstration with VMs simulating edge devices

---

## 1. Building Device Images (5 minutes + background)

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
   # Make a visible change (e.g., add tmux package)
   vi devices/kvm/Containerfile
   ```

   Push the change into Git:

   ```bash
   git add devices/kvm/Containerfile
   git commit -m "Add tmux package"
   git push
   ```

3. **Show GitHub Actions workflow**:
   - Open repository **Actions** tab
   - Point out automated multi-arch builds
   - Explain versioning strategy

4. **Continue with next section** (build runs in background)

### What to Mention
- Two image types: KVM (general purpose) and Kiosk (display applications)
- Subscription handling in GitHub Actions vs. registered RHEL hosts
- Installable artifacts: ISO, QCOW2, AMI, VMDK options

---

## 2. Device Onboarding (7 minutes)

### Key Messages  
- Zero-touch provisioning reduces onsite expertise requirements
- Secure pull-mode communication (no inbound firewall ports needed)
- QR code provides convenient UI access
- Decoupled image and installation artifact approach

### Demo Steps

1. **Create and boot VM**:
   - Create VM: 1.5GB RAM, 2 vCPUs
   - Boot from KVM device ISO
   - **Wait time**: ~2:30 minutes for QR code appearance

2. **During boot wait, explain**:
   - USB with ISO boot simulation (could be PXE in production) instead of direct QCOW2 usage (for demo propouses)
   - Device pulls image and configures itself
   - Automatic certificate-based authentication

3. **Handle enrollment request**:
   - When QR appears, open RHEM UI
   - Show enrollment request with device details
   - Accept the enrollment
   - **Wait time**: ~2 minutes for green status checks


### What to Mention
- No technical expertise required onsite
- Simplified network configuration (outbound-only)
- Scalable across hundreds/thousands of devices

---

## 3. Configuration Management (5 minutes)

### Key Messages
- Runtime configuration preferred over build-time when needed
- Git-based configuration management (GitOps benefits) such as change tracking and rollback capabilities
- Site-specific or security-sensitive configurations must be in runtime, not in image

### Demo Steps

1. **Show configuration file**:
   ```bash
   cat configs/motd/generic
   ```

2. **Apply configuration via RHEM**:
   - Open device in RHEM UI
   - Edit device configuration
   - Add file: `/etc/motd`
   - Method: Git repository or inline
   - Use: `configs/motd/generic/motd` file

3. **Wait for drift detection**:
   - **Wait time**: ~2:30 minutes
   - Explain drift detection process
   - Show configuration status updates

4. **Verify configuration**:
   ```bash
   # SSH or VM console login
   ssh user@device-ip
   # MOTD should display the configured message
   ```

### What to Mention
When to Use Runtime Configuration:
- Site-specific network credentials
- Deployment-specific settings  
- Security credentials (not safe in images)
- Frequently changing parameters

---

## 4. Application Deployment (10 minutes)

### Key Messages
- Container applications managed separately from OS lifecycle
- OCI registry distribution for consistency
- Docker Compose for multi-container applications
- Faster update cadence than OS updates

### Demo Steps

1. **Show application definition**:
   ```bash
   # Show compose file and how it's packaged
   cat apps/postgres/compose.yaml
   cat apps/postgres/Containerfile
   ```

2. **Deploy application (v1)**:
   - Open device in RHEM UI
   - Configure application:
     - Image: `ghcr.io/your-username/app-demo-postgres:v1`
     - Environment variables:
       ```
       POSTGRES_USER=postgres
       POSTGRES_PW=pgredhat
       POSTGRES_DB=postgres
       PGADMIN_MAIL=pgadmin@none.com  
       PGADMIN_PW=pgredhat
       ```

3. **Monitor deployment**:
   - **Wait time**: ~4 minutes for image pulls and startup
   - Optional: Show container activity:
     ```bash
     # terminal 1
     watch 'podman image list; echo ""; podman ps'
     ```

     ```bash
     # terminal 2
     journalctl -f 
     ```     

4. **Verify application**:
   - Access pgAdmin: `http://device-ip:5050`
   - Login with configured credentials
   - Show pgAdmin version (9.5)
   - Optional: Configure PostgreSQL connection

5. **Demonstrate upgrade to v2**:
   - Edit device application configuration
   - Change image to: `app-demo-postgres:v2`
   - **Wait time**: ~2 minutes for upgrade
   - Login to pgAdmin again, show version 9.6

###  What to Mention
- Independent application lifecycle
- Faster updates than OS changes
- Container ecosystem advantages
- GitOps configuration management

---

## 5. Operating System Upgrades (7 minutes)

### Key Messages
- Bootc enables image-based OS updates
- Atomic updates with rollback capability
- Mobile phone-style OS upgrade experience (reboot needed)
- Combines OS, configuration, and embedded applications

### Demo Steps

1. **Check current OS version**:
   ```bash
   # SSH to device
   bootc status
   # Note the current image version
   ```

2. **Configure OS image in RHEM**:
   - Edit device in RHEM UI
   - Set bootc image: `ghcr.io/your-username/device-demo-kvm:v2`
   - Apply changes

3. **Monitor upgrade process**:
   - **Wait time**: ~5 minutes total
   - Device downloads new image
   - Stages update and reboots
   - Show RHEM UI status during process

4. **Verify upgrade**:
   ```bash
   # After reboot, SSH to device
   bootc status
   # Confirm new image version
   ```

   Open `https://device-ip:9090` to show the Cockpit console.

###  What to Mention
- Benefits of bootc upgrades (atomic, consistent, and reproducible updates).

---

## 6. Device Observability (3 minutes)

### Key Messages
- Built-in device monitoring without additional setup
- Remote terminal access through secure tunnel
- No inbound firewall ports required
- Customizable alerting thresholds

### Demo Steps

1. **Demonstrate terminal access**:
   - Open device in RHEM UI
   - Click **Terminal** tab
   - **Wait time**: ~30-60 seconds for connection
   - Access device shell remotely

2. **Generate system load**:
   ```bash
   # On device terminal through RHEM UI
   stress -c 4 &
   ```

3. **Continue to next section** (alarm will appear later)
   - Monitoring takes time to detect sustained issues
   - Explain alarm threshold configuration
   - Point out monitoring dashboard when alarm appears

###  What to Mention
- CPU, memory, disk utilization
- System health and connectivity status
- Event logs and system metrics
- Customizable alert thresholds and destinations

---

## 7. Fleet Management (10 minutes)

### Key Messages
- Scale from individual devices to fleet operations
- Template-based configuration for flexibility
- Git-based fleet definitions (GitOps approach)
- Label-based device assignment and configuration

### Demo Steps

1. **Create fleet from Git**:
   - RHEM UI → Repositories
   - Add repository pointing to `fleets/demo.yaml`
   - Wait for sync completion
   - Show fleet in **Fleets** section

2. **Review fleet configuration**:
   ```yaml
   # Show key parts of fleets/demo.yaml
   # - Label selectors (fleet=demo)
   # - Template variables for site/function
   # - Different configurations per location
   ```

3. **Deploy kiosk device**:
   - Create new VM: 2.5GB RAM, 2 vCPUs
   - Boot from **Kiosk** device ISO
   - **Wait time**: Boot to kiosk app display

4. **Enroll with fleet labels**:
   - When enrollment appears, assign labels:
     - `fleet=demo`
     - `site=na` or `site=emea`  
     - `function=<directory name under configs/function>/kiosk-*`
   - Accept enrollment

5. **Verify fleet management**:
   - **Wait time**: Several minutes for full configuration
   - Device applies templated configuration based on labels
   - Kiosk displays application based on function label
   - Verify site-specific configs:
     ```bash
     # Check NTP configuration (varies by site)
     cat /etc/chrony.conf
     # Check container registry (varies by site) 
     cat /etc/containers/registries.conf
     ```

### What to Mention
- Single fleet definition supports multiple configurations
- Reduces management overhead
- Consistent policy application
- Flexible device categorization

---

## Demo Wrap-up (5 minutes)

### Key Takeaways
1. **Intuitive Operations**: User-friendly interface bridges IT skills gap
2. **Flexible Management**: On-premises and cloud deployment options  
3. **Policy-Driven**: Desired-state configuration for consistency
4. **Resilient Architecture**: Pull-mode management works in challenging networks
5. **Edge-Hardened Security**: mTLS communication and identity verification
6. **Proactive Insights**: Built-in monitoring and troubleshooting
7. **Complete Lifecycle**: Onboarding through decommissioning support

Explain the [RHEM value](05-value-propotitions.md).
