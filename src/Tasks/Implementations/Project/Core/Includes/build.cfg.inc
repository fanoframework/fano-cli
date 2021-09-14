(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strBuildCfg: string =
    '#------------------------------------------------------------' + LineEnding +
    '# [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    '#' + LineEnding +
    '# @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    '# @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    '# @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    '#--------------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# User configuration that applies to both' + LineEnding +
    '# development and production environment' + LineEnding +
    '# Please see Free Pascal Documentation for available' + LineEnding +
    '# compiler configurations' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Target OS' + LineEnding +
    '# linux : Linux' + LineEnding +
    '# win64 : Windows 64-bit' + LineEnding +
    '# win32 : Windows 32-bit' + LineEnding +
    '# freebsd : FreeBSD' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-Tlinux' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Output Windows console application' + LineEnding +
    '#' + LineEnding +
    '# Uncomment if target OS is Windows' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '#-WC' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Target CPU' + LineEnding +
    '# x86_64 : Intel 64-bit architecture (default)' + LineEnding +
    '# i386 : Intel 32-bit architecture' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '#-Px86_64' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Application Unit search path' + LineEnding +
    '# USER_APP_DIR is contains user application base directory' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-Fu$USER_APP_DIR$/Dependencies' + LineEnding +
    '-Fu$USER_APP_DIR$/Routes' + LineEnding +
    '-Fu$USER_APP_DIR$/App' + LineEnding +
    '#-Fu$USER_APP_DIR$/path/to/other/units' + LineEnding +
    '#-Fu$USER_APP_DIR$/path/to/other/units' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Application include search path' + LineEnding +
    '# USER_APP_DIR is contains user application base directory' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '-Fi$USER_APP_DIR$/Dependencies' + LineEnding +
    '-Fi$USER_APP_DIR$/Routes/home' + LineEnding +
    '#-Fu$USER_APP_DIR$/path/to/other/include/files' + LineEnding +
    '' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '# Include configuration based on build type (default is prod)' + LineEnding +
    '# using #INCLUDE directive' + LineEnding +
    '# For example' + LineEnding +
    '# $ BUILD_TYPE=prod ./build.sh' + LineEnding +
    '#----------------------------------------------' + LineEnding +
    '#INCLUDE build.$BUILD_TYPE$.cfg';
