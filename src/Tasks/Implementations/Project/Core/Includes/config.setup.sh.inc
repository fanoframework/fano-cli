(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strConfigSetupSh: string =
    '#------------------------------------------------------------' + LineEnding +
    '# [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    '#' + LineEnding +
    '# @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    '# @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    '# @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    '#--------------------------------------------------------------' + LineEnding +
    '#!/bin/bash' + LineEnding +
    '' + LineEnding +
    '#------------------------------------------------------' + LineEnding +
    '# Scripts to setup configuration files' + LineEnding +
    '#------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    'if [ -f config/config.json.sample ]; then' + LineEnding +
    '    cp config/config.json.sample config/config.json' + LineEnding +
    'fi' + LineEnding +
    'if [ -f config/config.ini.sample ]; then' + LineEnding +
    '    cp config/config.ini.sample config/config.ini' + LineEnding +
    'fi' + LineEnding +
    'if [ -f build.global.prod.cfg.sample ]; then' + LineEnding +
    '    cp build.global.prod.cfg.sample build.global.prod.cfg' + LineEnding +
    'fi' + LineEnding +
    'if [ -f build.prodwpo.cfg.sample ]; then' + LineEnding +
    '    cp build.prodwpo.cfg.sample build.prodwpo.cfg' + LineEnding +
    'fi' + LineEnding +
    'cp build.prod.cfg.sample build.prod.cfg' + LineEnding +
    'cp build.dev.cfg.sample build.dev.cfg' + LineEnding +
    'cp build.cfg.sample build.cfg';
