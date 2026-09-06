#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <resource-group> <workspace-name> [true|false]" >&2
  exit 2
fi

resource_group=$1
workspace_name=$2
enabled=${3:-false}

if [[ "$enabled" != "true" && "$enabled" != "false" ]]; then
  echo "enabled must be true or false" >&2
  exit 2
fi

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ruby "$repo_root/scripts/validate.rb"
ruby "$repo_root/scripts/build_arm.rb"

az deployment group validate \
  --resource-group "$resource_group" \
  --template-file "$repo_root/dist/analytics-rules.json" \
  --parameters workspaceName="$workspace_name" enabled="$enabled"

az deployment group create \
  --name "sentinel-detection-lab-$(date -u +%Y%m%d%H%M%S)" \
  --resource-group "$resource_group" \
  --template-file "$repo_root/dist/analytics-rules.json" \
  --parameters workspaceName="$workspace_name" enabled="$enabled"
