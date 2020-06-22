(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateWpoCompilerConfigsTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    CreateFileTaskImpl;

type

    (*!--------------------------------------
     * Task that create web application project
     * compiler config files for whole program optimization (WPO)
     * using fano web framework
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateWpoCompilerConfigsTask = class(TCreateFileTask)
    private
        procedure createCompilerConfigs(const dir : string);
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    sysutils;

    procedure TCreateWpoCompilerConfigsTask.createCompilerConfigs(const dir : string);
    var
        {$INCLUDE src/Tasks/Implementations/Project/Core/Includes/build.cfg.inc}
        {$INCLUDE src/Tasks/Implementations/Project/Core/Includes/build.dev.cfg.inc}
        {$INCLUDE src/Tasks/Implementations/Project/Core/Includes/build.global.prod.cfg.inc}
        {$INCLUDE src/Tasks/Implementations/Project/Core/Includes/build.prod.cfg.wpo.inc}
        {$INCLUDE src/Tasks/Implementations/Project/Core/Includes/build.prodwpo.cfg.wpo.inc}
    begin
        {$IFDEF FREEBSD}
        createTextFile(
            dir + '/build.cfg',
            StringReplace(strBuildCfg, '-Tlinux', '-Tfreebsd', [rfReplaceAll])
        );
        {$ENDIF}

        {$IFDEF WINDOWS}
        createTextFile(
            dir + '/build.cfg',
            StringReplace(
                StringReplace(strBuildCfg, '-Tlinux', '-Twin64', [rfReplaceAll]),
                '#-WC',
                '-WC',
                [rfReplaceAll]
            )
        );
        {$ENDIF}

        {$IFDEF LINUX}
        createTextFile(dir + '/build.cfg', strBuildCfg);
        {$ENDIF}

        createTextFile(dir + '/build.cfg.sample', strBuildCfg);

        createTextFile(dir + '/build.dev.cfg', strBuildCfgDev);
        createTextFile(dir + '/build.dev.cfg.sample', strBuildCfgDev);

        createTextFile(dir + '/build.global.prod.cfg', strBuildCfgGlobalProd);
        createTextFile(dir + '/build.global.prod.cfg.sample', strBuildCfgGlobalProd);

        createTextFile(dir + '/build.prod.cfg', strBuildCfgProd);
        createTextFile(dir + '/build.prod.cfg.sample', strBuildCfgProd);

        createTextFile(dir + '/build.prodwpo.cfg', strBuildCfgProdWpo);
        createTextFile(dir + '/build.prodwpo.cfg.sample', strBuildCfgProdWpo);
    end;

    function TCreateWpoCompilerConfigsTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        //need to call parent run() so baseDirectory can be initialized
        inherited run(opt, longOpt);
        createCompilerConfigs(baseDirectory);
        result := self;
    end;
end.
