# HashiCorp Boundary

![HashiCorp Boundary Logo](https://www.hashicorp.com/_next/static/media/colorwhite.997fcaf9.svg)

## Overview

HashiCorp Boundary is a secure and efficient way to access distributed infrastructure. It provides secure access to SSH, RDP, and HTTP(S) resources, without the need for VPNs or exposing the infrastructure to the public internet.

This README file explains how to set up a multi-hop deployment using Boundary.

## Multi-hop Deployment

A multi-hop deployment allows you to access resources that are not directly reachable from the Boundary controller. This is achieved by deploying additional Boundary nodes between the controller and the target resource.

To set up a multi-hop deployment, follow these steps:

1. Install the Boundary controller on a server that is reachable from the internet.
2. Install a Boundary worker on each server that you want to access through Boundary.
3. Install an additional Boundary node on a server that is reachable from the internet and can access the worker nodes.
4. Configure the Boundary nodes as follows:
   - The worker nodes should be registered with the additional node as their parent.
   - The additional node should be registered with the controller as its parent.
5. Create a Boundary policy that allows access to the desired resources, and assign it to the appropriate users or groups.

## Environment and tfvars Variables

The following environment variables can be used to configure the Boundary controller:

- `BOUNDARY_ADDR`: The address that the controller listens on (default: `tcp://0.0.0.0:9200`).
- `BOUNDARY_LOG_LEVEL`: The logging level (default: `info`).
- `BOUNDARY_DATABASE_URL`: The URL of the database (default: `sqlite:///data/boundary.db`).

The following tfvars variables can be used to configure the Boundary modules:

- `boundary_controller_address`: The address that the controller listens on (default: `tcp://0.0.0.0:9200`).
- `boundary_worker_count`: The number of worker nodes to deploy (default: `1`).
- `boundary_additional_node_count`: The number of additional nodes to deploy (default: `0`).