(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateMhdCompilerConfigsTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    DecoratorCreateCompilerConfigsTaskImpl;

type

    (*!--------------------------------------
     * Task that create web application project
     * compiler config files and enable conditional
     * define -DLIBMICROHTTPD if current command is
     * --project-mhd
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateMhdCompilerConfigsTask = class(TDecoratorCreateCompilerConfigsTask)
    protected
        function doCompilerConfigs(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    SysUtils;

    function TCreateMhdCompilerConfigsTask.doCompilerConfigs(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        if (longOpt = 'project-mhd') then
        begin
            fWriter.write(
                baseDirectory + '/defines.cfg',
                StringReplace(
                    fReader.read(baseDirectory + '/defines.cfg'),
                    '#-dLIBMICROHTTPD',
                    '-dLIBMICROHTTPD',
                    [rfReplaceAll]
                )
            );
            fWriter.write(
                baseDirectory + '/defines.cfg.sample',
                StringReplace(
                    fReader.read(baseDirectory + '/defines.cfg.sample'),
                    '#-dLIBMICROHTTPD',
                    '-dLIBMICROHTTPD',
                    [rfReplaceAll]
                )
            );
        end;
        result := self;
    end;
end.
