(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateProjectDependenciesTaskFactoryImpl;

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
     * Helper factory class for create project dependency task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateProjectDependenciesTaskFactory = class(TInterfacedObject, ITaskFactory)
    private
        function buildCompilerConfigsTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildConfigProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildDbConfig(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildSessionConfigProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildSessionProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildMiddlewareProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildBasicProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildWithCsrfProjectTask(
            const prjTask : ITask;
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildWithLoggerProjectTask(
            const prjTask : ITask;
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;

        function buildProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask;
    public
        function build() : ITask;
    end;

implementation

uses

    FileContentReaderIntf,
    FileContentWriterIntf,
    NullTaskImpl,
    DirectoryCreatorImpl,
    TextFileCreatorImpl,
    ContentModifierImpl,
    CreateCompilerConfigsTaskImpl,
    CreateCurlCompilerConfigsTaskImpl,
    CreateAppConfigsTaskImpl,
    CreateSessionJsonAppConfigsTaskImpl,
    CreateSessionIniAppConfigsTaskImpl,
    CreateDbSessionJsonAppConfigsTaskImpl,
    CreateDbSessionIniAppConfigsTaskImpl,
    CreateSessionAppConfigsTaskImpl,
    CreateFileSessionDependenciesTaskImpl,
    CompositeSessionTypeTaskImpl,
    CompositeSessionTaskImpl,
    CreateShellScriptsTaskImpl,
    RegisterConfigDependencyTaskImpl,
    CreateConfigMethodTaskImpl,
    FileHelperAppendImpl,
    FileHelperImpl,
    GroupTaskImpl,
    CompositeTaskImpl,
    BasicKeyGeneratorImpl,
    WithSessionOrMiddlewareTaskImpl,
    CreateMiddlewareDependenciesTaskImpl,
    CreateNoMiddlewareDependenciesTaskImpl,
    CreateSessionDirTaskImpl,
    ForceConfigDecoratorTaskImpl,
    WithDbSessionTaskImpl,
    NamedCompositeTaskImpl,
    CompositeDbTypeTaskImpl,
    MysqlDbSessionContentModifierImpl,
    PostgresqlDbSessionContentModifierImpl,
    FirebirdDbSessionContentModifierImpl,
    SqliteDbSessionContentModifierImpl,

    WithCsrfTaskImpl,
    CreateCsrfMiddlewareDependenciesTaskImpl,
    ForceConfigSessionDecoratorTaskImpl,

    WithLoggerTaskImpl,
    CompositeLoggerDependenciesTaskImpl,
    CreateFileLoggerDependenciesTaskImpl,
    CreateSyslogLoggerDependenciesTaskImpl,
    CreateDbLoggerDependenciesTaskImpl;

    function TCreateProjectDependenciesTaskFactory.buildCompilerConfigsTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var aReader : IFileContentReader;
        aWriter : IFileContentWriter;
    begin
        aReader := TFileHelper.create();
        aWriter := aReader as IFileContentWriter;
        //wrap so that when --with-curl is set, it will enable -dLIBCURL
        result := TCreateCurlCompilerConfigsTask.create(
            TCreateCompilerConfigsTask.create(textFileCreator, contentModifier),
            aReader,
            aWriter
        );
    end;

    function TCreateProjectDependenciesTaskFactory.buildConfigProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var fileReader : IFileContentReader;
    begin
        fileReader := TFileHelperAppender.create();
        result := TGroupTask.create([
            //task that add buildConfig() method
            TCreateConfigMethodTask.create(
                textFileCreator,
                contentModifier,
                fileReader
            ),
            TRegisterConfigDependencyTask.create(
                textFileCreator,
                contentModifier,
                fileReader
            )
        ]);
    end;

    function TCreateProjectDependenciesTaskFactory.buildDbConfig(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var taskArr : TNamedTaskArr;
    begin
        setLength(taskArr, 4);

        taskArr[0].name := 'mysql';
        taskArr[0].task := TCreateDbSessionJsonAppConfigsTask.create(
            textFileCreator,
            TMysqlDbSessionContentModifier.create(contentModifier),
            TBasicKeyGenerator.create()
        );

        taskArr[1].name := 'postgresql';
        taskArr[1].task := TCreateDbSessionJsonAppConfigsTask.create(
            textFileCreator,
            TPostgresqlDbSessionContentModifier.create(contentModifier),
            TBasicKeyGenerator.create()
        );

        taskArr[2].name := 'firebird';
        taskArr[2].task := TCreateDbSessionJsonAppConfigsTask.create(
            textFileCreator,
            TFirebirdDbSessionContentModifier.create(contentModifier),
            TBasicKeyGenerator.create()
        );

        taskArr[3].name := 'sqlite';
        taskArr[3].task := TCreateDbSessionJsonAppConfigsTask.create(
            textFileCreator,
            TSqliteDbSessionContentModifier.create(contentModifier),
            TBasicKeyGenerator.create()
        );

        result := TCompositeDbTypeTask.create(taskArr);
    end;

    function TCreateProjectDependenciesTaskFactory.buildSessionConfigProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var jsonCfgTask : ITask;
        iniCfgTask : ITask;
    begin
        //setup JSON format config
        jsonCfgTask := TWithDbSessionTask.create(
            //this is for --with-session=db
            buildDbConfig(textFileCreator, contentModifier),
            TCreateSessionJsonAppConfigsTask.create(
                textFileCreator,
                contentModifier,
                TBasicKeyGenerator.create()
            )
        );

        //setup INI format config
        iniCfgTask := TWithDbSessionTask.create(
            //this is for --with-session=db
            TCreateDbSessionIniAppConfigsTask.create(
                textFileCreator,
                contentModifier,
                TBasicKeyGenerator.create()
            ),
            TCreateSessionIniAppConfigsTask.create(
                textFileCreator,
                contentModifier,
                TBasicKeyGenerator.create()
            )
        );

        //force --config always set if --with-session is set
        result := TForceConfigDecoratorTask.create(
            TCreateSessionAppConfigsTask.create(jsonCfgTask, iniCfgTask)
        );
    end;

    function TCreateProjectDependenciesTaskFactory.buildSessionProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var registerCfgTask : ITask;
    begin
        registerCfgTask := buildConfigProjectTask(textFileCreator, contentModifier);

        result := TGroupTask.create([
            buildCompilerConfigsTask(textFileCreator, contentModifier),
            TCompositeSessionTask.create(
                //build config when --with-session is set
                buildSessionConfigProjectTask(textFileCreator, contentModifier),
                TCreateAppConfigsTask.create(textFileCreator, contentModifier)
            ),
            TCompositeSessionTask.create(
                //force --config always set if --with-session is set
                TForceConfigDecoratorTask.create(registerCfgTask),
                registerCfgTask
            ),
            TCompositeSessionTypeTask.create(
                //run this task if --with-session=file is set
                TCreateSessionDirTask.create(TDirectoryCreator.create()),
                //run this task if --with-session=cookie is set
                TNullTask.create(),
                //run this task if --with-session=db is set
                TNullTask.create()
            )
        ]);
    end;

    function TCreateProjectDependenciesTaskFactory.buildMiddlewareProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var registerCfgTask : ITask;
    begin
        registerCfgTask := buildConfigProjectTask(textFileCreator, contentModifier);

        result := TGroupTask.create([
            buildCompilerConfigsTask(textFileCreator, contentModifier),
            TCreateAppConfigsTask.create(textFileCreator, contentModifier),
            registerCfgTask,
            TCreateMiddlewareDependenciesTask.create(
                textFileCreator,
                contentModifier,
                TFileHelperAppender.create()
            )
        ]);
    end;

    function TCreateProjectDependenciesTaskFactory.buildBasicProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var registerCfgTask : ITask;
    begin
        registerCfgTask := buildConfigProjectTask(textFileCreator, contentModifier);
        result := TGroupTask.create([
            buildCompilerConfigsTask(textFileCreator, contentModifier),
            TCreateAppConfigsTask.create(textFileCreator, contentModifier),
            registerCfgTask,
            //add no middleware support
            TCreateNoMiddlewareDependenciesTask.create(
                textFileCreator,
                contentModifier,
                TFileHelperAppender.create()
            )
        ]);
    end;

    function TCreateProjectDependenciesTaskFactory.buildWithCsrfProjectTask(
        const prjTask : ITask;
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    begin
        result := TWithCsrfTask.create(
            //if --with-csrf parameter is set, force add --config and --with-session
            TForceConfigSessionDecoratorTask.create(
                TGroupTask.create([
                    prjTask,
                    TCreateCsrfMiddlewareDependenciesTask.create(
                        textFileCreator,
                        contentModifier,
                        TFileHelperAppender.create()
                    )
                ])
            ),
            prjTask
        );
    end;

    function TCreateProjectDependenciesTaskFactory.buildWithLoggerProjectTask(
        const prjTask : ITask;
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var taskArr : TNamedTaskArr;
    begin
        setLength(taskArr, 3);

        taskArr[0].name := 'file';
        taskArr[0].task := TCreateFileLoggerDependenciesTask.create(
            textFileCreator,
            contentModifier,
            TFileHelperAppender.create()
        );

        taskArr[1].name := 'syslog';
        taskArr[1].task := TCreateSyslogLoggerDependenciesTask.create(
            textFileCreator,
            contentModifier,
            TFileHelperAppender.create()
        );

        taskArr[2].name := 'db';
        taskArr[2].task := TCreateDbLoggerDependenciesTask.create(
            textFileCreator,
            contentModifier,
            TFileHelperAppender.create()
        );

        result := TWithLoggerTask.create(
            TGroupTask.create([
                prjTask,
                TCompositeLoggerDependenciesTask.create(taskArr)
            ]),
            prjTask
        );
    end;

    function TCreateProjectDependenciesTaskFactory.buildProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    var prjTask : ITask;
    begin
        prjTask := buildWithCsrfProjectTask(
            TWithSessionOrMiddlewareTask.create(
                buildSessionProjectTask(textFileCreator, contentModifier),
                buildMiddlewareProjectTask(textFileCreator, contentModifier),
                buildBasicProjectTask(textFileCreator, contentModifier)
            ),
            textFileCreator,
            contentModifier
        );
        result := buildWithLoggerProjectTask(
            prjTask,
            textFileCreator,
            contentModifier
        );
    end;

    function TCreateProjectDependenciesTaskFactory.build() : ITask;
    var textFileCreator : ITextFileCreator;
        contentModifier : IContentModifier;
    begin
        textFileCreator := TTextFileCreator.create();
        try
            contentModifier := TContentModifier.create();
            try
                try
                    result := buildProjectTask(textFileCreator, contentModifier);
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
