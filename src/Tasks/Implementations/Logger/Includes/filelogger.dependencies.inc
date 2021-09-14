(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strLoggerDependencies : string =
    '    container.add(' + LineEnding +
    '        ''logger'',' + LineEnding +
    '        TFileLoggerFactory.create(' + LineEnding +
    '            [[BASE_DIR]] + ''/storages/logs/app.log''' + LineEnding +
    '        )' + LineEnding +
    '    );' + LineEnding +
    '' + LineEnding;
