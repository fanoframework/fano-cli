@echo off
REM ------------------------------------------------------------
REM Fano CLI Application (https://fanoframework.github.io)
REM
REM @link      https://github.com/fanoframework/fano-cli
REM @copyright Copyright (c) 2018 Zamrony P. Juhara
REM @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
REM -------------------------------------------------------------

REM ------------------------------------------------------
REM Scripts to delete all compiled unit files
REM ------------------------------------------------------

FOR /R bin\unit %i IN (*) DO IF NOT %i == README.md del %i
