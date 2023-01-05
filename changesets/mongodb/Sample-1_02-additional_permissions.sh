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
# mod: pharo-eda-sample-app/mongodb/sample-1_02-additionalPermissions
# api: public
# txt: Grants read/write permissions to Sample1 user in a local MongoDB server.

DW.import mongodb
DW.import step

# fun: main
# api: public
# txt: Grants read/write permissions to Sample1 user in a local MongoDB server.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  grant_Sample1_roles
}

# fun: add_Sample1_roles
# api: public
# txt: Adds the Sample1 roles.
# txt: Returns 0/TRUE always, but can exit if the role cannot be added.
# use: add_Sample1_roles;
function grant_Sample1_roles() {
  grant_readWrite_role
}

# fun: grant_readWrite_role
# api: public
# txt: Grants the readWrite role.
# txt: Returns 0/TRUE always, but can exit if the role cannot be granted.
# use: grant_readWrite_role;
function grant_readWrite_role() {
  if ! isStepAlreadyDone GRANT_READWRITE_ROLE; then

    logDebug -n "Granting readWrite role to ${SAMPLE1_USER}"
    if grantMongodbRolesToUser \
      "${SAMPLE1_USER}" \
      "[ 'readWrite' ]" \
      "${SAMPLE1_DATABASE}" \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}"; then
      logDebugResult SUCCESS "done"
    else
      local _error="${ERROR}"
      logInfoResult FAILURE "failed"
      exitWithErrorCode CANNOT_GRANT_READWRITE_ROLE
      if ! isEmpty "${_error}"; then
        logDebug "${_error}"
      fi
    fi

    markStepAsAlreadyDone GRANT_READWRITE_ROLE
  fi
}

# Script metadata
setScriptDescription "Grants read/write permissions to Sample1 user in a local MongoDB server."

# env: SAMPLE1_DATABASE: The name of the database used by Sample1. Defaults to "sample1".
defineEnvVar SAMPLE1_DATABASE OPTIONAL "The name of the database used by Sample1" "Sample1";
# env: AUTHENTICATION_DATABASE: The authentication database. Defaults to "admin".
defineEnvVar AUTHENTICATION_DATABASE MANDATORY "The authentication database" "admin"
# env: AUTHENTICATION_MECHANISM: The authentication mechanism. Defaults to SCRAM-SHA-256.
defineEnvVar AUTHENTICATION_MECHANISM MANDATORY "The authentication mechanism" "SCRAM-SHA-1"
# env: ADMIN_USER_NAME: The MongoDB admin user. Defaults to "admin".
defineEnvVar ADMIN_USER_NAME MANDATORY "The MongoDB admin user" "admin"
# env: ENABLE_FREE_MONITORING: Whether to enable the free monitoring feature. Defaults to true.
defineEnvVar ENABLE_FREE_MONITORING MANDATORY "Whether to enable the free monitoring feature" true
# env: SAMPLE1_USER: The Sample1 user in MongoDB. Defaults to "sample1".
defineEnvVar SAMPLE1_USER OPTIONAL "The Sample1 user in MongoDB" "sample1";

addError CANNOT_GRANT_READWRITE_ROLE "Cannot add the readWrite role to ${SAMPLE1_USER}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
