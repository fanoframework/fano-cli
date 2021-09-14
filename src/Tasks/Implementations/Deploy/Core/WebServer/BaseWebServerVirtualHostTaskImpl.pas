(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit BaseWebServerVirtualHostTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    BaseCreateFileTaskImpl;

type

    (*!--------------------------------------
     * Task that creates web server virtual host file
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TBaseWebServerVirtualHostTask = class(TBaseCreateFileTask)
    protected
        function getDocumentRoot(const opt : ITaskOptions) : string;
        function getHost(const opt : ITaskOptions) : string;
        function getPort(const opt : ITaskOptions) : string;
        function getVhostTemplate() : string; virtual; abstract;
        procedure createVhostFile(
            const opt : ITaskOptions;
            const serverName : string
        ); virtual; abstract;
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    SysUtils;

    function TBaseWebServerVirtualHostTask.getDocumentRoot(const opt : ITaskOptions) : string;
    begin
        result := opt.getOptionValue('doc-root');
        if result = '' then
        begin
            result := getCurrentDir() + DirectorySeparator + 'public';
        end;
    end;

    function TBaseWebServerVirtualHostTask.getHost(const opt : ITaskOptions) : string;
    begin
        result := opt.getOptionValue('host');
        if result = '' then
        begin
            result := '127.0.0.1';
        end;
    end;

    function TBaseWebServerVirtualHostTask.getPort(const opt : ITaskOptions) : string;
    begin
        result := opt.getOptionValue('port');
        if result = '' then
        begin
            result := '20477';
        end;
    end;

    function TBaseWebServerVirtualHostTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var serverName : string;
    begin
        inherited run(opt, longOpt);
        serverName := opt.getOptionValue(longOpt);
        contentModifier.setVar('[[SERVER_NAME]]', serverName);
        contentModifier.setVar('[[DOC_ROOT]]', getDocumentRoot(opt));
        contentModifier.setVar('[[HOST]]', getHost(opt));
        contentModifier.setVar('[[PORT]]', getPort(opt));
        createVhostFile(opt, serverName);
        result := self;
    end;
end.
