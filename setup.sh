#!/bin/sh
set -eu
cd "$(dirname "$0")"
if [ ! -f .env ]; then
  echo "Скопируйте .env.example в .env и задайте пароли."
  exit 1
fi
docker compose config --quiet
docker compose up -d --wait
docker compose run --rm --no-deps --entrypoint sh wpcli -ec '
  if ! wp core is-installed; then
    wp core install --url="$WP_PUBLIC_URL" --title="Практика Docker — WordPress" \
      --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" \
      --admin_email="$WP_ADMIN_EMAIL" --skip-email
  fi
  page_id=$(wp post list --post_type=page --name=docker-test --field=ID)
  if [ -z "$page_id" ]; then
    wp post create --post_type=page --post_status=publish \
      --post_name=docker-test --post_title="Тестовая страница 1" \
      --post_content=""
  fi
  page2_id=$(wp post list --post_type=page --name=test-page-2 --field=ID)
  if [ -z "$page2_id" ]; then
    wp post create --post_type=page --post_status=publish \
      --post_name=test-page-2 --post_title="Тестовая страница 2" --post_content=""
  fi
  wp eval-file /scripts/setup-pages.php
'
