(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit RootCheckTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    DecoratorTaskImpl;

type

    (*!--------------------------------------
     * Task that run other task only if
     * current task is run as root
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TRootCheckTask = class(TDecoratorTask)
    private
        function isRunAsRoot() : boolean;
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    SysUtils

    {$IFDEF UNIX}
    ,BaseUnix
    {$ENDIF}

    {$IFDEF WINDOWS}
    ,winutils
    {$ENDIF};

resourcestring

    sErrMustRunAsRoot = 'Cannot run privileged task as ordinary user. Try to run with sudo.';

    {$IFDEF UNIX}
    function TRootCheckTask.isRunAsRoot() : boolean;
    const ROOT = 0;
    begin
        //get effective user id, 0 mean root
        result := (fpgeteuid() = ROOT);
    end;
    {$ENDIF}

    {$IFDEF WINDOWS}
    function TRootCheckTask.isRunAsRoot() : boolean;
    begin
        result := isWindowsAdmin();
    end;
    {$ENDIF}

    function TRootCheckTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        if isRunAsRoot() then
        begin
            fActualTask.run(opt, longOpt);
        end else
        begin
            writeln(sErrMustRunAsRoot);
        end;
        result := self;
    end;
end.
