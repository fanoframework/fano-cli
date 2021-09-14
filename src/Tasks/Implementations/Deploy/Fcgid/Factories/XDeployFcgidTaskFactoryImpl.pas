(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit XDeployFcgidTaskFactoryImpl;

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
     * Factory class for deploy FastCGI application
     * with mod_fcgid
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TXDeployFcgidTaskFactory = class(TAbstractDeployTaskFactory)
    private
        function buildApacheFcgidVhostTask(
            atxtFileCreator : ITextFileCreator;
            aDirExists : IDirectoryExists
        ) : ITask;
        function buildStdoutApacheFcgidVhostTask() : ITask;
        function buildNormalApacheFcgidVhostTask() : ITask;
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
    FcgidCheckTaskImpl,
    VirtualHostWriterIntf,
    WebServerVirtualHostTaskImpl,
    VirtualHostImpl,
    VirtualHostWriterImpl,
    ApacheVHostFcgidTplImpl,
    StdoutCheckTaskImpl,
    DirectoryExistsImpl,
    NullDirectoryExistsImpl;

    function TXDeployFcgidTaskFactory.buildApacheFcgidVhostTask(
        atxtFileCreator : ITextFileCreator;
        adirExists : IDirectoryExists
    ) : ITask;
    var vhostWriter : IVirtualHostWriter;
    begin
        vhostWriter := buildApacheVirtualHostWriter(atxtFileCreator, aDirExists);

        result := TWebServerVirtualHostTask.create(
            TVirtualHost.create(),
            TApacheVHostFcgidTpl.create(),
            vhostWriter,
            TContentModifier.create()
        );
    end;

    function TXDeployFcgidTaskFactory.buildStdoutApacheFcgidVhostTask() : ITask;
    begin
        result := buildApacheFcgidVhostTask(
            TStdoutTextFileCreator.create(),
            TNullDirectoryExists.create()
        );
    end;

    function TXDeployFcgidTaskFactory.buildNormalApacheFcgidVhostTask() : ITask;
    begin
        result := buildApacheFcgidVhostTask(
            TTextFileCreator.create(),
            TDirectoryExists.create()
        );
    end;

    function TXDeployFcgidTaskFactory.build() : ITask;
    var normalDeployTask, stdoutDeployTask : ITask;
        fReader : IFileContentReader;
        fWriter : IFileContentWriter;
    begin
        fReader := TFileHelper.create();
        fWriter := fReader as IFileContentWriter;
        normalDeployTask := TDeployTask.create(
            TWebServerTask.create(
                buildNormalApacheFcgidVhostTask(),
                //nginx does not support something similar like mod_fcgid
                TNullTask.create()
            ),
            TWebServerTask.create(
                TApacheEnableVhostTask.create(),
                //nginx does not support so do nothing
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
                //nginx does not support so do nothing
                TNullTask.create()
            )
        );

        //nginx does not support something similar like mod_fcgid
        normalDeployTask := TFcgidCheckTask.create(normalDeployTask);

        //this is just simply output virtual host config to stdout
        //so no need for root privilege and reload web server or
        //messing up /etc/hosts
        stdoutDeployTask := TFcgidCheckTask.create(
            TWebServerTask.create(
                buildStdoutApacheFcgidVhostTask(),
                //nginx does not support something similar like mod_fcgid
                TNullTask.create()
            )
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
