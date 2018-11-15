(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (GPL 3.0)
 *------------------------------------------------------------- *)
unit RunCheckTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf;

type

    (*!--------------------------------------
     * Task that run other task only if
     * we are in project directory that is generated
     * by Fano CLI tools
     *------------------------------------------
     * This is to protect creating controller accidentally
     * outside non Fano-CLI generated project directory
     * structure.
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TRunCheckTask = class(TInterfacedObject, ITask)
    protected
        actualTask : ITask;
        function inFanoCliGeneratedProjectDir(const currDir : string) : boolean;
    public
        constructor create(const task : ITask);
        destructor destroy(); override;

        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; virtual;
    end;

implementation

uses

    SysUtils;

    constructor TRunCheckTask.create(const task : ITask);
    begin
        actualTask := task;
    end;

    destructor TRunCheckTask.destroy();
    begin
        inherited destroy();
        actualTask := nil;
    end;

    function TRunCheckTask.inFanoCliGeneratedProjectDir(const currDir : string) : boolean;
    begin
        result := directoryExists('fano') and
            directoryExists('app/Dependencies') and
            fileExists('build.sh') and
            fileExists('build.cfg') and
            fileExists('build.cfg.sample') and
            fileExists('app/bootstrap.pas') and
            fileExists('app/app.pas') and
            fileExists('app/Dependencies/dependencies.inc');
    end;

    function TRunCheckTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        if (inFanoCliGeneratedProjectDir(getCurrentDir())) then
        begin
            actualTask.run(opt, longOpt);
        end else
        begin
            writeln('It looks like current directory was not generated by Fano CLI.');
            writeln('Run with --help option to view available task.');
        end;
        result := self;
    end;
end.
