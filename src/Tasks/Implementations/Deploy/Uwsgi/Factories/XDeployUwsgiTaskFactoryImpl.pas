(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit XDeployUwsgiTaskFactoryImpl;

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
     * Factory class for deploy uwsgi application
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TXDeployUwsgiTaskFactory = class(TAbstractDeployTaskFactory)
    private
        function buildApacheUwsgiVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutApacheUwsgiVhostTask() : ITask;
        function buildNormalApacheUwsgiVhostTask() : ITask;
        function buildNginxUwsgiVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutNginxUwsgiVhostTask() : ITask;
        function buildNormalNginxUwsgiVhostTask() : ITask;
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
    VirtualHostWriterIntf,
    WebServerVirtualHostTaskImpl,
    VirtualHostImpl,
    VirtualHostWriterImpl,
    ApacheVHostUwsgiTplImpl,
    NginxVHostUwsgiTplImpl,
    StdoutCheckTaskImpl,
    DirectoryExistsImpl,
    NullDirectoryExistsImpl;

    function TXDeployUwsgiTaskFactory.buildApacheUwsgiVhostTask(
        atxtFileCreator : ITextFileCreator;
        adirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
    begin
        vhostWriter := buildApacheVirtualHostWriter(atxtFileCreator, aDirExists);

        result := TWebServerVirtualHostTask.create(
            TVirtualHost.create(),
            TApacheVHostUwsgiTpl.create(),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployUwsgiTaskFactory.buildStdoutApacheUwsgiVhostTask() : ITask;
    begin
        result := buildApacheUwsgiVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployUwsgiTaskFactory.buildNormalApacheUwsgiVhostTask() : ITask;
    begin
        result := buildApacheUwsgiVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployUwsgiTaskFactory.buildNginxUwsgiVhostTask(
        atxtFileCreator : ITextFileCreator;
        aDirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
    begin
        vhostWriter := buildNginxVirtualHostWriter(atxtFileCreator, aDirExists);

        result := TWebServerVirtualHostTask.create(
            TVirtualHost.create(),
            TNginxVHostUwsgiTpl.create(),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployUwsgiTaskFactory.buildStdoutNginxUwsgiVhostTask() : ITask;
    begin
        result := buildNginxUwsgiVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployUwsgiTaskFactory.buildNormalNginxUwsgiVhostTask() : ITask;
    begin
        result := buildNginxUwsgiVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployUwsgiTaskFactory.build() : ITask;
    var normalDeployTask, stdoutDeployTask : ITask;
        fReader : IFileContentReader;
        fWriter : IFileContentWriter;
    begin
        fReader := TFileHelper.create();
        fWriter := fReader as IFileContentWriter;
        normalDeployTask := TDeployTask.create(
            TWebServerTask.create(
                buildNormalApacheUwsgiVhostTask(),
                buildNormalNginxUwsgiVhostTask()
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
            buildStdoutApacheUwsgiVhostTask(),
            buildStdoutNginxUwsgiVhostTask()
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
