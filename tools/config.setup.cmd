@echo off
REM ------------------------------------------------------------
REM Fano CLI Application (https://fanoframework.github.io)
REM
REM @link      https://github.com/fanoframework/fano-cli
REM @copyright Copyright (c) 2018 Zamrony P. Juhara
REM @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
REM -------------------------------------------------------------

REM ------------------------------------------------------
REM Scripts to setup configuration files
REM ------------------------------------------------------

copy build.prod.cfg.sample build.prod.cfg
copy build.dev.cfg.sample build.dev.cfg
copy build.cfg.sample build.cfg
