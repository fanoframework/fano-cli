(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateProjectTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    BaseProjectTaskImpl;

type

    (*!--------------------------------------
     * Task that create web application project
     * directory structure using fano web framework
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateProjectTask = class(TBaseProjectTask)
    private
        createDirectoryTask : ITask;
        createShellScriptsTask : ITask;
        createAppConfigsTask : ITask;
        createAdditionalFilesTask : ITask;
        createGitRepoTask : ITask;
        createAppBootstrapTask : ITask;
    public
        constructor create(
            const createDirTask : ITask;
            const createScriptsTask : ITask;
            const createConfigsTask : ITask;
            const createAddFilesTask : ITask;
            const createAppTask : ITask;
            const createRepoTask : ITask
        );
        destructor destroy(); override;

        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    sysutils,
    StrFormats;

    constructor TCreateProjectTask.create(
        const createDirTask : ITask;
        const createScriptsTask : ITask;
        const createConfigsTask : ITask;
        const createAddFilesTask : ITask;
        const createAppTask : ITask;
        const createRepoTask : ITask
    );
    begin
        createDirectoryTask := createDirTask;
        createShellScriptsTask := createScriptsTask;
        createAppConfigsTask := createConfigsTask;
        createAdditionalFilesTask := createAddFilesTask;
        createAppBootstrapTask := createAppTask;
        createGitRepoTask := createRepoTask;
    end;

    destructor TCreateProjectTask.destroy();
    begin
        createDirectoryTask := nil;
        createShellScriptsTask := nil;
        createAppConfigsTask := nil;
        createAdditionalFilesTask := nil;
        createAppBootstrapTask := nil;
        createGitRepoTask := nil;
        inherited destroy();
    end;

    function TCreateProjectTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        //need to call parent run() so baseDirectory can be initialized
        inherited run(opt, longOpt);

        if (baseDirectory.length = 0) then
        begin
            writeln('Project target directory can not be empty.');
            writeln('Run with --help to view available tasks.');
            result := self;
            exit();
        end;

        writeln('Start creating project in ', formatColor(baseDirectory, TXT_GREEN), ' directory.');

        createDirectoryTask.run(opt, longOpt);
        createShellScriptsTask.run(opt, longOpt);
        createAdditionalFilesTask.run(opt, longOpt);
        createAppBootstrapTask.run(opt, longOpt);
        createAppConfigsTask.run(opt, longOpt);
        createGitRepoTask.run(opt, longOpt);

        writeln('Finish creating project in ', formatColor(baseDirectory, TXT_GREEN), ' directory.');
        writeln('Change directory to ', baseDirectory, ' to start creating controller, view, etc.');
        writeln();
        {$IFDEF WINDOWS}
        writeln(formatColor('> cd ' + baseDirectory, TXT_GREEN));
        writeln(formatColor('> fanocli --controller=Home --route=/', TXT_GREEN));
        {$ELSE}
        writeln(formatColor('$ cd ' + baseDirectory, TXT_GREEN));
        writeln(formatColor('$ fanocli --controller=Home --route=/', TXT_GREEN));
        {$ENDIF}
        result := self;
    end;
end.
