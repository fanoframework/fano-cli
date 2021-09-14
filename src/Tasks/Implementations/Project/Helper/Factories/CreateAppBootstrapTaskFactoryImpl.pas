(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateAppBootstrapTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf,
    TextFileCreatorIntf,
    ContentModifierIntf;

type

    (*!--------------------------------------
     * interface for factory Task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateAppBootstrapTaskFactory = class abstract (TInterfacedObject, ITaskFactory)
    private
        function buildDbAppBootstrap(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;
        function buildAppBootstrap(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildWithCsrfAppBootstrap(
            const prjTask : ITask
        ) : ITask;

    protected
        function buildBootstrapTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask; virtual; abstract;
    public
        function build() : ITask;
    end;

implementation

uses

    TextFileCreatorImpl,
    ContentModifierImpl,
    NullTaskImpl,
    CompositeSessionTaskImpl,
    CompositeSessionTypeTaskImpl,
    CompositeFileTypeTaskImpl,
    JsonFileSessionContentModifierImpl,
    IniFileSessionContentModifierImpl,
    JsonCookieSessionContentModifierImpl,
    IniCookieSessionContentModifierImpl,
    NamedCompositeTaskImpl,
    CompositeDbTypeTaskImpl,
    MysqlDbSessionContentModifierImpl,
    PostgresqlDbSessionContentModifierImpl,
    FirebirdDbSessionContentModifierImpl,
    SqliteDbSessionContentModifierImpl,
    WithCsrfTaskImpl,
    ForceConfigSessionDecoratorTaskImpl;

    function TCreateAppBootstrapTaskFactory.buildDbAppBootstrap(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var taskArr : TNamedTaskArr;
    begin
        setLength(taskArr, 4);

        taskArr[0].name := 'mysql';
        taskArr[0].task := buildBootstrapTask(
            textFileCreator,
            TMysqlDbSessionContentModifier.create(contentModifier)
        );

        taskArr[1].name := 'postgresql';
        taskArr[1].task := buildBootstrapTask(
            textFileCreator,
            TPostgresqlDbSessionContentModifier.create(contentModifier)
        );

        taskArr[2].name := 'firebird';
        taskArr[2].task := buildBootstrapTask(
            textFileCreator,
            TFirebirdDbSessionContentModifier.create(contentModifier)
        );

        taskArr[3].name := 'sqlite';
        taskArr[3].task := buildBootstrapTask(
            textFileCreator,
            TSqliteDbSessionContentModifier.create(contentModifier)
        );

        result := TCompositeDbTypeTask.create(taskArr);
    end;

    function TCreateAppBootstrapTaskFactory.buildAppBootstrap(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    begin
        result := TCompositeSessionTask.create(
            //run this task when --with-session parameter is set
            TCompositeSessionTypeTask.create(

                //run this task if session use file as storage
                TCompositeFileTypeTask.create(
                    //json file session
                    buildBootstrapTask(
                        textFileCreator,
                        TJsonFileSessionContentModifier.create(contentModifier)
                    ),
                    //json ini file session
                    buildBootstrapTask(
                        textFileCreator,
                        TIniFileSessionContentModifier.create(contentModifier)
                    )
                ),

                //run this task if session use cookie as storage
                TCompositeFileTypeTask.create(
                    //json cookie session
                    buildBootstrapTask(
                        textFileCreator,
                        TJsonCookieSessionContentModifier.create(contentModifier)
                    ),
                    //ini cookie session
                    buildBootstrapTask(
                        textFileCreator,
                        TIniCookieSessionContentModifier.create(contentModifier)
                    )
                ),
                //run this task when session use database as storage
                buildDbAppBootstrap(textFileCreator, contentModifier)
            ),
            //run this task when --with-session parameter is not set
            buildBootstrapTask(textFileCreator, contentModifier)
        );
    end;

    function TCreateAppBootstrapTaskFactory.buildWithCsrfAppBootstrap(
        const prjTask : ITask
    ) : ITask;
    begin
        result := TWithCsrfTask.create(
            //if --with-csrf parameter is set, force add --config and --with-session
            TForceConfigSessionDecoratorTask.create(prjTask),
            prjTask
        );
    end;

    function TCreateAppBootstrapTaskFactory.build() : ITask;
    var textFileCreator : ITextFileCreator;
        contentModifier : IContentModifier;
    begin
        textFileCreator := TTextFileCreator.create();
        try
            contentModifier := TContentModifier.create();
            try
                try
                    result := buildWithCsrfAppBootstrap(
                        buildAppBootstrap(textFileCreator, contentModifier)
                    );
                except
                    result := nil;
                end;
            finally
                contentModifier := nil;
            end;
        finally
            textFileCreator := nil;
        end;
    end;
end.
