(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit NginxVHostScgiTplImpl;

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
     * for SCGI web application
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TNginxVHostScgiTpl = class(TInterfacedObject, IVirtualHostTemplate)
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

    function TNginxVHostScgiTpl.getVhostTemplate(
        const opt : ITaskOptions;
        const longOpt : shortstring;
        const cntModifier : IContentModifier
    ) : string;
    var
        {$INCLUDE src/Tasks/Implementations/Deploy/Core/WebServer/Nginx/Includes/scgi.vhost.conf.inc}
    begin
        result := strScgiVhostConf;
    end;

end.
