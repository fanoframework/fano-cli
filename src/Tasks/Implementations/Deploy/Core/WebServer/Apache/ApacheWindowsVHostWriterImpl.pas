(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit ApacheWindowsVHostWriterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TextFileCreatorIntf,
    ContentModifierIntf,
    VirtualHostWriterIntf,
    FileContentAppenderIntf;

type

    (*!--------------------------------------
     * Task that creates Apache web server virtual host file
     * in Windows
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TApacheWindowsVHostWriter = class(TInterfacedObject, IVirtualHostWriter)
    private
        fFileAppender : IFileContentAppender;
        fTextFileCreator : ITextFileCreator;

        procedure doWriteVhost(
            const serverName : string;
            const vhostTpl : string;
            const cntModifier : IContentModifier;
            const apacheDir : string
        );
    public
        constructor create(
            const txtFileCreator : ITextFileCreator;
            const fileAppender : IFileContentAppender
        );
        procedure writeVhost(
            const serverName : string;
            const vhostTpl : string;
            const cntModifier : IContentModifier
        );
    end;

implementation

uses

    SysUtils;

    constructor TApacheWindowsVHostWriter.create(
        const txtFileCreator : ITextFileCreator;
        const fileAppender : IFileContentAppender
    );
    begin
        fTextFileCreator := txtFileCreator;
        fFileAppender := fileAppender;
    end;

    procedure TApacheWindowsVHostWriter.doWriteVhost(
        const serverName : string;
        const vhostTpl : string;
        const cntModifier : IContentModifier;
        const apacheDir : string
    );
    begin
        cntModifier.setVar('[[APACHE_LOG_DIR]]', apacheDir + '\logs');
        fTextFileCreator.createTextFile(
            apacheDir + '\conf\extra\' + serverName + '.conf',
            cntModifier.modify(vhostTpl)
        );

        fFileAppender.append(
            apacheDir + '\conf\httpd.conf',
            'Include ' + apacheDir + '\conf\extra\' + serverName + '.conf' + LineEnding
        );
    end;

    procedure TApacheWindowsVHostWriter.writeVhost(
        const serverName : string;
        const vhostTpl : string;
        const cntModifier : IContentModifier
    );
    var apacheDir : string;
    begin
        apacheDir := getEnvironmentVariable('APACHE_DIR');
        if (apacheDir = '') then
        begin
            apacheDir := 'C:\Program Files\Apache Group';
        end;

        if (not directoryExists(apacheDir)) then
        begin
            apacheDir := 'C:\Apache24';
        end;

        if (directoryExists(apacheDir)) then
        begin
            apacheDir := ExcludeTrailingPathDelimiter(apacheDir);
            doWriteVhost(serverName, vhostTpl, cntModifier, apacheDir);
        end else
        begin
            writeln(
                'Cannot find Apache 2 directory in ' + apacheDir +
                '. Set APACHE_DIR environment variable to correct directory'
            );
        end;

    end;

end.
