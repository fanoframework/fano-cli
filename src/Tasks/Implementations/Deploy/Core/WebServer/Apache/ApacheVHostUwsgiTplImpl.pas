(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit ApacheVHostUwsgiTplImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    ContentModifierIntf,
    VirtualHostTemplateIntf;

type

    (*!--------------------------------------
     * Task that creates apache virtual host template
     * for uwsgi web application with mod_proxy_uwsgi
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TApacheVHostUwsgiTpl = class(TInterfacedObject, IVirtualHostTemplate)
    public
        function getVhostTemplate(
            const opt : ITaskOptions;
            const longOpt : shortstring;
            const cntModifier : IContentModifier
        ) : string;
    end;

implementation

uses

    SysUtils;

    function TApacheVHostUwsgiTpl.getVhostTemplate(
        const opt : ITaskOptions;
        const longOpt : shortstring;
        const cntModifier : IContentModifier
    ) : string;
    var
        {$INCLUDE src/Tasks/Implementations/Deploy/Core/WebServer/Apache/Includes/uwsgi.vhost.conf.inc}
    begin
        result := strUwsgiVhostConf;
    end;

end.
