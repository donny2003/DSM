<<<<<<< HEAD
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGVAR}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
GIT="${GIT_DIR}/bin/git"
=======
PYTHON_DIR="/var/packages/python/target/bin"
GIT_DIR="/var/packages/git/target/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/virtualenv"
GIT="${GIT_DIR}/git"
>>>>>>> d44affc1a5e8ba9a78392acb39f2e45161c48f9b
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
SICKBEARD="${SYNOPKG_PKGVAR}/SickBeard/SickBeard.py"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="${PYTHON} ${SICKBEARD} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGVAR}/"

validate_preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=git://github.com/midgetspy/Sick-Beard.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone --depth 10 --recursive -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/midgetspy/Sick-Beard.git} ${SYNOPKG_PKGVAR}/SickBeard > /dev/null 2>&1
        cp ${SYNOPKG_PKGVAR}/SickBeard/autoProcessTV/autoProcessTV.cfg.sample ${SYNOPKG_PKGVAR}/SickBeard/autoProcessTV/autoProcessTV.cfg
    fi

    # If nessecary, add user also to the old group before removing it
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users"
    deluser "${USER}"
}

