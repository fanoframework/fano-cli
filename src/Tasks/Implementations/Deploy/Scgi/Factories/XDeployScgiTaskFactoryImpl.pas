(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit XDeployScgiTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf,
    VirtualHostWriterIntf,
    TextFileCreatorIntf,
    DirectoryExistsIntf,
    AbstractDeployTaskFactoryImpl;

type

    (*!--------------------------------------
     * Factory class for deploy SCGI application
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TXDeployScgiTaskFactory = class(TAbstractDeployTaskFactory)
    private
        function buildApacheScgiVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutApacheScgiVhostTask() : ITask;
        function buildNormalApacheScgiVhostTask() : ITask;
        function buildNginxScgiVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutNginxScgiVhostTask() : ITask;
        function buildNormalNginxScgiVhostTask() : ITask;
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
    ContentModifierIntf,
    ContentModifierImpl,
    FileHelperImpl,
    VirtualHostIntf,
    VirtualHostTemplateIntf,
    WebServerVirtualHostTaskImpl,
    VirtualHostImpl,
    VirtualHostWriterImpl,
    ApacheVHostScgiTplImpl,
    NginxVHostScgiTplImpl,
    StdoutCheckTaskImpl,
    DirectoryExistsImpl,
    NullDirectoryExistsImpl;

    function TXDeployScgiTaskFactory.buildApacheScgiVhostTask(
        atxtFileCreator : ITextFileCreator;
        adirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
    begin
        vhostWriter := buildApacheVirtualHostWriter(atxtFileCreator, aDirExists);

        result := TWebServerVirtualHostTask.create(
            TVirtualHost.create(),
            TApacheVHostScgiTpl.create(),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployScgiTaskFactory.buildStdoutApacheScgiVhostTask() : ITask;
    begin
        result := buildApacheScgiVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployScgiTaskFactory.buildNormalApacheScgiVhostTask() : ITask;
    begin
        result := buildApacheScgiVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployScgiTaskFactory.buildNginxScgiVhostTask(
        atxtFileCreator : ITextFileCreator;
        aDirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
    begin
        vhostWriter := buildNginxVirtualHostWriter(atxtFileCreator, aDirExists);

        result := TWebServerVirtualHostTask.create(
            TVirtualHost.create(),
            TNginxVHostScgiTpl.create(),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployScgiTaskFactory.buildStdoutNginxScgiVhostTask() : ITask;
    begin
        result := buildNginxScgiVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployScgiTaskFactory.buildNormalNginxScgiVhostTask() : ITask;
    begin
        result := buildNginxScgiVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployScgiTaskFactory.build() : ITask;
    var normalDeployTask, stdoutDeployTask : ITask;
        fReader : IFileContentReader;
        fWriter : IFileContentWriter;
    begin
        fReader := TFileHelper.create();
        fWriter := fReader as IFileContentWriter;
        normalDeployTask := TDeployTask.create(
            TWebServerTask.create(
                buildNormalApacheScgiVhostTask(),
                buildNormalNginxScgiVhostTask()
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
            buildStdoutApacheScgiVhostTask(),
            buildStdoutNginxScgiVhostTask()
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
