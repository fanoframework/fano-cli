(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strImplDbSqliteDispatcherMethod : string =
    '    function TAppServiceProvider.buildDispatcher(' + LineEnding +
    '        const container : IDependencyContainer;' + LineEnding +
    '        const routeMatcher : IRouteMatcher;' + LineEnding +
    '        const config : IAppConfiguration' + LineEnding +
    '    ) : IDispatcher;' + LineEnding +
    '    begin' + LineEnding +
    '        container.add(''db'', TSqliteDbFactory.create(' + LineEnding +
    '            config.getString(''db.db'')' + LineEnding +
    '        ));' + LineEnding +
    '' + LineEnding +
    '        container.add(''appMiddlewares'', TMiddlewareListFactory.create());' + LineEnding +
    '' + LineEnding +
    '        container.add(' + LineEnding +
    '            ''sessionManager'',' + LineEnding +
    '            TJsonDbSessionManagerFactory.create(' + LineEnding +
    '                container[''db''] as IRdbms,' + LineEnding +
    '                config.getString(''session.name'')' + LineEnding +
    '            ).table(config.getString(''session.tableName''))' + LineEnding +
    '               .sessionIdColumn(config.getString(''session.sessionIdColumn''))' + LineEnding +
    '               .dataColumn(config.getString(''session.dataColumn''))' + LineEnding +
    '               .expiredAtColumn(config.getString(''session.expiredAtColumn''))' + LineEnding +
    '        );' + LineEnding +
    '        container.alias(GuidToString(ISessionManager), ''sessionManager'');' + LineEnding +
    '' + LineEnding +
    '        container.add(' + LineEnding +
    '            GuidToString(IDispatcher),' + LineEnding +
    '            TSessionDispatcherFactory.create(' + LineEnding +
    '                container[''appMiddlewares''] as IMiddlewareLinkList,' + LineEnding +
    '                routeMatcher,' + LineEnding +
    '                TRequestResponseFactory.create(),' + LineEnding +
    '                container[''sessionManager''] as ISessionManager,' + LineEnding +
    '                (TCookieFactory.create()).domain(' + LineEnding +
    '                    config.getString(''cookie.domain'')' + LineEnding +
    '                ),' + LineEnding +
    '                config.getInt(''cookie.maxAge'')' + LineEnding +
    '            )' + LineEnding +
    '        );' + LineEnding +
    '        result := container[GuidToString(IDispatcher)] as IDispatcher;' + LineEnding +
    '    end;' + LineEnding;
