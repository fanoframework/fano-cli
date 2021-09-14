(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit VirtualHostImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    VirtualHostIntf;

type

    (*!--------------------------------------
     * Task that creates web server virtual host file
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TVirtualHost = class(TInterfacedObject, IVirtualHost)
    public
        function getServerName(const opt : ITaskOptions; const longOpt : shortstring) : string;
        function getDocumentRoot(const opt : ITaskOptions; const longOpt : shortstring) : string;
        function getHost(const opt : ITaskOptions; const longOpt : shortstring) : string;
        function getPort(const opt : ITaskOptions; const longOpt : shortstring) : string;
    end;

implementation

uses

    SysUtils;

    function TVirtualHost.getServerName(const opt : ITaskOptions; const longOpt : shortstring) : string;
    begin
        result := opt.getOptionValueDef(longOpt, 'local.fano');
    end;

    function TVirtualHost.getDocumentRoot(const opt : ITaskOptions; const longOpt : shortstring) : string;
    begin
        result := opt.getOptionValueDef('doc-root', getCurrentDir() + DirectorySeparator + 'public');
    end;

    function TVirtualHost.getHost(const opt : ITaskOptions; const longOpt : shortstring) : string;
    begin
        result := opt.getOptionValueDef('host', '127.0.0.1');
    end;

    function TVirtualHost.getPort(const opt : ITaskOptions; const longOpt : shortstring) : string;
    begin
        result := opt.getOptionValueDef('port', '20477');
    end;

end.
