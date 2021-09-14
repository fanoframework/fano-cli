(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit StageRepoTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    BaseGitRepoTaskImpl;

type

    (*!--------------------------------------
     * Task that stage new files so it is
     * ready for commit
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TStageRepoTask = class(TBaseGitRepoTask)
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    sysutils;

    function TStageRepoTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var outputString : string;
    begin
        //need to call parent run() so baseDirectory can be initialized
        inherited run(opt, longOpt);

        // following line equals calling following command on shell
        // $ git add .
        runGit(baseDirectory, ['add', '.'], outputString);
        writeln(outputString);

        result := self;
    end;
end.
