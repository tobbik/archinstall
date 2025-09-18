source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} pacoloco

echo "Backup original pacoloco.yaml config file"
cp -v /etc/pacoloco.yaml /etc/pacoloco-orig.yaml

if [[ ! -z ${PACOLOCODATADIR} ]]; then
  echo "Define ${PACOLOCODATADIR} as cache directory and add US mirror"
  sed -i /etc/pacoloco.yaml \
      -e "s|^.*cache_dir.*$|cache_dir: ${PACOLOCODATADIR}|" \
      -e "s|http.*lty.*|https://america.mirror.pkgbuild.com|"
fi
cat > /etc/pacoloco.yaml << EOPACOLOCOCONF
cache_dir: ${PACOLOCODATADIR}
# port: 9129
download_timeout: 3600     ## downloads will timeout if not completed after 3600 sec, 0 to disable timeout
purge_files_after: 2592000 ## purge file after 30 days
# set_timestamp_to_logs: true ## uncomment to add timestamp, useful if pacoloco is being ran through docker

repos:
EOPACOLOCOCONF

for REPO in "${PACOLOCOREPOS[@]}"; do
  echo "${REPO}" >> /etc/pacoloco.yaml
done

cat >> /etc/pacoloco.yaml << EOPACOLOCO2CONF
## Local/3rd party repos can be added following the below example:
#  quarry:
#    http_proxy: http://bar.company.com:8989 ## Proxy could be enabled per-repo, shadowing the global `http_proxy` (see below)
#    url: http://pkgbuild.com/~anatolik/quarry/x86_64

# prefetch: ## optional section, add it if you want to enable prefetching
#  cron: 0 0 3 * * * * ## standard cron expression (https://en.wikipedia.org/wiki/Cron#CRON_expression) to define how frequently prefetch, see https://github.com/gorhill/cronexpr#implementation for documentation.
#  ttl_unaccessed_in_days: 30  ## defaults to 30, set it to a higher value than the number of consecutive days you don't update your systems
    ## It deletes and stops prefetching packages (and db links) when not downloaded after "ttl_unaccessed_in_days" days that it has been updated.
#  ttl_unupdated_in_days: 300 ## defaults to 300, it deletes and stops prefetching packages which haven't been either updated upstream or requested for "ttl_unupdated_in_days".
# http_proxy: http://proxy.company.com:8888 ## Enable this if you have pacoloco running behind a proxy
# user_agent: Pacoloco/1.2
EOPACOLOCO2CONF

enable_service pacoloco.service
