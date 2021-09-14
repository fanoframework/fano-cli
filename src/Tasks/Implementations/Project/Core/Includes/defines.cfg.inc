(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strDefinesCfg: string =
    '#------------------------------------------------------------' + LineEnding +
    '# [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    '#' + LineEnding +
    '# @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    '# @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    '# @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    '#--------------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# User configuration defines that applies to both' + LineEnding +
    '# development and production environment' + LineEnding +
    '# Please see Free Pascal Documentation for available' + LineEnding +
    '# compiler configurations' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Add $DEFINE LIBMICROHTTPD' + LineEnding +
    '# Link with libmicrohttpd' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '#-dLIBMICROHTTPD' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Add $DEFINE LIBCURL' + LineEnding +
    '# Link with libcurl' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '#-dLIBCURL' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Add $DEFINE USE_INDY' + LineEnding +
    '# Use Indy library with Fano Framework' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '#-dUSE_INDY' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Add $DEFINE USE_SYNAPSE' + LineEnding +
    '# Use Synapse library with Fano Framework' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '#-dUSE_SYNAPSE' + LineEnding +
    '' + LineEnding;
