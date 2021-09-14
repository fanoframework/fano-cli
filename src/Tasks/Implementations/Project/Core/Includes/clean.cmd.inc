(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strClearUnitsCmd: string =
    '@echo off' + LineEnding +
    'REM ------------------------------------------------------------' + LineEnding +
    'REM [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    'REM' + LineEnding +
    'REM @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    'REM @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    'REM @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    'REM -------------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    'REM ------------------------------------------------------' + LineEnding +
    'REM Scripts to delete all compiled unit files' + LineEnding +
    'REM ------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    'FOR /R bin\unit %i IN (*) DO IF NOT %i == README.md del %i';
