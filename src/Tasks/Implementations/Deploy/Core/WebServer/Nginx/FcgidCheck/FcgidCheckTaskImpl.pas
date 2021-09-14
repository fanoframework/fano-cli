(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit FcgidCheckTaskImpl;

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
     * task is not --deploy-fcgid and --web-server=nginx
     *------------------------------------------
     * This is to protect deployment using mod_fcgid which
     * only specific to Apache.
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TFcgidCheckTask = class(TDecoratorTask)
    private
        function showInstruction(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask;
        function isFcgidDeploymentOnNginx(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : boolean;

    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    sysutils,
    StrFormats;

resourcestring
    sNotSupportedOnNginx = 'Deployment using mod_fcgid is for Apache only and not supported on nginx.'+ LineEnding +
                  'Try remove --web-server=nginx or replace with --web-server=apache or use --deploy-fcgi';
    sRunWithHelp = 'Run with --help option to view available task.';

    function TFcgidCheckTask.isFcgidDeploymentOnNginx(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : boolean;
    begin
        result := opt.hasOption('deploy-fcgid') and
            (opt.getOptionValue('web-server') = 'nginx');
    end;

    function TFcgidCheckTask.showInstruction(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var deployValue : string;
    begin
        deployValue := opt.getOptionValue('deploy-fcgid');
        writeln(sNotSupportedOnNginx);
        writeln();
        writeln('Example:');
        writeln(formatColor('$ sudo fanocli --deploy-fcgid=' + deployValue, TXT_GREEN));
        writeln(formatColor('$ sudo fanocli --deploy-fcgid=' + deployValue + ' --web-server=apache', TXT_GREEN));
        writeln();
        writeln(sRunWithHelp);
        result := self;
    end;

    function TFcgidCheckTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        if isFcgidDeploymentOnNginx(opt, longOpt) then
        begin
            showInstruction(opt, longOpt);
        end else
        begin
            fActualTask.run(opt, longOpt);
        end;
        result := self;
    end;
end.
