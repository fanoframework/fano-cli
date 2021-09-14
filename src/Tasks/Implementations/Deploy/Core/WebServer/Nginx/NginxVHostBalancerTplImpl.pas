(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit NginxVHostBalancerTplImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    ContentModifierIntf,
    VirtualHostIntf,
    VirtualHostTemplateIntf;

type

    (*!--------------------------------------
     * Task that creates nginx virtual host template
     * for SCGI web application
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TNginxVHostBalancerTpl = class(TInterfacedObject, IVirtualHostTemplate)
    private
        fVhost : IVirtualHost;
        fProxyPass : shortstring;
        fProxyParams : shortstring;
        fServerPrefix : shortstring;
        function getBalancerMember(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : string;
        function getBalancerMethod(const opt : ITaskOptions) : string;
    public
        constructor create(
            const aVhost : IVirtualHost;
            const proxyPass : shortstring = 'scgi_pass';
            const proxyParams : shortstring = 'include scgi_params;';
            const serverPrefix : shortstring = ''
        );
        function getVhostTemplate(
            const opt : ITaskOptions;
            const longOpt : shortstring;
            const cntModifier : IContentModifier
        ) : string;
    end;

implementation

uses

    SysUtils,
    RegExpr;

    constructor TNginxVHostBalancerTpl.create(
        const aVhost : IVirtualHost;
        const proxyPass : shortstring = 'scgi_pass';
        const proxyParams : shortstring = 'include scgi_params;';
        const serverPrefix : shortstring = ''
    );
    begin
        fVhost := aVhost;
        fProxyPass := proxyPass;
        fProxyParams := proxyParams;
        fServerPrefix := serverPrefix;
    end;

    function TNginxVHostBalancerTpl.getBalancerMember(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : string;
    var aport : integer;
        members, host, port : string;
        regex : TRegExpr;
    begin
        host := fVhost.getHost(opt, longOpt);
        port := fVhost.getPort(opt, longOpt);
        aport := strToInt(port);
        members := opt.getOptionValueDef('members', format('%s:%d,%s:%d', [host, aport, host, aport + 1]));
        regex := TRegExpr.Create();
        try
            regex.Expression := '([a-zA-Z0-9\.]+):([0-9]{1,5})[,]?';
            regex.ModifierG := true;
            result := regex.replace(
                members,
                'server $1:$2;' + LineEnding,
                true
            );
        finally
            regex.free();
        end;
    end;

    function TNginxVHostBalancerTpl.getBalancerMethod(const opt : ITaskOptions) : string;
    var balancerMethod : string;
    begin
        balancerMethod := opt.getOptionValue('lbmethod');
        if not ((balancerMethod = 'ip_hash') or
            (balancerMethod = 'least_conn') or
            (balancerMethod = 'random')) then
        begin
            result := '';
        end else
        begin
            result := balancerMethod + ';';
        end;
    end;

    function TNginxVHostBalancerTpl.getVhostTemplate(
        const opt : ITaskOptions;
        const longOpt : shortstring;
        const cntModifier : IContentModifier
    ) : string;
    var
        {$INCLUDE src/Tasks/Implementations/Deploy/Core/WebServer/Nginx/Includes/balancer.vhost.conf.inc}
    begin
        cntModifier.setVar('[[LOAD_BALANCER_MEMBERS]]', getBalancerMember(opt, longOpt));
        cntModifier.setVar('[[LOAD_BALANCER_METHOD]]', getBalancerMethod(opt));
        cntModifier.setVar('[[PROXY_PASS_TYPE]]', fProxyPass);
        cntModifier.setVar('[[PROXY_PARAMS_TYPE]]', fProxyParams);
        cntModifier.setVar('[[SERVER_PREFIX]]', fServerPrefix);
        result := cntModifier.modify(strBalancerVhostConf);
    end;

end.
