(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit XDeployBalancerTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf,
    TextFileCreatorIntf,
    DirectoryExistsIntf,
    AbstractDeployTaskFactoryImpl;

type

    (*!--------------------------------------
     * Factory class for deploy web application with
     * reverse proxy load balancer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TXDeployBalancerTaskFactory = class abstract (TAbstractDeployTaskFactory)
    private
        function buildApacheBalancerVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutApacheBalancerVhostTask() : ITask;
        function buildNormalApacheBalancerVhostTask() : ITask;
        function buildNginxBalancerVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutNginxBalancerVhostTask() : ITask;
        function buildNormalNginxBalancerVhostTask() : ITask;
    protected
        function getProtocol() : shortstring; virtual; abstract;
        function getProxyPass() : shortstring; virtual; abstract;
        function getProxyParams() : shortstring; virtual; abstract;
        function getServerPrefix() : shortstring; virtual;
    public
        function build() : ITask; override;
    end;

implementation

uses

    FileContentWriterIntf,
    FileContentReaderIntf,
    NullTaskImpl,
    DeployTaskImpl,
    ApacheEnableVhostTaskImpl,
    ApacheReloadWebServerTaskImpl,
    NginxReloadWebServerTaskImpl,
    AddDomainToEtcHostTaskImpl,
    WithSkipEtcHostTaskImpl,
    RootCheckTaskImpl,
    InFanoProjectDirCheckTaskImpl,
    WebServerTaskImpl,
    TextFileCreatorImpl,
    StdoutTextFileCreatorImpl,
    DirectoryCreatorImpl,
    ContentModifierImpl,
    FileHelperImpl,
    FileHelperAppendImpl,
    BaseCreateFileTaskImpl,
    CreateFileConsts,
    VirtualHostIntf,
    VirtualHostWriterIntf,
    WebServerVirtualHostTaskImpl,
    VirtualHostImpl,
    VirtualHostWriterImpl,
    ApacheVHostBalancerTplImpl,
    NginxVHostBalancerTplImpl,
    StdoutCheckTaskImpl,
    DirectoryExistsImpl,
    NullDirectoryExistsImpl;

    function TXDeployBalancerTaskFactory.buildApacheBalancerVhostTask(
        atxtFileCreator : ITextFileCreator;
        adirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
        vhost : IVirtualHost;
    begin
        vhost := TVirtualHost.create();
        vhostWriter := buildApacheVirtualHostWriter(atxtFileCreator, aDirExists);
        result := TWebServerVirtualHostTask.create(
            vhost,
            TApacheVHostBalancerTpl.create(vhost, getProtocol()),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployBalancerTaskFactory.buildStdoutApacheBalancerVhostTask() : ITask;
    begin
        result := buildApacheBalancerVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployBalancerTaskFactory.buildNormalApacheBalancerVhostTask() : ITask;
    begin
        result := buildApacheBalancerVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployBalancerTaskFactory.buildNginxBalancerVhostTask(
        atxtFileCreator : ITextFileCreator;
        aDirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
        vhost : IVirtualHost;
    begin
        vhostWriter := buildNginxVirtualHostWriter(atxtFileCreator, aDirExists);
        vhost := TVirtualHost.create();
        result := TWebServerVirtualHostTask.create(
            vhost,
            TNginxVHostBalancerTpl.create(
                vhost,
                getProxyPass(),
                getProxyParams(),
                getServerPrefix()
            ),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployBalancerTaskFactory.buildStdoutNginxBalancerVhostTask() : ITask;
    begin
        result := buildNginxBalancerVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployBalancerTaskFactory.buildNormalNginxBalancerVhostTask() : ITask;
    begin
        result := buildNginxBalancerVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployBalancerTaskFactory.getServerPrefix() : shortstring;
    begin
        result := '';
    end;

    function TXDeployBalancerTaskFactory.build() : ITask;
    var normalDeployTask, stdoutDeployTask : ITask;
        fReader : IFileContentReader;
        fWriter : IFileContentWriter;
    begin
        fReader := TFileHelper.create();
        fWriter := fReader as IFileContentWriter;
        normalDeployTask := TDeployTask.create(
            TWebServerTask.create(
                buildNormalApacheBalancerVhostTask(),
                buildNormalNginxBalancerVhostTask()
            ),
            TWebServerTask.create(
                TApacheEnableVhostTask.create(),
                //do nothing. In Nginx we create config in virtual host directory
                //so it automatically enabled
                TNullTask.create()
            ),
            //wrap to allow skip domain name creation in /etc/host with
            //--skip-etc-hosts parameter
            TWithSkipEtcHostTask.create(
                TNullTask.create(),
                TAddDomainToEtcHostTask.create(fReader, fWriter)
            ),
            TWebServerTask.create(
                TApacheReloadWebServerTask.create(),
                TNginxReloadWebServerTask.create()
            )
        );

        //this is just simply output virtual host config to stdout
        //so no need for root privilege and reload web server or
        //messing up /etc/hosts
        stdoutDeployTask := TWebServerTask.create(
            buildStdoutApacheBalancerVhostTask(),
            buildStdoutNginxBalancerVhostTask()
        );

        result := TStdoutCheckTask.create(
            //if --stdout command line provided, execute this task
            //protect to avoid accidentally running
            //not in FanoCLI generated project directory
            TInFanoProjectDirCheckTask.create(stdoutDeployTask),

            //protect to avoid accidentally running without root privilege
            //and not in FanoCLI generated project directory
            TRootCheckTask.create(TInFanoProjectDirCheckTask.create(normalDeployTask))
        );
    end;

end.
