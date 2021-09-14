(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit ApacheFreeBsdVHostWriterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TextFileCreatorIntf,
    ContentModifierIntf,
    VirtualHostWriterIntf;

type

    (*!--------------------------------------
     * Task that creates Apache web server virtual host file
     * in FreeBsd
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TApacheFreeBsdVHostWriter = class(TInterfacedObject, IVirtualHostWriter)
    private
        fTextFileCreator : ITextFileCreator;
        fApacheVer : string;
    public
        constructor create(
            const txtFileCreator : ITextFileCreator;
            const apacheVer : string = 'apache24'
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

    constructor TApacheFreeBsdVHostWriter.create(
        const txtFileCreator : ITextFileCreator;
        const apacheVer : string = 'apache24'
    );
    begin
        fTextFileCreator := txtFileCreator;
        fApacheVer := apacheVer;
    end;

    procedure TApacheFreeBsdVHostWriter.writeVhost(
        const serverName : string;
        const vhostTpl : string;
        const cntModifier : IContentModifier
    );
    begin
        cntModifier.setVar('[[APACHE_LOG_DIR]]', '/var/log');
        fTextFileCreator.createTextFile(
            '/usr/local/etc/' + fApacheVer + '/Includes/' + serverName + '.conf',
            cntModifier.modify(vhostTpl)
        );
    end;

end.
