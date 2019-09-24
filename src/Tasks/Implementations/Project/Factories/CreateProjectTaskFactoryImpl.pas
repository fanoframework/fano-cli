(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
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
        function buildProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask; virtual;
    public
        function build() : ITask; virtual;
    end;

implementation

uses

    TextFileCreatorImpl,
    ContentModifierImpl,
    DirectoryCreatorImpl,
    CreateDirTaskImpl,
    CreateAppConfigsTaskImpl,
    CreateAdditionalFilesTaskImpl,
    CreateShellScriptsTaskImpl,
    CreateAppBootstrapTaskImpl,
    InitGitRepoTaskImpl,
    CommitGitRepoTaskImpl,
    CreateProjectTaskImpl,
    InvRunCheckTaskImpl,
    ChangeDirTaskImpl,
    EmptyDirCheckTaskImpl;

    function TCreateProjectTaskFactory.buildProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    begin
        result := TCreateProjectTask.create(
            TCreateDirTask.create(TDirectoryCreator.create()),
            TCreateShellScriptsTask.create(textFileCreator, contentModifier),
            TCreateAppConfigsTask.create(textFileCreator, contentModifier),
            TCreateAdditionalFilesTask.create(textFileCreator, contentModifier),
            TCreateAppBootstrapTask.create(textFileCreator, contentModifier),
            TInitGitRepoTask.create(TCommitGitRepoTask.create())
        );
    end;

    function TCreateProjectTaskFactory.build() : ITask;
    var textFileCreator : ITextFileCreator;
        contentModifier : IContentModifier;
        createPrjTask : ITask;
        chdirTask : ITask;
        invRunCheckTask : ITask;
    begin
        //TODO: refactor as this is similar to TCreateProjectFastCgiTaskFactory
        //or TCreateProjectScgiTaskFactory
        textFileCreator := TTextFileCreator.create();
        contentModifier := TContentModifier.create();
        createPrjTask := buildProjectTask(textFileCreator, contentModifier);

        //wrap with change dir task so active directory can be changed with --cd parameter
        chDirTask := TChangeDirTask.create(createPrjTask);

        //protect to avoid accidentally creating another project inside Fano-CLI
        //project directory structure
        invRunCheckTask := TInvRunCheckTask.create(chDirTask);

        //protect to avoid accidentally creating project inside
        //existing and non empty directory
        result := TEmptyDirCheckTask.create(invRunCheckTask);
    end;

end.
