(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strBuildCfgGlobalProd: string =
    '#------------------------------------------------------------' + LineEnding +
    '# [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    '#' + LineEnding +
    '# @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    '# @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    '# @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    '#--------------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# User configuration for production build' + LineEnding +
    '# Please see Free Pascal Documentation for available' + LineEnding +
    '# compiler switch configurations' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# halt compiler after error' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-Se' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Level 4 optimization' + LineEnding +
    '# Other available switch -O1, -O2, -O3' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-O4' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Move frequent-used variable in register' + LineEnding +
    '# This switch is actually redundant as this' + LineEnding +
    '# already be covered by -O3 switch.' + LineEnding +
    '# It puts here just for completeness.' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-Ooregvar' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Removing the calculation of dead values optimization' + LineEnding +
    '# this optimization is included in -O4' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-Oodeadvalues' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Use smart linking' + LineEnding +
    '# Tell linker to only link symbols that your code' + LineEnding +
    '# actually need to reduce executable size' + LineEnding +
    '# @link: https://www.freepascal.org/docs-html/prog/progse30.html' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-CX' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Link with smartlinked units' + LineEnding +
    '# This is related to -CX switch above, If you enable' + LineEnding +
    '# smart linking then smart linking process will only' + LineEnding +
    '# be carried out if this switch is enable' + LineEnding +
    '# @link: https://www.freepascal.org/docs-html/prog/progse30.html' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-XX';
