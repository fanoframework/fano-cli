(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strConfigSetupCmd: string =
    'REM------------------------------------------------------------' + LineEnding +
    'REM [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    'REM' + LineEnding +
    'REM @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    'REM @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    'REM @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    'REM-------------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    'REM------------------------------------------------------' + LineEnding +
    'REM Scripts to setup configuration files' + LineEnding +
    'REM------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    'IF EXIST config\config.json.sample (copy config\config.json.sample config\config.json)' + LineEnding +
    'IF EXIST config\config.ini.sample (copy config\config.ini.sample config\config.ini)' + LineEnding +
    'IF EXIST build.global.prod.cfg.sample (copy build.global.prod.cfg.sample build.global.prod.cfg)' + LineEnding +
    'IF EXIST build.prodwpo.cfg.sample (copy build.prodwpo.cfg.sample build.prodwpo.cfg)' + LineEnding +
    'copy build.prod.cfg.sample build.prod.cfg' + LineEnding +
    'copy build.dev.cfg.sample build.dev.cfg' + LineEnding +
    'copy build.cfg.sample build.cfg';
