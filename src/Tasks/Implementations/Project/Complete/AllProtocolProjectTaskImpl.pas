(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit AllProtocolProjectTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    NamedCompositeTaskImpl;

type

    (*!--------------------------------------
     * Composite task that combine cgi, fastcgi,
     * http, scgi, uwsgi project as one
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TAllProtocolProjectTask = class(TNamedCompositeTask)
    private
        function isSupportedProtocol(const proto:string) : boolean;
        function getSupportedProtocols() : string;
    protected
        (*!--------------------------------------
         * get task name
         *---------------------------------------------
         * @param opt current task options
         * @param longOpt current long option name
         * @return task name string
         *---------------------------------------*)
        function getTaskName(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : shortstring; override;
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

    function TAllProtocolProjectTask.isSupportedProtocol(const proto:string) : boolean;
    var i : integer;
    begin
        result := false;
        for i:= 0 to length(fTasks) -1 do
        begin
            if proto = fTasks[i].name then
            begin
                result := true;
                break;
            end;
        end;
    end;

    function TAllProtocolProjectTask.getSupportedProtocols() : string;
    var i : integer;
    begin
        result := '';
        if length(fTasks) = 0 then
        begin
            exit;
        end;

        for i:= 0 to length(fTasks) - 2 do
        begin
            result := result + fTasks[i].name + ', ';
        end;
        result := result + fTasks[length(fTasks) - 1].name;
    end;

    (*!--------------------------------------
     * get task name
     *---------------------------------------------
     * @param opt current task options
     * @param longOpt current long option name
     * @return task name string
     *---------------------------------------*)
    function TAllProtocolProjectTask.getTaskName(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : shortstring;
    begin
        //use protocol values as task name
        result := opt.getOptionValueDef('protocol', 'cgi');
    end;

    function TAllProtocolProjectTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var proto : string;
    begin
        //current longOption will be 'project'
        //mask long option value based on protocol so that
        //task become 'project-cgi', 'project-scgi' and so on
        proto := opt.getOptionValueDef('protocol', 'cgi');
        if not (isSupportedProtocol(proto)) then
        begin
            writeln('Unknown protocol type: ', proto);
            writeln('Must be one of : ', getSupportedProtocols());
        end else
        begin
            inherited run(opt, longOpt + '-' + proto);
        end;
        result := self;
    end;
end.
