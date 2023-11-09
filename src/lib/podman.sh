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

podman_pull() {
	IMAGE="${1}"

	podman pull "${IMAGE}"
}

podman_export_to_dir() {
	IMAGE="${1}"
	TARGET_DIR="${2}"

	# To use podman export we should first create a container, but we
	# don't need to start it
	TEMP_ID=$(podman create ${IMAGE})
	podman export "${TEMP_ID}" | tar xf - -C "${TARGET_DIR}"
	podman rm ${TEMP_ID}
}
