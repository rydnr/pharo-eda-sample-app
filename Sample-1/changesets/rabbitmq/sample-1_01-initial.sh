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
#    pharo-eda-sample-app is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with pharo-eda-sample-app.
#    If not, see <http://www.gnu.org/licenses/>.
#
# mod: pharo-eda-sample-app/rabbitmq/sample-1_01-initial
# api: public
# txt: Creates user, queues, exchanges, etc, required by PharoEDA Sample App's Sample-1.

DW.import rabbitmq;

# fun: main
# api: public
# txt: Creates user, queues, exchanges, etc, required by PharoEDA Sample App's Sample-1.
# txt: Returns 0/TRUE always, but can exit in case of error.
# use: main
function main() {
  logDebug -n "Adding the user";
  if add_user_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_ADD_THE_USER;
  fi;

  if isNotEmpty "${SAMPLE1_TAGS}"; then
    logDebug -n "Adding the tags of ${SAMPLE1_USER}";
    if add_user_tags "${ADMIN_USER}" "${ADMIN_PASSWORD}"; then
      logDebugResult SUCCESS "done";
    else
      logDebugResult FAILURE "failed";
      logDebug "${ERROR}";
      exitWithErrorCode CANNOT_SET_THE_TAGS;
    fi
  fi

  logDebug -n "Configuring the permissions";
  if set_user_permissions; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_SET_THE_PERMISSIONS;
  fi

  logDebug -n "Declaring the exchanges";
  if declare_exchanges_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_EXCHANGES;
  fi

  logDebug -n "Declaring the dead-letter exchanges";
  if declare_deadletter_exchanges_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_DEADLETTER_EXCHANGES;
  fi

  logDebug -n "Declaring the queues";
  if declare_queues_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_QUEUES;
  fi

  logDebug -n "Declaring the dead-letter queues";
  if declare_deadletter_queues_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_DEADLETTER_QUEUES;
  fi

  logDebug -n "Declaring the audit queues";
  if declare_audit_queues_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_AUDIT_QUEUES;
  fi

  logDebug -n "Declaring the dead-letter bindings";
  if declare_deadletter_bindings_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_DEADLETTER_BINDINGS;
  fi

  logDebug -n "Declaring the audit bindings";
  if declare_audit_bindings_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_AUDIT_BINDINGS;
  fi

  logDebug -n "Setting the policies";
  if set_policies_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_SET_THE_POLICIES;
  fi
}

# fun: add_user_if_necessary
# api: public
# txt: Adds the user, if necessary.
# txt: Returns 0/TRUE if the user gets created successfully, or it already existed; 1/FALSE otherwise.
# use: if add_user_if_necessary; then
# use:   echo "User created successfully, or it already existed";
# use: fi
function add_user_if_necessary() {
  if ! userAlreadyExists "${SAMPLE1_USER}" "${RABBITMQ_NODENAME}"; then
    addUser "${SAMPLE1_USER}" "${SAMPLE1_PASSWORD}" "${RABBITMQ_NODENAME}";
  fi
}

# fun: add_user_tags acessUser accessPassword
# api: public
# txt: Adds some tags for the Sample-1 user.
# opt: accessUser: The user used to connect to the RabbitMQ instance. Optional.
# opt: accessPassword: The credentials of accessUser. Optional.
# txt: Returns 0/TRUE if the tags are added successfully; 1/FALSE otherwise.
# use: if add_user_tags admin 'secret'; then
# use:   echo "Tags added successfully";
# use: fi
function add_user_tags() {
  local _accessUser="${1}";
  local _accessPassword="${2}";

  local _oldIFS="${IFS}";
  local _tag;
  IFS="${DWIFS}";
  for _tag in ${SAMPLE1_TAGS}; do
    IFS="${_oldIFS}";
    addTagToUser "${SAMPLE1_USER}" "${_tag}" "${RABBITMQ_NODENAME}" "${_accessUser}" "${_accessPassword}";
  done;
  IFS="${_oldIFS}";
}

# fun: set_user_permissions
# api: public
# txt: Sets the user permissions.
# txt: Returns 0/TRUE if the permissions are set successfully; 1/FALSE otherwise.
# use: if set_user_permissions; then
# use:   echo "User permissions set successfully";
# use: fi
function set_user_permissions() {
  # TODO: FIX THE VIRTUALHOST
  setPermissions / "${SAMPLE1_USER}" "${SAMPLE1_CONFIGURE_PERMISSIONS}" "${SAMPLE1_WRITE_PERMISSIONS}" "${SAMPLE1_READ_PERMISSIONS}" "${RABBITMQ_NODENAME}";
}

# fun: declare_exchanges_if_necessary
# api: public
# txt: Declares the exchanges, if necessary.
# txt: Returns 0/TRUE if the exchange get created successfully, or already existed; 1/FALSE otherwise.
# use: if declare_exchanges_if_necessary; then
# use:   echo "Exchanges created successfully";
# use: fi
function declare_exchanges_if_necessary() {
  if ! exchangeAlreadyExists "${SAMPLE1_EXCHANGE_NAME}" "${SAMPLE1_EXCHANGE_TYPE}" "${RABBITMQ_NODENAME}"; then
    declareExchange "${SAMPLE1_EXCHANGE_NAME}" "${SAMPLE1_EXCHANGE_TYPE}" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}" "${SAMPLE1_EXCHANGE_DURABLE}" "${SAMPLE1_EXCHANGE_INTERNAL}";
  fi
}

# fun: declare_deadletter_exchange_if_necessary
# api: public
# txt: Declares the dead-letter exchanges, if necessary.
# txt: Returns 0/TRUE if the dead-letter exchanges are declared successfully, or they already existed; 1/FALSE otherwise.
# use: if declare_deadletter_exchanges_if_necessary; then
# use:   echo "Dead-letter exchanges created successfully, or already existed";
# use: fi
function declare_deadletter_exchanges_if_necessary() {
  if ! exchangeAlreadyExists "${SAMPLE1_DLX_NAME}" "${SAMPLE1_DLX_TYPE}" "${RABBITMQ_NODENAME}"; then
    declareExchange "${SAMPLE1_DLX_NAME}" "${SAMPLE1_DLX_TYPE}" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_queues_if_necessary
# api: public
# txt: Declares the queues, if necessary.
# txt: Returns 0/TRUE if the queues are declared successfully or already existed; 1/FALSE otherwise.
# use: if declare_queues_if_necessary; then
# use:   echo "Queues created successfully, or already existed";
# use: fi
function declare_queues_if_necessary() {
  if ! queueAlreadyExists "${SAMPLE1_QUEUE_NAME}" "${RABBITMQ_NODENAME}"; then
    declareQueue "${SAMPLE1_QUEUE_NAME}" ${SAMPLE1_QUEUE_DURABLE} "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_deadletter_queues_if_necessary
# api: public
# txt: Declares the dead-letter queues, if necessary.
# txt: Returns 0/TRUE if the dead-letter queues are declared successfully or they already existed; 1/FALSE otherwise..
# use: if declare_deadletter_queues_if_necessary; then
# use:   echo "Dead-letter queues created successfully, or already existed";
# use: fi
function declare_deadletter_queues_if_necessary() {
  if ! queueAlreadyExists "${SAMPLE1_DLQ_NAME}" "${RABBITMQ_NODENAME}"; then
    declareQueue "${SAMPLE1_DLQ_NAME}" ${SAMPLE1_DLQ_DURABLE} "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_audit_queues_if_necessary
# api: public
# txt: Declares the audit queues, if necessary.
# txt: Returns 0/TRUE if the audit queues are declared successfully, or already existed; 1/FALSE otherwise.
# use: if declare_audit_queues_if_necessary; then
# use:   echo "Audit queues created successfully, or already existed";
# use: fi
function declare_audit_queues_if_necessary() {
  if ! queueAlreadyExists "${SAMPLE1_AUDIT_TO_QUEUE_NAME}" "${RABBITMQ_NODENAME}"; then
    declareQueue "${SAMPLE1_AUDIT_TO_QUEUE_NAME}" ${SAMPLE1_AUDIT_TO_QUEUE_DURABLE} "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
  if ! queueAlreadyExists "${SAMPLE1_AUDIT_FROM_QUEUE_NAME}" "${RABBITMQ_NODENAME}"; then
    declareQueue "${SAMPLE1_AUDIT_FROM_QUEUE_NAME}" ${SAMPLE1_AUDIT_FROM_QUEUE_DURABLE} "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_deadletter_bindings_if_necessary
# api: public
# txt: Declares the dead-letter bindings, if necessary.
# txt: Returns 0/TRUE if the dead-letter bindings get created successfully, or already existed; 1/FALSE otherwise.
# use: if declare_deadletter_bindings_if_necessary; then
# use:   echo "Dead-letter bindings declared successfully, or already existed";
# use: fi
function declare_deadletter_bindings_if_necessary() {
  if ! bindingAlreadyExists "${SAMPLE1_DLX_NAME}" queue "${SAMPLE1_DLQ_NAME}" "#" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}"; then
    declareBinding "${SAMPLE1_DLX_NAME}" queue "${SAMPLE1_DLQ_NAME}" "#" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_audit_bindings_if_necessary
# api: public
# txt: Declares the audit bindings, if necessary.
# txt: Returns 0/TRUE if the audit bindings get created successfully, or already existed; 1/FALSE otherwise.
# use: if declare_audit_bindings_if_necessary; then
# use:   echo "Audit bindings declared successfully, or already existed";
# use: fi
function declare_audit_bindings_if_necessary() {
  if ! bindingAlreadyExists "${SAMPLE1_EXCHANGE_NAME}" queue "${SAMPLE1_AUDIT_FROM_QUEUE_NAME}" "#" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}"; then
    declareBinding "${SAMPLE1_EXCHANGE_FROM_NAME}" queue "${SAMPLE1_AUDIT_FROM_QUEUE_NAME}" "#" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: set_policies_if_necessary
# api: public
# txt: Sets the policies, if necessary.
# txt: Returns 0/TRUE if the policies get created successfully, or they already existed; 1/FALSE otherwise.
# use: if set_policies_if_necessary; then
# use:   echo "Policies set successfully, or they already existed";
# use: fi
function set_policies_if_necessary() {
  if ! policyAlreadyExists "${SAMPLE1_DLX_NAME}" "^${SAMPLE1_QUEUE_NAME}$" "{\"dead-letter-exchange\":\"${SAMPLE1_DLX_NAME}\"}" queues "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}"; then
    setPolicy "${SAMPLE1_DLX_NAME}" "^${SAMPLE1_QUEUE_NAME}$" "{\"dead-letter-exchange\":\"${SAMPLE1_DLX_NAME}\"}" queues "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# Script metadata

setScriptDescription "Creates user, queues, exchanges, etc, required by PharoEDA Sample App's Sample-1.";

addError CANNOT_ADD_THE_USER "Cannot add the user";
addError CANNOT_SET_THE_TAGS "Cannot set the user tags";
addError CANNOT_SET_THE_PERMISSIONS "Cannot set the user permissions";
addError CANNOT_DECLARE_THE_EXCHANGES "Cannot declare the exchanges";
addError CANNOT_DECLARE_THE_DEADLETTER_EXCHANGES "Cannot declare the dead-letter exchanges";
addError CANNOT_DECLARE_THE_QUEUES "Cannot declare the queues";
addError CANNOT_DECLARE_THE_DEADLETTER_QUEUES "Cannot declare the dead-letter queues";
addError CANNOT_DECLARE_THE_AUDIT_QUEUES "Cannot declare the audit queues";
addError CANNOT_DECLARE_THE_BINDINGS "Cannot declare the bindings";
addError CANNOT_DECLARE_THE_DEADLETTER_BINDINGS "Cannot declare the dead-letter bindings";
addError CANNOT_DECLARE_THE_AUDIT_BINDINGS "Cannot declare the audit bindings";
addError CANNOT_SET_THE_POLICIES "Cannot set the policies";

# env: ADMIN_USER: The name of the admin user.
defineEnvVar ADMIN_USER MANDATORY "The name of the admin user" "admin";
# env: ADMIN_PASSWORD: The password of the admin user.
defineEnvVar ADMIN_PASSWORD MANDATORY "The password of the admin user";

# env: SAMPLE1: The name of the PharoEDA application.
defineEnvVar SAMPLE1 MANDATORY "The name of the PharoEDA application" "Sample-1"

# env: SAMPLE1_USER: The name of the user Sample-1 uses to connect.
defineEnvVar SAMPLE1_USER MANDATORY "The name of the user Sample-1 uses to connect" "sample-1";
# env: SAMPLE1_PASSWORD: The password of the user the Sample-1 uses to connect.
defineEnvVar SAMPLE1_PASSWORD MANDATORY "The password of the user the Sample-1 uses to connect";
# env: SAMPLE1_TAGS: The tags of the user Sample-1 uses to connect.
defineEnvVar SAMPLE1_TAGS OPTIONAL "The tags of the Sample-1 user" "";
# env: SAMPLE1_CONFIGURE_PERMISSIONS: The configure permissions for the Sample-1 user.
defineEnvVar SAMPLE1_CONFIGURE_PERMISSIONS MANDATORY "The configure permissions for the Sample-1 user" ".*";
# env: SAMPLE1_WRITE_PERMISSIONS: The write permissions for the Sample-1 user.
defineEnvVar SAMPLE1_WRITE_PERMISSIONS MANDATORY "The write permissions for the Sample-1 user" ".*";
# env: SAMPLE1_READ_PERMISSIONS: The read permissions for the Sample-1 user.
defineEnvVar SAMPLE1_READ_PERMISSIONS MANDATORY "The read permissions for the Sample-1 user" ".*";
# env: SAMPLE1_QUEUE_NAME: The name of the queue Sample-1 reads from.
defineEnvVar SAMPLE1_QUEUE_NAME MANDATORY "The name of the queue Sample-1 reads from" "to-sample-1";
# env: SAMPLE1_QUEUE_DURABLE: Whether the Sample-1 queue should be durable or not.
defineEnvVar SAMPLE1_QUEUE_DURABLE MANDATORY "Whether the Sample-1 queue should be durable or not" "true";
# env: SAMPLE1_DLQ_NAME: The name of the Sample-1 dead-letter queue.
defineEnvVar SAMPLE1_DLQ_NAME MANDATORY "The name of the Sample-1 dead-letter queue" "to-sample-1-dlq";
# env: SAMPLE1_DLQ_DURABLE: Whether the Sample-1 dead-letter queue should be durable or not.
defineEnvVar SAMPLE1_DLQ_DURABLE MANDATORY "Whether the Sample-1 dead-letter queue should be durable or not" "true";
# env: SAMPLE1_AUDIT_TO_QUEUE_NAME: The name of the audit queue to Sample-1.
defineEnvVar SAMPLE1_AUDIT_TO_QUEUE_NAME MANDATORY "The name of the audit queue to Sample-1" "to-sample-1@audit";
# env: SAMPLE1_AUDIT_QUEUE_TO_DURABLE: Whether the audit queue for incoming messages to Sample-1 should be durable or not.
defineEnvVar SAMPLE1_AUDIT_QUEUE_TO_DURABLE MANDATORY "Whether the audit queue for incoming messages to Sample-1 should be durable or not" "true";
# env: SAMPLE1_AUDIT_FROM_QUEUE_NAME: The name of the audit queue for messages from Sample-1.
defineEnvVar SAMPLE1_AUDIT_FROM_QUEUE_NAME MANDATORY "The name of the audit queue for messages from Sample-1" "to-sample-1@audit";
# env: SAMPLE1_AUDIT_QUEUE_FROM_DURABLE: Whether the audit queue for outgoing messages from Sample-1 should be durable or not.
defineEnvVar SAMPLE1_AUDIT_QUEUE_FROM_DURABLE MANDATORY "Whether the audit queue for incoming messages from Sample-1 should be durable or not" "true";
# env: SAMPLE1_EXCHANGE_NAME: The name of the exchange Sample-1 writes to.
defineEnvVar SAMPLE1_EXCHANGE_NAME MANDATORY "The name of the exchange Sample-1 writes to" "from-sample-1";
# env: SAMPLE1_EXCHANGE_TYPE: The type of the exchange Sample-1 writes to.
defineEnvVar SAMPLE1_EXCHANGE_TYPE MANDATORY "The type of the exchange Sample-1 writes to" "fanout";
# env: SAMPLE1_EXCHANGE_DURABLE: Whether the Sample-1 exchange is durable or not.
defineEnvVar SAMPLE1_EXCHANGE_DURABLE MANDATORY "Whether the Sample-1 exchange is durable or not" "true";
# env: SAMPLE1_EXCHANGE_INTERNAL: Whether the Sample-1 exchange is internal or not.
defineEnvVar SAMPLE1_EXCHANGE_INTERNAL MANDATORY "Whether the Sample-1 exchange is internal or not" "false";
# env: SAMPLE1_DLX_NAME: The name of the dead-letter exchange for Sample-1.
defineEnvVar SAMPLE1_DLX_NAME MANDATORY "The name of the dead-letter exchange for Sample-1" "from-sample-1-dlx";
# env: SAMPLE1_DLX_TYPE: The type of the dead-letter exchange for Sample-1.
defineEnvVar SAMPLE1_DLX_TYPE MANDATORY "The type of the dead-letter exchange for Sample-1" "fanout";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
