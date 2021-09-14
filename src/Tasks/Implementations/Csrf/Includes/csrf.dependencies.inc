(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strCsrfDependencies : string =
    '    container.add(' + LineEnding +
    '        ''verifyCsrfToken'',' + LineEnding +
    '        TCsrfMiddlewareFactory.create(' + LineEnding +
    '            (container[GuidToString(IAppConfiguration)] as IAppConfiguration)' + LineEnding +
    '                .getString(''secretKey'')' + LineEnding +
    '        )' + LineEnding +
    '    );' + LineEnding +
    '' + LineEnding +
    '    (container[''appMiddlewares''] as IMiddlewareList)' + LineEnding +
    '        .add(container[''verifyCsrfToken''] as IMiddleware);' + LineEnding +
    '' + LineEnding;
