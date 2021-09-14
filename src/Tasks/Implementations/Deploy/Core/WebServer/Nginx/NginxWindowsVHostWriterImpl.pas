(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit NginxWindowsVHostWriterImpl;

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
     * Task that creates Nginx web server virtual host file
     * in Windows
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TNginxWindowsVHostWriter = class(TInterfacedObject, IVirtualHostWriter)
    private
        fFileAppender : IFileContentAppender;
        fTextFileCreator : ITextFileCreator;

        procedure doWriteVhost(
            const serverName : string;
            const vhostTpl : string;
            const cntModifier : IContentModifier;
            const nginxDir : string
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

    constructor TNginxWindowsVHostWriter.create(
        const txtFileCreator : ITextFileCreator;
        const fileAppender : IFileContentAppender
    );
    begin
        fTextFileCreator := txtFileCreator;
        fFileAppender := fileAppender;
    end;

    procedure TNginxWindowsVHostWriter.doWriteVhost(
        const serverName : string;
        const vhostTpl : string;
        const cntModifier : IContentModifier;
        const nginxDir : string
    );
    begin
        cntModifier.setVar('[[NGINX_LOG_DIR]]', nginxDir + '\logs');
        fTextFileCreator.createTextFile(
            nginxDir + '\conf\' + serverName + '.conf',
            cntModifier.modify(vhostTpl)
        );

        fFileAppender.append(
            nginxDir + '\conf\nginx.conf',
            'include "' + nginxDir + '\conf\' + serverName + '.conf";' + LineEnding
        );
    end;

    procedure TNginxWindowsVHostWriter.writeVhost(
        const serverName : string;
        const vhostTpl : string;
        const cntModifier : IContentModifier
    );
    var nginxDir : string;
    begin
        nginxDir := getEnvironmentVariable('NGINX_DIR');
        if (nginxDir = '') then
        begin
            nginxDir := 'C:\Program Files\nginx';
        end;

        if (not directoryExists(nginxDir)) then
        begin
            nginxDir := 'C:\nginx';
        end;

        if (directoryExists(nginxDir)) then
        begin
            nginxDir := ExcludeTrailingPathDelimiter(nginxDir);
            doWriteVhost(serverName,vhostTpl,cntModifier, nginxDir);
        end else
        begin
            writeln(
                'Cannot find Nginx directory in ' + nginxDir +
                '. Set NGINX_DIR environment variable to correct directory'
            );
        end;

    end;

end.
