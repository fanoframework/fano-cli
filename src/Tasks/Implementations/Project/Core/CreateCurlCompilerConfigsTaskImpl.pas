(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateCurlCompilerConfigsTaskImpl;

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
     * define -DLIBCURL if current command has
     * --with-curl
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateCurlCompilerConfigsTask = class(TDecoratorCreateCompilerConfigsTask)
    protected
        function doCompilerConfigs(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    SysUtils;

    function TCreateCurlCompilerConfigsTask.doCompilerConfigs(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        if opt.hasOption('with-curl') then
        begin
            fWriter.write(
                baseDirectory + '/defines.cfg',
                StringReplace(
                    fReader.read(baseDirectory + '/defines.cfg'),
                    '#-dLIBCURL',
                    '-dLIBCURL',
                    [rfReplaceAll]
                )
            );
        end;
        result := self;
    end;
end.
