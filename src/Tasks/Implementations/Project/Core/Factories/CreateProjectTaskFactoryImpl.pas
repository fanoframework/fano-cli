(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateProjectTaskFactoryImpl;

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
     * Factory class for create project task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateProjectTaskFactory = class(TInterfacedObject, ITaskFactory)
    protected
        fProjectDepTaskFactory : ITaskFactory;
        fBootstrapTaskFactory : ITaskFactory;

        function buildProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask; virtual;
    public
        constructor create(
            const depFactory : ITaskFactory;
            const bootstrapFactory : ITaskFactory
        );
        destructor destroy(); override;
        function build() : ITask; virtual;
    end;

implementation

uses

    TextFileCreatorImpl,
    ContentModifierImpl,
    DirectoryCreatorImpl,
    CreateDirTaskImpl,
    CreateAdditionalFilesTaskImpl,
    CompositeWpoTaskImpl,
    CreateShellScriptsTaskImpl,
    CreateWpoShellScriptsTaskImpl,
    InitGitRepoTaskImpl,
    CommitGitRepoTaskImpl,
    CreateProjectTaskImpl,
    NotInFanoProjectDirCheckTaskImpl,
    EmptyDirCheckTaskImpl,
    CompositeSessionTaskImpl,
    WithGitRepoTaskImpl,
    WithGitInitialCommitTaskImpl;

    constructor TCreateProjectTaskFactory.create(
        const depFactory : ITaskFactory;
        const bootstrapFactory : ITaskFactory
    );
    begin
        fProjectDepTaskFactory := depFactory;
        fBootstrapTaskFactory := bootstrapFactory;
    end;

    destructor TCreateProjectTaskFactory.destroy();
    begin
        fProjectDepTaskFactory := nil;
        fBootstrapTaskFactory := nil;
        inherited destroy();
    end;

    function TCreateProjectTaskFactory.buildProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    begin
        result := TCreateProjectTask.create(
            TCreateDirTask.create(TDirectoryCreator.create()),
            TCompositeWpoTask.create(
                TCreateWpoShellScriptsTask.create(textFileCreator, contentModifier),
                TCreateShellScriptsTask.create(textFileCreator, contentModifier)
            ),
            fProjectDepTaskFactory.build(),
            TCreateAdditionalFilesTask.create(textFileCreator, contentModifier),
            fBootstrapTaskFactory.build(),
            TWithGitRepoTask.create(
                TInitGitRepoTask.create(
                    TWithGitInitialCommitTask.create(
                        TCommitGitRepoTask.create()
                    )
                )
            )
        );
    end;

    function TCreateProjectTaskFactory.build() : ITask;
    var textFileCreator : ITextFileCreator;
        contentModifier : IContentModifier;
        createPrjTask : ITask;
        invInFanoProjectDirCheckTask : ITask;
    begin
        //TODO: refactor as this is similar to TCreateProjectFastCgiTaskFactory
        //or TCreateProjectScgiTaskFactory
        textFileCreator := TTextFileCreator.create();
        contentModifier := TContentModifier.create();
        createPrjTask := buildProjectTask(textFileCreator, contentModifier);

        //protect to avoid accidentally creating another project inside Fano-CLI
        //project directory structure
        invInFanoProjectDirCheckTask := TNotInFanoProjectDirCheckTask.create(createPrjTask);

        //protect to avoid accidentally creating project inside
        //existing and non empty directory
        result := TEmptyDirCheckTask.create(invInFanoProjectDirCheckTask);
    end;

end.
