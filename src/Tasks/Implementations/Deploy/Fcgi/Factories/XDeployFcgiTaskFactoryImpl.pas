(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit XDeployFcgiTaskFactoryImpl;

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
     * Factory class for deploy CGI application
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TXDeployFcgiTaskFactory = class(TAbstractDeployTaskFactory)
    private
        function buildApacheFcgiVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutApacheFcgiVhostTask() : ITask;
        function buildNormalApacheFcgiVhostTask() : ITask;
        function buildNginxFcgiVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutNginxFcgiVhostTask() : ITask;
        function buildNormalNginxFcgiVhostTask() : ITask;
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
    WebServerVirtualHostTaskImpl,
    VirtualHostImpl,
    VirtualHostWriterIntf,
    VirtualHostWriterImpl,

    ApacheVHostFcgiTplImpl,
    NginxVHostFcgiTplImpl,
    StdoutCheckTaskImpl,
    DirectoryExistsImpl,
    NullDirectoryExistsImpl;

    function TXDeployFcgiTaskFactory.buildApacheFcgiVhostTask(
        atxtFileCreator : ITextFileCreator;
        adirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
    begin
        vhostWriter := buildApacheVirtualHostWriter(atxtFileCreator, aDirExists);

        result := TWebServerVirtualHostTask.create(
            TVirtualHost.create(),
            TApacheVHostFcgiTpl.create(),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployFcgiTaskFactory.buildStdoutApacheFcgiVhostTask() : ITask;
    begin
        result := buildApacheFcgiVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployFcgiTaskFactory.buildNormalApacheFcgiVhostTask() : ITask;
    begin
        result := buildApacheFcgiVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployFcgiTaskFactory.buildNginxFcgiVhostTask(
        atxtFileCreator : ITextFileCreator;
        aDirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
    begin
        vhostWriter := buildNginxVirtualHostWriter(atxtFileCreator, aDirExists);

        result := TWebServerVirtualHostTask.create(
            TVirtualHost.create(),
            TNginxVHostFcgiTpl.create(),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployFcgiTaskFactory.buildStdoutNginxFcgiVhostTask() : ITask;
    begin
        result := buildNginxFcgiVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployFcgiTaskFactory.buildNormalNginxFcgiVhostTask() : ITask;
    begin
        result := buildNginxFcgiVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployFcgiTaskFactory.build() : ITask;
    var normalDeployTask, stdoutDeployTask : ITask;
        fReader : IFileContentReader;
        fWriter : IFileContentWriter;
    begin
        fReader := TFileHelper.create();
        fWriter := fReader as IFileContentWriter;
        normalDeployTask := TDeployTask.create(
            TWebServerTask.create(
                buildNormalApacheFcgiVhostTask(),
                buildNormalNginxFcgiVhostTask()
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
            buildStdoutApacheFcgiVhostTask(),
            buildStdoutNginxFcgiVhostTask()
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
