#!/usr/bin/env dry-wit
# (c) 2022-today Automated Computing Machinery, S.L.
#
#    This file is part of pharo-eda-sample-app.
#
#    pharo-eda-sample-app is free software: you can redistribute it and/or
#    modify it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    pharo-eda-docker-images is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with pharo-eda-sample-app.
#    If not, see <http://www.gnu.org/licenses/>.
#
# env: ADMIN_PASSWORD: The password of the admin user.
defineEnvVar ADMIN_PASSWORD MANDATORY "The password of the admin user" "${ADMIN_USER_PASSWORD}"
# env: PHAROEDA_APP_PASSWORD: The password of the user the Sample-1 uses to connect.
defineEnvVar PHAROEDA_APP_PASSWORD MANDATORY "The password of the user the Sample-1 uses to connect" "devsecret"
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
