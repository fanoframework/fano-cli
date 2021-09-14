(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit ApacheEnableVhostTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    DecoratorTaskImpl;

type

    (*!--------------------------------------
     * Task that enable virtual host
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TApacheEnableVhostTask = class(TInterfacedObject, ITask)
    private
        {$IFDEF UNIX}
            procedure runOnUnix(
                const opt : ITaskOptions;
                const longOpt : shortstring
            );
        {$ENDIF}

        {$IFDEF WINDOWS}
            procedure runOnWindows(
                const opt : ITaskOptions;
                const longOpt : shortstring
            );
        {$ENDIF}
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask;
    end;

implementation

uses

    SysUtils,
    strformats
    {$IFDEF UNIX}
    , BaseUnix
    {$ENDIF};

    {$IFDEF UNIX}
        procedure TApacheEnableVhostTask.runOnUnix(
            const opt : ITaskOptions;
            const longOpt : shortstring
        );
        var serverName : shortString;
        begin
            serverName := opt.getOptionValue(longOpt);
            if directoryExists('/etc/apache2/sites-enabled') then
            begin
                //debian-based
                if not fileExists('/etc/apache2/sites-enabled/' + serverName + '.conf') then
                begin
                    fpSymlink(
                        PChar('/etc/apache2/sites-available/' + serverName + '.conf'),
                        PChar('/etc/apache2/sites-enabled/' + serverName + '.conf')
                    );

                    writeln(
                        'Enable virtual host ',
                        formatColor('/etc/apache2/sites-enabled/' + serverName + '.conf', TXT_GREEN)
                    );
                end;
            end else
            if directoryExists('/etc/httpd') then
            begin
                //fedora-based we do nothing
                writeln(
                    'Enable virtual host ',
                    formatColor('/etc/httpd/conf.d/' + serverName + '.conf', TXT_GREEN)
                );
            end else
            if directoryExists('/usr/local/etc/apache24') then
            begin
                //FreeBSD we do nothing
                writeln(
                    'Enable virtual host ',
                    formatColor('/usr/local/etc/apache24/Includes/' + serverName + '.conf', TXT_GREEN)
                );
            end else
            begin
                writeln('Cannot create vhost symlink. Unsupported platform or web server');
            end;
        end;
    {$ENDIF}

    {$IFDEF WINDOWS}
        procedure TApacheEnableVhostTask.runOnWindows(
            const opt : ITaskOptions;
            const longOpt : shortstring
        );
        var serverName : shortString;
            apacheDir : string;
        begin
            serverName := opt.getOptionValue(longOpt);
            apacheDir := getEnvironmentVariable('APACHE_DIR');
            if (apacheDir <> '') then
            begin
                apacheDir := 'C:\Program Files\Apache Group';
            end;

            if (not directoryExists(apacheDir)) then
            begin
                apacheDir := 'C:\Apache24';
            end;

            if (directoryExists(apacheDir)) then
            begin

            end else
            begin
                writeln(
                    'Cannot find Apache 2 directory in ' + apacheDir +
                    '. Set APACHE_DIR environment variable to correct directory'
                );
            end;
        end;
    {$ENDIF}

    function TApacheEnableVhostTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        {$IFDEF UNIX}
            runOnUnix(opt, longOpt);
        {$ELSE}
            {$IFDEF WINDOWS}
                runOnWindows(opt, longOpt);
            {$ELSE}
                writeln('Cannot create vhost symlink. Unsupported platform or web server');
            {$ENDIF}
        {$ENDIF}
        result := self;
    end;
end.
