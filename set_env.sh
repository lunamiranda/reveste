#!/bin/bash

# Kamal Environment Variables Helper

export GOOGLE_CLIENT_SECRET="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"
export JWT_SECRET="super_secret_jwt_key_change_in_production"
export KAMAL_REGISTRY_PASSWORD="Suporte88@DOC"
export POSTGRES_PASSWORD=spider

# DATABASE_URL needs to be in the format expected by the app
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_USER=spider
export POSTGRES_DB=smoney
export DATABASE_URL="postgresql://spider:spider@localhost:5432/smoney"

echo "Environment variables set:"
echo "  GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET"
echo "  JWT_SECRET=$JWT_SECRET"
echo "  KAMAL_REGISTRY_PASSWORD=$KAMAL_REGISTRY_PASSWORD"
echo "  DATABASE_URL=$DATABASE_URL"
echo ""
echo "To unset, run: source unset_env.sh"
