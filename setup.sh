#!/usr/bin/env bash

# Get the directory where the script is located
# dirname takes the path and returns the directory name
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
TS="$(date +%Y%m%d%H%M%S)"
# remove PWD from DIR
build_util_rel_dir="${DIR//${PWD}\//}"
reqs="${reqs:-"${build_util_rel_dir}/requirements.txt"}"
py="${py:-"python3"}"
venv="${venv:-".venv"}"

BACKUPS=0
function template_render() {
    local \
        util_dir \
        template \
        target
    template="${1}"
    util_dir="${2:-${build_util_rel_dir}}"
    util_dir_var="${3:-"build_util_dir"}"
    target="${PWD}/${template##*/}"
    target="${target//.j2/}"
    if [[ -r "${target}" ]]; then
        cp -p "${target}" "${target}.backup.${TS}"
        BACKUPS=$((BACKUPS + 1))
    fi
    jinja -D "${util_dir_var}" "${util_dir}" -o "${target}" "${template}"
    rc=$?
    if [[ "${rc}" -eq 0 ]]; then
        echo "FATAL: failed to render template ${template}"
        exit "${rc}"
    fi
    return "${rc}"
}

if ! command -v jinja >/dev/null 2>&1; then
    echo "FATAL: jinja cli is not installed. You can install it using the following command:"
    echo -e "\$ ${py} -m venv ${venv}; source ${venv}/bin/activate; pip install -r ${reqs}"
    exit 1
fi

while read -r template; do
    template_render "${template}" "${build_util_rel_dir}" "build_util_dir"
done < <(find "${DIR}/templates/" -type f -name "*.j2" -or -name "\.*.j2" || true)

if [[ ${BACKUPS} -gt 0 ]]; then
    echo "INFO: created ${BACKUPS} backups of existing files. list them: find . -name '*.backup.${TS}'"
fi
