(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateDaemonProjectTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf,
    TextFileCreatorIntf,
    ContentModifierIntf,
    CreateProjectTaskFactoryImpl;

type

    (*!--------------------------------------
     * Factory class for create daemon project task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateDaemonProjectTaskFactory = class(TCreateProjectTaskFactory)
    private
        fExecOutputDir : string;
    protected
        function buildProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask; override;
    public
        constructor create(
            const depFactory : ITaskFactory;
            const bootstrapFactory : ITaskFactory;
            const execOutputDir : string = 'bin'
        );

    end;

implementation

uses

    DirectoryCreatorImpl,
    CreateDirTaskImpl,
    CreateAdditionalFilesTaskImpl,
    CreateShellScriptsTaskImpl,
    CreateWpoShellScriptsTaskImpl,
    CompositeWpoTaskImpl,
    InitGitRepoTaskImpl,
    CommitGitRepoTaskImpl,
    CreateProjectTaskImpl,
    WithGitRepoTaskImpl,
    WithGitInitialCommitTaskImpl;

    constructor TCreateDaemonProjectTaskFactory.create(
        const depFactory : ITaskFactory;
        const bootstrapFactory : ITaskFactory;
        const execOutputDir : string = 'bin'
    );
    begin
        fExecOutputDir := execOutputDir;
        inherited create(depFactory, bootstrapFactory);
    end;

    function TCreateDaemonProjectTaskFactory.buildProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    begin
        result := TCreateProjectTask.create(
            TCreateDirTask.create(TDirectoryCreator.create()),
            //whole program optimization (WPO)
            TCompositeWpoTask.create(
                TCreateWpoShellScriptsTask.create(textFileCreator, contentModifier, fExecOutputDir),
                TCreateShellScriptsTask.create(textFileCreator, contentModifier, fExecOutputDir)
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
end.
