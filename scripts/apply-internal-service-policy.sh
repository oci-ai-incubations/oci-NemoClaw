#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Apply a sandbox policy that allows access to a single private/internal
# service through the sanctioned OpenShell proxy path, including allowed_ips
# for the resolved private destination.
#
# Usage:
#   ./scripts/apply-internal-service-policy.sh [gateway-name] <sandbox-name> <host> <port> <allowed-ip> [binary]
#
# Example:
#   ./scripts/apply-internal-service-policy.sh nemoclaw my-sandbox \
#     broker.example.internal 8787 10.0.0.150 /usr/bin/curl

set -euo pipefail

GATEWAY_NAME="${1:-}"
SANDBOX_NAME="${2:-}"
SERVICE_HOST="${3:-}"
SERVICE_PORT="${4:-}"
ALLOWED_IP="${5:-}"
BINARY_PATH="${6:-/usr/bin/curl}"

if [ -z "$ALLOWED_IP" ]; then
  echo "Usage: $0 [gateway-name] <sandbox-name> <host> <port> <allowed-ip> [binary]" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
POLICY_FILE="$(mktemp)"
trap 'rm -f "$POLICY_FILE"' EXIT

cat >"$POLICY_FILE" <<EOF
version: 1
filesystem_policy:
  include_workdir: true
  read_only:
    - /usr
    - /lib
    - /proc
    - /dev/urandom
    - /app
    - /etc
    - /var/log
  read_write:
    - /sandbox
    - /tmp
    - /dev/null
landlock:
  compatibility: best_effort
process:
  run_as_user: sandbox
  run_as_group: sandbox
network_policies:
  internal_service:
    name: internal_service
    endpoints:
      - host: ${SERVICE_HOST}
        port: ${SERVICE_PORT}
        access: full
        allowed_ips:
          - ${ALLOWED_IP}
    binaries:
      - path: ${BINARY_PATH}
EOF

ARGS=()
if [ -n "$GATEWAY_NAME" ]; then
  ARGS+=( -g "$GATEWAY_NAME" )
fi

openshell policy set "${ARGS[@]}" "$SANDBOX_NAME" --policy "$POLICY_FILE" --wait --timeout 60
