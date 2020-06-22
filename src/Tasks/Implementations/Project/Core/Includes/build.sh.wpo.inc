(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strBuildShWpo: string =
    '#------------------------------------------------------------' + LineEnding +
    '# [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    '#' + LineEnding +
    '# @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    '# @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    '# @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    '#--------------------------------------------------------------' + LineEnding +
    '#!/bin/bash' + LineEnding +
    '' + LineEnding +
    '#------------------------------------------------------' + LineEnding +
    '# Build script for Linux' + LineEnding +
    '#------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    '' + LineEnding +
    'if [ -z "${FANO_DIR}" ]; then' + LineEnding +
    'export FANO_DIR="vendor/fano"' + LineEnding +
    'fi' + LineEnding +
    '' + LineEnding +
    'if [ -z "${BUILD_TYPE}" ]; then' + LineEnding +
    'export BUILD_TYPE="prod"' + LineEnding +
    'fi' + LineEnding +
    '' + LineEnding +
    'if [ -z "${USER_APP_DIR}" ]; then' + LineEnding +
    'export USER_APP_DIR="src"' + LineEnding +
    'fi' + LineEnding +
    '' + LineEnding +
    'if [ -z "${UNIT_OUTPUT_DIR}" ]; then' + LineEnding +
    '    export UNIT_OUTPUT_DIR="bin/unit"' + LineEnding +
    'fi' + LineEnding +
    '' + LineEnding +
    'if [ -z "${EXEC_OUTPUT_DIR}" ]; then' + LineEnding +
    'export EXEC_OUTPUT_DIR="[[EXEC_OUTPUT_DIR]]"' + LineEnding +
    'fi' + LineEnding +
    '' + LineEnding +
    'if [ -z "${EXEC_OUTPUT_NAME}" ]; then' + LineEnding +
    'export EXEC_OUTPUT_NAME="app.cgi"' + LineEnding +
    'fi' + LineEnding +
    '' + LineEnding +
    'if [ -z "${SOURCE_PROGRAM_NAME}" ]; then' + LineEnding +
    'export SOURCE_PROGRAM_NAME="app.pas"' + LineEnding +
    'fi' + LineEnding +
    '' + LineEnding +
    'if [ -z "${FPC_BIN}" ]; then' + LineEnding +
    'export FPC_BIN="fpc"' + LineEnding +
    'fi' + LineEnding +
    '' + LineEnding +
    'if [ -n "${BUILD_TYPE}" ] && [ "${BUILD_TYPE}" = "prodwpo" ]; then' + LineEnding +
    '${FPC_BIN} -FW${UNIT_OUTPUT_DIR}/app-pass0.wpo -OWall @${FANO_DIR}/fano.cfg @build.cfg ${USER_APP_DIR}/${SOURCE_PROGRAM_NAME}' + LineEnding +
    '${FPC_BIN} -FW${UNIT_OUTPUT_DIR}/app-pass1.wpo -OWall -Fw${UNIT_OUTPUT_DIR}/app-pass0.wpo -Owall @${FANO_DIR}/fano.cfg @build.cfg ${USER_APP_DIR}/${SOURCE_PROGRAM_NAME}' + LineEnding +
    '${FPC_BIN} -Fw${UNIT_OUTPUT_DIR}/app-pass1.wpo -Owall @${FANO_DIR}/fano.cfg @build.cfg ${USER_APP_DIR}/${SOURCE_PROGRAM_NAME}' + LineEnding +
    'else' + LineEnding +
    '${FPC_BIN} @${FANO_DIR}/fano.cfg @build.cfg ${USER_APP_DIR}/${SOURCE_PROGRAM_NAME}' + LineEnding +
    'fi' + LineEnding;
