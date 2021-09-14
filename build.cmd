@echo off
REM ------------------------------------------------------------
REM Fano CLI Application (https://fanoframework.github.io)
REM
REM @link      https://github.com/fanoframework/fano-cli
REM @copyright Copyright (c) 2018 Zamrony P. Juhara
REM @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
REM -------------------------------------------------------------

REM ------------------------------------
REM -- build script for Windows
REM ------------------------------------

IF NOT EXIST build.cfg (copy build.cfg.sample build.cfg)
IF NOT EXIST build.dev.cfg (copy build.dev.cfg.sample build.dev.cfg)
IF NOT EXIST build.prod.cfg (copy build.prod.cfg.sample build.prod.cfg)

IF NOT DEFINED BUILD_TYPE (SET BUILD_TYPE=prod)
IF NOT DEFINED UNIT_OUTPUT_DIR (SET UNIT_OUTPUT_DIR=bin\unit)
IF NOT DEFINED EXEC_OUTPUT_DIR (SET EXEC_OUTPUT_DIR=bin\out)
IF NOT DEFINED FPC_BIN (SET FPC_BIN=fpc)

%FPC_BIN% @unit.search.cfg @build.cfg src/fanocli.pas
