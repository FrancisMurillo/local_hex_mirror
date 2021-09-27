#!/bin/bash

set -e

if [[ -z "${HEX_REGISTRY}" ]]; then
  echo "Using online hexpm mirror"
  export HEX_HTTP_CONCURRENCY=1
  export HEX_HTTP_TIMEOUT=1200
else
  echo "Using local hexpm mirror: $HEX_REGISTRY"
  export HEX_NO_VERIFY_REPO_ORIGIN=1
  mix hex.repo add hexpm "$HEX_REGISTRY" --public-key=".hex_repo/public_key"
fi

echo "Updating dependencies if any uninstalled packages..."
mix deps.get

echo "Running migrations if any..."
mix ecto.create --no-deps-check
mix ecto.migrate --no-deps-check

echo "Done with housecleaning"
exec "$@"
