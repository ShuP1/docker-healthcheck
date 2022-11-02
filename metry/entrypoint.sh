#!/usr/bin/env bash

# InfluxDB variables
influxdb_proto=${INFLUXDB_PROTO:-http}
influxdb_host=${INFLUXDB_HOST:-influxdb}
influxdb_port=${INFLUXDB_PORT:-8086}
influxdb_db=${INFLUXDB_DB:-metrics}
influxdb_user=${INFLUXDB_USER:-user}
influxdb_pwd=${INFLUXDB_PWD}
interval=${WAIT_INTERVAL}

influxdb_url="${influxdb_proto}://${influxdb_host}:${influxdb_port}"

nextcloud_host=${NEXTCLOUD_HOST}
nextcloud_user=${NEXTCLOUD_USER:-user}
nextcloud_pwd=${NEXTCLOUD_PWD}

nextcloud_st_url="https://${nextcloud_host}/ocs/v2.php/apps/serverinfo/api/v1/info?format=json"
nextcloud_dk_url="https://${nextcloud_host}/ocs/v2.php/apps/serverinfo/api/v1/diskdata?format=json"

while true
do
    # Run speedtest & store result
    speed_result=$(speedtest -f json --accept-license --accept-gdpr)

    # Extract data from speedtest result
    result_id=$(echo "${speed_result}" | jq -r '.result.id')
    ping_latency=$(echo "${speed_result}" | jq -r '.ping.latency')
    download_bandwidth=$(echo "${speed_result}" | jq -r '.download.bandwidth')
    upload_bandwidth=$(echo "${speed_result}" | jq -r '.upload.bandwidth')

    # Write speed to InfluxDB
    curl \
        -H "Authorization: Token ${influxdb_user}:${influxdb_psd}" \
        -d "speedtest,result_id=${result_id} ping_latency=${ping_latency},download_bandwidth=${download_bandwidth},upload_bandwidth=${upload_bandwidth}" \
        "${influxdb_url}/write?db=${influxdb_db}"

    # Run nextcloud status
    next_result=$(curl -u ${nextcloud_user}:${nextcloud_pwd} "${nextcloud_st_url}" | sed -e 's/\\/\//g')
    db_size=$(echo "${next_result}" | jq -r '.ocs.data.server.database.size')
    active_users=$(echo "${next_result}" | jq -r '.ocs.data.activeUsers.last5minutes')
    files=$(echo "${next_result}" | jq -r '.ocs.data.nextcloud.storage.num_files')
    freespace=$(echo "${next_result}" | jq -r '.ocs.data.nextcloud.system.freespace')

    # Write next to InfluxDB
    curl \
        -H "Authorization: Token ${influxdb_user}:${influxdb_psd}" \
        -d "nextcloud db_size=${db_size},active_users=${active_users},files=${files},freespace=${freespace}" \
        "${influxdb_url}/write?db=${influxdb_db}"

    # Run disks usage
    disk_result=$(curl -u ${nextcloud_user}:${nextcloud_pwd} -H "OCS-APIREQUEST: true" "${nextcloud_dk_url}")
    disk_i=0
    disk_vals=""
    for disk in $(echo "${disk_result}" | jq -r '.ocs.data[][]')
    do
        disk_vals+=$((($disk_i % 2)) && echo "free" || echo "used")
        disk_vals+="$(($disk_i / 2))=${disk},"
        disk_i=$(($disk_i + 1))
    done

    # Write disks to InfluxDB
    curl \
        -H "Authorization: Token ${influxdb_user}:${influxdb_psd}" \
        -d "disks ${disk_vals::-1}" \
        "${influxdb_url}/write?db=${influxdb_db}"

    sleep "${interval}"
done
