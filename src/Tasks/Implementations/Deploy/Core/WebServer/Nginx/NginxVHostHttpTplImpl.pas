(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit NginxVHostHttpTplImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    ContentModifierIntf,
    VirtualHostTemplateIntf;

type

    (*!--------------------------------------
     * Task that creates nginx virtual host template
     * for http web application
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TNginxVHostHttpTpl = class(TInterfacedObject, IVirtualHostTemplate)
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

    function TNginxVHostHttpTpl.getVhostTemplate(
        const opt : ITaskOptions;
        const longOpt : shortstring;
        const cntModifier : IContentModifier
    ) : string;
    var
        {$INCLUDE src/Tasks/Implementations/Deploy/Core/WebServer/Nginx/Includes/http.vhost.conf.inc}
    begin
        result := strHttpVhostConf;
    end;

end.
