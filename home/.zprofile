function pkg_expand() {

    # Command line tool - expands a PKG from passed arg and cds into exploded dir
    pkg_path=$(realpath "${1}" 2>/dev/null)
    exploded_pkg="/tmp/$(basename ${pkg_path} 2>/dev/null)"

    # See man zshmisc under ALTERNATE FORMS FOR COMPLEX COMMANDS
    if [[ -z $(grep "\w" <<< "${pkg_path}") ]]; echo "You must provide a valid path!" && return
    if [[ -d "${exploded_pkg}" ]]; mv "${exploded_pkg}" "${exploded_pkg/.pkg/_$(date +%s).pkg}"
    pkgutil --expand-full ${pkg_path} "${exploded_pkg}" && cd "${exploded_pkg}"
    tree -L 3 "${exploded_pkg}"

    }


function awsauth() {
    # auth to kandji aws

    if ! command -v aws >/dev/null 2>&1; then
        echo "ERROR: aws not installed."
        echo "ERROR: install via brew or other method then try again."
        return 1
    fi

    if aws sso login --profile default; then
        echo "successful auth!"
    else
        echo "check your config"
    fi
}
