#!/usr/bin/env bash
set -euo pipefail

api_username=admin
path_public_key=/config/keys/deeper/deeper-old.pem
secrets_key_name=deeper_password
secrets_file_location=/config/secrets.yaml

get_secrets_value() {
    local key=${1}
    local file=${2}

    sed -nE 's/^\s*'${key}': "?([^"]+)"?/\1/p' ${file}
}

encode_password() {
    local password_plain=${1}
    local public_key=${2}

    echo -n "${password_plain}" \
        | openssl rsautl -encrypt -pubin -inkey ${public_key} -oaep 2> /dev/null \
        | base64 \
        | tr -d '\n'
}

get_token() {
    local url=${1}
    local username=${2}
    local password_encoded=${3}

    curl ${api_url}/admin/login \
        -sH 'Content-Type: application/json' \
        --data-raw '{"username":"'${username}'","password":"'${password_encoded}'"}' \
        | jq ".token" -r
}

select_endpoint() {
    case "${1}" in
        balance|credit)
            stub="betanet/getBalanceAndCredit"
        ;;
        shared|consumed)
            stub="microPayment/getDailyTraffic"
        ;;
        channelBalance)
            stub="betanet/getChannelBalance"
        ;;
        deviceId | SN)
            stub="system-info/hardware-info"
        ;;        
        latestVersion | currentVersion)
            stub="system-info/get-latestversion"
        ;;              
        *)
            echo "ERROR: Unknown key" >&2
            exit 1
        ;;
    esac
    echo $stub
}

request_data() {
    local url=${1}
    local token=${2}
    local key=${3}

    curl ${url} -sH "Authorization: ${token}" \
        | jq ".${key}" -r
}

main() {
    local ip_addr=${1}
    local key_name=${2}

    endpoint=$(select_endpoint ${key_name})
    password_plain=$(get_secrets_value ${secrets_key_name} ${secrets_file_location})
    password_encoded=$(encode_password ${password_plain} ${path_public_key})
    local api_url=http://${ip_addr}/api
    token=$(get_token "${api_url}/admin/login" "${api_username}" "${password_encoded}")
    result=$(request_data "${api_url}/${endpoint}" "${token}" "${key_name}")
    echo "${result}"
}

main "${@}"

# Usage : ./deeper.sh [IP Address of Deeper Device] [key]
# 
# Keys are:
#
# balance / credit / channelBalance / 
# consumed / shared / 
# deviceId / SN /
# latestVersion / currentVersion
# 
# Credits (Thanks for the help! I couldn't have done this without you!!!)
# Zoom (Deeper Network Discord)
# keuvie (Home Assistant Discord)
# NSX (Home Assistant Discord)
