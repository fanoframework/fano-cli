#------------------------------------------------------------
# Fano CLI Application (https://fanoframework.github.io)
#
# @link      https://github.com/fanoframework/fano-cli
# @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
# @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
#-------------------------------------------------------------
#!/bin/bash

#------------------------------------------------------
# Build script for Linux
#------------------------------------------------------

BUILD_CFG=build.cfg
BUILD_DEV_CFG=build.dev.cfg
BUILD_PROD_CFG=build.prod.cfg

if [ ! -f "${BUILD_CFG}" ]; then
    cp build.cfg.sample build.cfg
fi

if [ ! -f "${BUILD_DEV_CFG}" ]; then
    cp build.dev.cfg.sample build.dev.cfg
fi

if [ ! -f "${BUILD_PROD_CFG}" ]; then
    cp build.prod.cfg.sample build.prod.cfg
fi

if [ -z "${BUILD_TYPE}" ]; then
    export BUILD_TYPE="prod"
fi

if [ -z "${UNIT_OUTPUT_DIR}" ]; then
    export UNIT_OUTPUT_DIR="bin/unit"
fi

if [ -z "${EXEC_OUTPUT_DIR}" ]; then
    export EXEC_OUTPUT_DIR="bin/out"
fi

if [ -z "${FPC_BIN}" ]; then
    export FPC_BIN="fpc"
fi

$FPC_BIN @unit.search.cfg @build.cfg src/fanocli.pas
