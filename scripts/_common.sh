#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# existing volumes index
volume_index=()
for vol in /etc/systemd/system/${app}-volume@*.service; do
    [[ -e "$vol" ]] || continue
    instance=$(basename "$vol" .service)     
    index="${instance##*@}"                  
    volume_index+=("$index")
done

# existing workers index
worker_index=()
for work in /etc/systemd/system/${app}-worker@*.service; do
    [[ -e "$work" ]] || continue
    instance=$(basename "$work" .service)     
    index="${instance##*@}"                  
    worker_index+=("$index")
done

ynh_app_upgrading_from_version_after_or_equal_to() {
    local version=$1
    [[ $version =~ '~ynh' ]] || ynh_die "Invalid argument for version, should include the ~ynhX prefix"
    dpkg --compare-versions "$YNH_APP_CURRENT_VERSION" ge "$version"
}
