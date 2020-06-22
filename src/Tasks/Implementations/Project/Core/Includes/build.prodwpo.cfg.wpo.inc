(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strBuildCfgProdWpo: string =
    '#------------------------------------------------------------' + LineEnding +
    '# [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    '#' + LineEnding +
    '# @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    '# @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    '# @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    '#--------------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# User configuration for production build with whole program optimization' + LineEnding +
    '# Please see Free Pascal Documentation for available' + LineEnding +
    '# compiler switch configurations' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# add global production config' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '#INCLUDE build.global.prod.cfg' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Do not strip all debug information and symbols' + LineEnding +
    '# from output executable because it will be needed' + LineEnding +
    '# symbol liveness when doing whole program optimization' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-Xs-';
