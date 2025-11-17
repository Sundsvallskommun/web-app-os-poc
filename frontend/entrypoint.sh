#!/bin/sh
# entrypoint.sh

# Function to replace placeholder with environment variable value
replace_env_var() {
  local placeholder=$1
  local value=$2
  
  if [ -n "$value" ]; then
    echo "Replacing ${placeholder} with ${value}..."
    find /app/.next -type f -name "*.js" -exec sed -i \
      "s|${placeholder}|${value}|g" {} +
  else
    echo "Warning: ${placeholder} has no value, skipping..."
  fi
}

echo "Replacing runtime environment variables..."

# Define your key-value pairs (placeholder -> env var)
replace_env_var "REPLACE_API_URL" "${API_URL}"
replace_env_var "REPLACE_BACKEND_URL" "${BACKEND_URL}"
# Add more as needed:
# replace_env_var "REPLACE_ANOTHER_VAR" "${ANOTHER_VAR}"
# replace_env_var "REPLACE_YET_ANOTHER" "${YET_ANOTHER}"

echo "Starting Next.js..."
exec node server.js