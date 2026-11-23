#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
docker compose exec -T redis redis-cli ping
docker compose run --rm --no-deps wpcli redis status
docker compose exec -T --user 33:33 wordpress1 php -r 'require "/var/www/html/wp-load.php"; if (!wp_using_ext_object_cache() || !wp_cache_set("shared-check", "shared-ok", "practice-demo", 120)) { exit(1); } echo "wordpress1: object saved\n";'
docker compose exec -T --user 33:33 wordpress2 php -r 'require "/var/www/html/wp-load.php"; $v = wp_cache_get("shared-check", "practice-demo"); echo "wordpress2: " . $v . "\n"; wp_cache_delete("shared-check", "practice-demo"); exit($v === "shared-ok" ? 0 : 1);'
docker compose exec -T redis redis-cli DBSIZE
docker compose exec -T redis redis-cli INFO stats
