PYTHON_DIR="/var/packages/python/target/bin"
GIT_DIR="/var/packages/git/target/bin"
GIT="${GIT_DIR}/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
<<<<<<< HEAD
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
LAZYLIBRARIAN="${SYNOPKG_PKGVAR}/LazyLibrarian/LazyLibrarian.py"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"
=======
VIRTUALENV="${PYTHON_DIR}/virtualenv"
LAZYLIBRARIAN="${SYNOPKG_PKGDEST}/var/LazyLibrarian/LazyLibrarian.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"
>>>>>>> d44affc1a5e8ba9a78392acb39f2e45161c48f9b

SERVICE_COMMAND="${PYTHON} ${LAZYLIBRARIAN} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGVAR}/"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

validate_preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=git://github.com/DobyTang/LazyLibrarian.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Clone the repository for new installs or upgrades
    # Upgrades from the old package had the repo in /share/
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] || [ ! -d "${TMP_DIR}/LazyLibrarian" ]; then
<<<<<<< HEAD
        ${GIT} clone -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/DobyTang/LazyLibrarian.git} ${SYNOPKG_PKGVAR}/LazyLibrarian >> ${INST_LOG} 2>&1
=======
        ${GIT} clone -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/DobyTang/LazyLibrarian.git} ${SYNOPKG_PKGDEST}/var/LazyLibrarian
>>>>>>> d44affc1a5e8ba9a78392acb39f2e45161c48f9b
    fi

    # If nessecary, add user also to the old group
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users"
    deluser "${USER}"
}

