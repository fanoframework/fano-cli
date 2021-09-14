(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strBuildCmd: string =
    '@echo off' + LineEnding +
    'REM ------------------------------------------------------------' + LineEnding +
    'REM [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    'REM' + LineEnding +
    'REM @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    'REM @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    'REM @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    'REM -------------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    'REM ------------------------------------' + LineEnding +
    'REM -- build script for Windows' + LineEnding +
    'REM ------------------------------------' + LineEnding +
    '' + LineEnding +
    'IF NOT DEFINED FANO_DIR (SET FANO_DIR=vendor\fano)' + LineEnding +
    'IF NOT DEFINED BUILD_TYPE (SET BUILD_TYPE=prod)' + LineEnding +
    'IF NOT DEFINED USER_APP_DIR (SET USER_APP_DIR=src)' + LineEnding +
    'IF NOT DEFINED UNIT_OUTPUT_DIR (SET UNIT_OUTPUT_DIR=bin\unit)' + LineEnding +
    'IF NOT DEFINED EXEC_OUTPUT_DIR (SET EXEC_OUTPUT_DIR=[[EXEC_OUTPUT_DIR]])' + LineEnding +
    'IF NOT DEFINED EXEC_OUTPUT_NAME (SET EXEC_OUTPUT_NAME=app.cgi)' + LineEnding +
    'IF NOT DEFINED SOURCE_PROGRAM_NAME (SET SOURCE_PROGRAM_NAME=app.pas)' + LineEnding +
    'IF NOT DEFINED FPC_BIN (SET FPC_BIN=fpc)' + LineEnding +
    '' + LineEnding +
    '%FPC_BIN% @vendor\fano\fano.cfg @build.cfg %USER_APP_DIR%\%SOURCE_PROGRAM_NAME%';
