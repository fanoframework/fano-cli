(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit AbstractDeployTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf,
    TextFileCreatorIntf,
    DirectoryExistsIntf,
    VirtualHostWriterIntf;

type

    (*!--------------------------------------
     * Base abstract factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TAbstractDeployTaskFactory = class abstract (TInterfacedObject, ITaskFactory)
    protected
        function buildApacheVirtualHostWriter(
            ftext : ITextFileCreator;
            adirExists : IDirectoryExists
        ) : IVirtualHostWriter;

        function buildNginxVirtualHostWriter(
            ftext : ITextFileCreator;
            adirExists : IDirectoryExists
        ) : IVirtualHostWriter;
    public
        function build() : ITask; virtual; abstract;
    end;

implementation

uses

    FileHelperAppendImpl,

    {$IFDEF WINDOWS}
    ApacheWindowsVHostWriterImpl,
    NginxWindowsVHostWriterImpl,
    {$ELSE}
    ApacheDebianVHostWriterImpl,
    ApacheFedoraVHostWriterImpl,
    ApacheFreeBsdVHostWriterImpl,
    NginxLinuxVHostWriterImpl,
    NginxFreeBsdVHostWriterImpl,
    {$ENDIF}

    VirtualHostWriterImpl;

    function TAbstractDeployTaskFactory.buildApacheVirtualHostWriter(
        ftext : ITextFileCreator;
        adirExists : IDirectoryExists
    ) : IVirtualHostWriter;
    begin
        {$IFDEF WINDOWS}
        result := TApacheWindowsVHostWriter.create(
            ftext,
            TFileHelperAppender.create()
        );
        {$ELSE}
        result := (TVirtualHostWriter.create(aDirExists))
            .addWriter('/etc/apache2', TApacheDebianVHostWriter.create(ftext))
            .addWriter('/etc/httpd', TApacheFedoraVHostWriter.create(ftext))
            .addWriter('/usr/local/etc/apache24', TApacheFreeBsdVHostWriter.create(ftext, 'apache24'))
            .addWriter('/usr/local/etc/apache25', TApacheFreeBsdVHostWriter.create(ftext, 'apache25'));
        {$ENDIF}
    end;

    function TAbstractDeployTaskFactory.buildNginxVirtualHostWriter(
        ftext : ITextFileCreator;
        adirExists : IDirectoryExists
    ) : IVirtualHostWriter;
    begin
        {$IFDEF WINDOWS}
        result := TNginxWindowsVHostWriter.create(
            ftext,
            TFileHelperAppender.create()
        );
        {$ELSE}
        result := (TVirtualHostWriter.create(aDirExists))
            .addWriter('/etc/nginx', TNginxLinuxVHostWriter.create(ftext))
            .addWriter('/usr/local/etc/nginx', TNginxFreeBsdVHostWriter.create(ftext));
        {$ENDIF}


    end;

end.
