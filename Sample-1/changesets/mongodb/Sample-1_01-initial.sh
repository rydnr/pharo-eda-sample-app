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
# mod: pharo-eda-sample-app/mongodb/sample-1_01-initial
# api: public
# txt: Prepares a local MongoDB server for pharo-eda-sample-app's Sample 1.

DW.import mongodb;

# fun: main
# api: public
# txt: Prepares a local MongoDB server for pharo-eda-sample-app's Sample 1.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  add_Sample1_roles;

  add_Sample1_user;

  add_indexes;
}

# fun: isStepAlreadyDone step
# api: public
# txt: Checks if given step is already done or not.
# txt: Returns 0/TRUE in such case; 1/FALSE otherwise.
# use: if isStepAlreadyOne STEP1; then ... fi
function isStepAlreadyDone() {
  local _step="${1}"
  checkNotEmpty step "${_step}" 1

  local -i _rescode=${FALSE}

  if fileExists ".${_step}"; then
    _rescode=${TRUE}
  fi

  return ${_rescode}
}

# fun: markStepAsAlreadyDone step
# api: public
# txt: Marks given step as already done.
# txt: Returns 0/TRUE if the step can be annotated; 1/FALSE otherwise.
# use: if markStepAsAlreadyOne STEP1; then ... fi
function markStepAsAlreadyDone() {
  local _step="${1}"
  checkNotEmpty step "${_step}" 1

  touch ".${_step}"
}

# fun: add_Sample1_roles
# api: public
# txt: Adds the Sample1 roles.
# txt: Returns 0/TRUE always, but can exit if the role cannot be added.
# use: add_Sample1_roles;
function add_Sample1_roles() {
  add_Book_find_role;
  add_Book_insert_role;
}

# fun: add_Book_find_role
# api: public
# txt: Adds the Book role.
# txt: Returns 0/TRUE always, but can exit if the role cannot be added.
# use: add_Book_find_role;
function add_Book_find_role() {
  if ! isStepAlreadyDone ADD_BOOKFIND_ROLE; then

    addMongodbRoleIfNecessary \
      "${BOOKFIND_ROLE}" \
      "[ { resource: { db: '${SAMPLE1_DATABASE}', collection: '${BOOK_COLLECTION}' }, actions: [ 'find'  ] } ]" \
      '[]' \
      CANNOT_ADD_BOOKFIND_ROLE \
      BOOKFIND_ROLE_DOES_NOT_EXIST \
      "${SAMPLE1_DATABASE}" \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}"

    markStepAsAlreadyDone ADD_BOOKFIND_ROLE
  fi
}

# fun: add_Book_insert_role
# api: public
# txt: Adds the Book insert role.
# txt: Returns 0/TRUE always, but can exit if the role cannot be added.
# use: add_Book_insert_role;
function add_Book_insert_role() {
  if ! isStepAlreadyDone ADD_BOOKINSERT_ROLE; then

    addMongodbRoleIfNecessary \
      "${BOOKINSERT_ROLE}" \
      "[ { resource: { db: '${SAMPLE1_DATABASE}', collection: '${BOOK_COLLECTION}' }, actions: [ 'insert' ] } ]" \
      '[]' \
      CANNOT_ADD_BOOKINSERT_ROLE \
      BOOKINSERT_ROLE_DOES_NOT_EXIST \
      "${SAMPLE1_DATABASE}" \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}"

    markStepAsAlreadyDone ADD_BOOKINSERT_ROLE
  fi
}

# fun: add_Sample1_user
# api: public
# txt: Adds the Sample1 user.
# txt: Returns 0/TRUE always, but can exit if the Sample1 user cannot be added.
# use: add_Sample1_user;
function add_Sample1_user() {
  if ! isStepAlreadyDone ADD_SAMPLE1_USER; then

    addMongodbUserIfNecessary \
      "${SAMPLE1_USER}" \
      "${SAMPLE1_PASSWORD}" \
      "${SAMPLE1_DATABASE}" \
      "[ { role: '${BOOKFIND_ROLE}', db: '${SAMPLE1_DATABASE}' },{ role: '${BOOKINSERT_ROLE}', db: '${SAMPLE1_DATABASE}' } ]" \
      CANNOT_ADD_SAMPLE1_USER \
      SAMPLE1_USER_CANNOT_LOG_IN \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}"

    markStepAsAlreadyDone ADD_SAMPLE1_USER;
  fi
}

# fun: add_indexes
# api: public
# txt: Creates the indexes.
# txt: Returns 0/TRUE always, but can exit if the any index cannot be created.
# use: add_indexes;
function add_indexes() {
  add_Book_indexes;
}

# fun: add_Book_indexes
# api: public
# txt: Creates the indexes on the Book collection.
# txt: Returns 0/TRUE always, but cat exit if any index cannot be created.
# use: add_Book_indexes;
function add_Book_indexes() {
  add_Book_Id_index;
  add_Book_Timestamp_index;
}

# fun: add_Book_Id_index
# api: public
# txt: Creates the Id index on the Book collection.
# txt: Returns 0/TRUE always, but cat exit if the index cannot be created.
# use: add_Book_Id_index;
function add_Book_Id_index() {
  if ! isStepAlreadyDone CREATE_BOOK_ID_INDEX; then

    addMongodbIndexIfNecessary \
      "id" \
      "{ id: 1 }, { name: 'id' }" \
      "${SAMPLE1_DATABASE}" \
      "${BOOK_COLLECTION}" \
      CANNOT_CREATE_BOOK_ID_INDEX \
      BOOK_ID_INDEX_DOES_NOT_EXIST \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}";

    markStepAsAlreadyDone CREATE_BOOK_ID_INDEX;
  fi
}

# fun: add_Book_Timestamp_index
# api: public
# txt: Creates the Timestamp index on the Book collection.
# txt: Returns 0/TRUE always, but cat exit if the index cannot be created.
# use: add_Book_Timestamp_index;
function add_Book_Timestamp_index() {
  if ! isStepAlreadyDone CREATE_BOOK_TIMESTAMP_INDEX; then

    addMongodbIndexIfNecessary \
      "timestamp" \
      "{ timestamp: 1 }, { name: 'timestamp' }" \
      "${SAMPLE1_DATABASE}" \
      "${BOOK_COLLECTION}" \
      CANNOT_CREATE_BOOK_TIMESTAMP_INDEX \
      EVENTSOURCINGEVENT_TIMESTAMP_INDEX_DOES_NOT_EXIST \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}";

    markStepAsAlreadyDone CREATE_BOOK_TIMESTAMP_INDEX;
  fi
}

# Script metadata
setScriptDescription "Bootstraps PharoEDA Sample App MongoDB in a local MongoDB server."

# env: SERVICE_USER: The service user. Defaults to mongodb.
defineEnvVar SERVICE_USER MANDATORY "The service user" "mongodb"
# env: SERVICE_GROUP: The service group. Defaults to mongodb.
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "mongodb"
# env: DATABASE_FOLDER: The db folder. Defaults to /backup/mongodb/db.
defineEnvVar DATABASE_FOLDER MANDATORY "The db folder" "/backup/mongodb/db"
# env: PERMISSIONS_FOLDER: The folder whose owner information is used to match the user launching mongod. Defaults to ${DATABASE_FOLDER}.
defineEnvVar PERMISSIONS_FOLDER MANDATORY "The folder whose owner information is used to match the user launching mongod" "${DATABASE_FOLDER}"
# env: CONFIG_FILE: The mongod.conf file.
defineEnvVar CONFIG_FILE MANDATORY "The mongod.conf file" "/etc/mongod.conf"
# env: DATABASE: The initial database.
defineEnvVar DATABASE MANDATORY "The initial database" "main"
# env: AUTHENTICATION_DATABASE: The authentication database. Defaults to "admin".
defineEnvVar AUTHENTICATION_DATABASE MANDATORY "The authentication database" "admin"
# env: AUTHENTICATION_MECHANISM: The authentication mechanism. Defaults to SCRAM-SHA-256.
defineEnvVar AUTHENTICATION_MECHANISM MANDATORY "The authentication mechanism" "SCRAM-SHA-256"
# env: ADMIN_USER_NAME: The MongoDB admin user. Defaults to "admin".
defineEnvVar ADMIN_USER_NAME MANDATORY "The MongoDB admin user" "admin"
# env: ENABLE_FREE_MONITORING: Whether to enable the free monitoring feature. Defaults to true.
defineEnvVar ENABLE_FREE_MONITORING MANDATORY "Whether to enable the free monitoring feature" true
# env: BACKUP_ROLE_NAME: The name of the MongoDB role used for backups. Defaults to "backupRestore".
defineEnvVar BACKUP_ROLE_NAME MANDATORY "The name of the MongoDB role used for backups" "backupRestore"
# env: BACKUP_ROLE_SPEC: The role specification of the backup user. Defaults to "[ \"${BACKUP_ROLE_NAME}\" ]".
defineEnvVar BACKUP_ROLE_SPEC MANDATORY "The role specification of the backup user" "[ \"${BACKUP_ROLE_NAME}\" ]"
# env: BACKUP_USER_NAME: The MongoDB backup user. Defaults to "backup".
defineEnvVar BACKUP_USER_NAME MANDATORY "The MongoDB backup user" "backup"
# env: START_TIMEOUT: How long to wait for mongod to start.
defineEnvVar START_TIMEOUT MANDATORY "How long to wait for mongod to start" 60
# env: START_CHECK_INTERVAL: How long till we check if mongod is running.
defineEnvVar START_CHECK_INTERVAL MANDATORY "How long till we check if mongod is running" 5
# env: LOCK_FILE: The file to lock the bootstrap process. Defaults to ${DATABASE_FOLDER}/.bootstrap-lock.
defineEnvVar LOCK_FILE MANDATORY "The file to lock the bootstrap process" "${DATABASE_FOLDER}/.bootstrap-lock"
# env: BOOTSTRAP_FILE: The file that indicates if the MongoDB instance has been already bootstrapped";
defineEnvVar BOOTSTRAP_FILE MANDATORY "The file that indicates if the MongoDB instance has been already bootstrapped" "${DATABASE_FOLDER}/.bootstrapped"
# env: SAMPLE1_USER: The Sample1 user in MongoDB. Defaults to "sample1".
defineEnvVar SAMPLE1_USER OPTIONAL "The Sample1 user in MongoDB" "sample1";
# env: SAMPLE1_PASSWORD: The password of the Sample1 user.
defineEnvVar SAMPLE1_PASSWORD MANDATORY "The password of the sample1 user";
# env: SAMPLE1_DATABASE: The name of the database used by Sample1. Defaults to "sample1".
defineEnvVar SAMPLE1_DATABASE OPTIONAL "The name of the database used by Sample1" "Sample1";
# env: BOOK_COLLECTION: The Book collection in Sample1 database.
defineEnvVar BOOK_COLLECTION OPTIONAL "The Book collection in Sample1 database" 'Book';
# env: BOOKFIND_ROLE: The role to view the Book collection in Sample1 database.
defineEnvVar BOOKFIND_ROLE OPTIONAL "The role to view the Book collection in Sample1 database" "${BOOK_COLLECTION}Find";
# env: BOOKINSERT_ROLE: The role to insert documents in the Book collection in Sample1 database.
defineEnvVar BOOKINSERT_ROLE OPTIONAL "The role to insert documents in the Book collection in Sample1 database" "${BOOK_COLLECTION}Insert";

addError CANNOT_ADD_BOOKFIND_ROLE "Cannot add the ${BOOKFIND_ROLE} role";
addError BOOKFIND_ROLE_DOES_NOT_EXIST "${BOOKFIND_ROLE} role does not exist";
addError CANNOT_ADD_BOOKINSERT_ROLE "Cannot add the ${BOOKINSERT_ROLE} role";
addError BOOKINSERT_ROLE_DOES_NOT_EXIST "${BOOKINSERT} role does not exist";
addError CANNOT_ADD_SAMPLE1_USER "Cannot add the ${SAMPLE1_USER} user";
addError SAMPLE1_USER_CANNOT_LOG_IN "Sample1 user cannot log in";
addError CANNOT_CREATE_BOOK_ID_INDEX "Cannot create an index on 'id' in ${BOOK_COLLECTION}";
addError BOOK_ID_INDEX_DOES_NOT_EXIST "The index on attribute 'id' on ${BOOK_COLLECTION} does not exist";
addError CANNOT_CREATE_BOOK_TIMESTAMP_INDEX "Cannot create an index on 'timestamp' in ${BOOK_COLLECTION}";
addError BOOK_TIMESTAMP_INDEX_DOES_NOT_EXIST "The index on attribute 'timestamp' on ${BOOK_COLLECTION} does not exist";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
