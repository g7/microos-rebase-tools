#
# microos-rebase-tools
# Copyright (C) 2023  Eugenio Paolantonio <me@medesimo.eu>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

info() {
	echo "I: ${@}"
}

warning() {
	echo "W: ${@}" >&2
}

error() {
	echo "E: ${@}" >&2
	exit 1
}

download_uri() {
	URI="${1}"
	TARGET="${2}"

	case "${URI}" in
		https://*|http://*)
			# Online, we should download
			wget "${URI}" -O ${TARGET}
			;;
		*)
			# Strip eventual file://
			cp -v ${URI/file:\/\//} ${TARGET}
			;;
	esac
}

cleanups_apply() {
	TARGET_DIR="${1}"

	# Always autorelabel
	rm -f "${TARGET_DIR}/.autorelabel"
	touch "${TARGET_DIR}/etc/selinux/.autorelabel"

}

overlay_create() {
	# Creates relevant directories in /var/lib/overlay
	TARGET_DIR="${1}"

	if [[ "${TARGET_DIR}" == /.snapshots/*/snapshot ]]; then
		# FIXME this is rather ugly
		snapshot_id=${TARGET_DIR/\/.snapshots\//}
		snapshot_id=${snapshot_id/\/snapshot}

		[ -n "${snapshot_id}" ] && \
			mkdir -p /var/lib/overlay/${snapshot_id}/etc /var/lib/overlay/${snapshot_id}/work-etc || \
			true
	fi
}
