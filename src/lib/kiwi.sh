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

# Helpers to work with KIWI NG

# We are guaranteed that PWD is the rebase-tools main directory
TEMPLATE="${PWD}/data/microos-template.xml"

kiwi_build_configuration() {
	TARGET_CONFIGURATION="${1}"

	sed \
		-e "s|@REBASE_CURRENT_ARCH@|x86_64|g" \
		-e "s|@REBASE_CURRENT_LOCALE@|en_US|g" \
		${TEMPLATE} > ${TARGET_CONFIGURATION}
}

kiwi_prepare() {
	MODE="${1}"
	CONFIGURATION="${2}"
	TARGET_DIR="${3}"
	shift 3
	KIWI_EXTRA_ARGS="${@}"

	# If mode is autogenerated, we need to look at the current installation
	# in order to fetch suitable repositories
	if [ "${MODE}" == "autogenerated" ]; then
		for repo in /etc/zypp/repos.d/repo-*.repo; do
			# Note: rebases are a good way to get rid of cruft, including
			# external repositories. Thus, automatically pick up only
			# repo-* repositories for now.
			# The user can pass --kiwi-add-repo= to add their favourite
			# repository.
			KIWI_EXTRA_ARGS="${KIWI_EXTRA_ARGS} --add-repo=$(grep -oe 'http.*' ${repo})" # FIXME, this is a rather lazy way to do this
		done
	fi

	kiwi --debug system prepare \
		--allow-existing-root \
		--description="${CONFIGURATION}" \
		--root="${TARGET_DIR}" \
		${KIWI_EXTRA_ARGS}
}
