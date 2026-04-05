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

function openbranch() {
    # Gets the current git repo url and and current branch then opens to that branch with favorite browser.
    open $(git config --get remote.origin.url | sed 's/.git$//')/tree/$(git branch --show-current)
}
