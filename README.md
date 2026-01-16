# Red Hat Edge Manager Demo

A comprehensive demo showcasing Red Hat Edge Manager (RHEM) capabilities for managing edge devices at scale. RHEM is product based on upstream [Flight Control project](https://github.com/flightctl/flightctl).

## What You'll Learn

- Zero-touch device onboarding at scale
- Image-based immutable operating systems with bootc RHEL
- Declarative application and configuration management
- Fleet management with templated configurations  
- Built-in observability and remote troubleshooting
- Secure pull-mode device communication

**Demo Duration** ~120 minutes (including presentation)

## Demo Architecture

![demo arch](docs/demo-arch.png)


## Repository Structure

```
├── apps/          # Application definitions (Podman Compose + scratch Containerfiles)
├── devices/       # Bootc device image definitions  
├── configs/       # Runtime configuration files
├── fleets/        # RHEM fleet definitions
├── docs/          # Documentation and guides
├── infra/         # Infrastructure definition
└── .github/       # CI/CD workflows for image building
```

## Quick Start

1. **Fork and Configure the repo** - See [Setup Guide](docs/01-setup.md#1-fork-and-configure-the-repository)

2. **Set up GitHub Actions** - See [Setup Guide](docs/01-setup.md#2-enable-github-actions-permissions)

3. **Deploy RHEM and infra** - Follow [RHEM Deployment](docs/02-rhem-deployment.md)

4. **Prepare Demo Environment** - See [Demo Preparation](docs/03-demo-preparation.md)

5. **Run the Demo** - Follow [Demo Script](docs/04-demo-script.md)

6. **Explain RHEM Value** - Follow [Demo Script](docs/05-value-propotitions.md)

## Demo Sections

| Section | Duration | Key Features |
|---------|----------|--------------|
| 0. [Demo Introduction](docs/04-demo-script.md#0-demo-introduction-5-minutes)| 5 min | Demo Introduction |
| 1. [Building Device Images](docs/04-demo-script.md#1-building-device-images-10-minutes--background) | 10 min | Bootc image creation, GitHub Actions |
| 2. [Device Onboarding](docs/04-demo-script.md#2-device-onboarding-10-minutes) | 10 min | Zero-touch provisioning, enrollment |
| 3. [Fleet Management](docs/04-demo-script.md#3-fleet-management-10-minutes) | 10 min | Intro to fleet management with RHEM |
| 4. [Check Configuration Management](docs/04-demo-script.md#4-check-configuration-management-5-minutes) | 5 min | Runtime config update |
| 5. [Check Application Deployment](docs/04-demo-script.md#5-check-application-deployment-10-minutes) | 10 min | Container app management, upgrades |
| 6. [Operating System and Application Upgrades](docs/04-demo-script.md#6-operating-system-and-application-upgrades-10-minutes) | 10 min | Image-based OS and applicationupgrades |
| 7. [Microshift management with ACM](docs/04-demo-script.md#7-optional-microshift-management-with-acm-20-minutes) | 15 min | Microshift management with ACM |
| 8. [Demo Wrap-up](docs/04-demo-script.md#8-demo-wrap-up-5-minutes) | 5 min | Summary |



## Requirements

- Laptop with virtualization support.
- Red Hat subscription
- FlightCtl CLI
- VM software (KVM/VirtualBox/VMware)
- 4GB+ available RAM for VMs

## Documentation

- [📊 Slide Deck example](docs/LA%20-%20RHEM%20technical%20capabilities%20overview.pdf) - Presentation example

## Image Building

This repo uses GitHub Actions to automatically build:
- **Bootc device images** (`devices/` changes → `ghcr.io/owner/device-*`)
- **Application images** (`apps/compose` changes → `ghcr.io/owner/app-*`)

Images are built with automatic versioning.

You can [know more about the GitHub Actions workflow that builds the bootc images and how to setup your own pipeline here](docs/github_actions_workflow.md).

If you want to check other examples you can get some ideas from [`bootc-build-scenarios`](https://github.com/luisarizmendi/bootc-build-scenarios) repo.



## Support & Feedback

This demo uses a standalone RHEM deployment for simplicity. Production deployments follow different patterns.At this moment, for production deployments, RHEM is available through:
- Red Hat Ansible Automation Platform
- Red Hat Advanced Cluster Management
