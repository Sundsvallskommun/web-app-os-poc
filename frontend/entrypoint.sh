#!/bin/sh
# entrypoint.sh

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
echo "Running as user: $(id)"
ls -al /app/.next
ls -al /app/.next/server

replace_env_var "NEXT_PUBLIC_APP_NAME_PLACEHOLDER" "${NEXT_PUBLIC_APP_NAME}"
replace_env_var "NEXT_PUBLIC_API_URL_PLACEHOLDER" "${NEXT_PUBLIC_API_URL}"
replace_env_var "DOMAIN_NAME_PLACEHOLDER" "${DOMAIN_NAME}"
replace_env_var "/BASE_PATH_PLACEHOLDER" "${BASE_PATH}"
replace_env_var "/NEXT_PUBLIC_BASE_PATH_PLACEHOLDER" "${NEXT_PUBLIC_BASE_PATH}"
replace_env_var "ADMIN_URL_PLACEHOLDER" "${ADMIN_URL}"
replace_env_var "NEXT_PUBLIC_PROTECTED_ROUTES_PLACEHOLDER" "${NEXT_PUBLIC_PROTECTED_ROUTES}"
replace_env_var "HEALTH_USERNAME_PLACEHOLDER" "${HEALTH_USERNAME}"
replace_env_var "HEALTH_PASSWORD_PLACEHOLDER" "${HEALTH_PASSWORD}"

echo "Starting Next.js..."
exec node server.js