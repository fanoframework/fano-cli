(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateWpoShellScriptsTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    TextFileCreatorIntf,
    ContentModifierIntf,
    CreateShellScriptsTaskImpl;

type

    (*!--------------------------------------
     * Task that create web application project
     * shell scripts using fano web framework
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateWpoShellScriptsTask = class(TCreateShellScriptsTask)
    protected
        procedure createShellScripts(const dir : string); override;
    end;

implementation

uses

    {$IFDEF UNIX}
    baseunix, unix,
    {$ENDIF}
    sysutils;


    procedure TCreateWpoShellScriptsTask.createShellScripts(const dir : string);
    var
        {$IFDEF UNIX}
            {$INCLUDE src/Tasks/Implementations/Project/Core/Includes/build.sh.wpo.inc}
        {$ENDIF}
        {$IFDEF WINDOWS}
            {$INCLUDE src/Tasks/Implementations/Project/Core/Includes/build.cmd.inc}
        {$ENDIF}
    begin
        fContentModifier.setVar('[[EXEC_OUTPUT_DIR]]', fExecBinOutput);
        {$IFDEF UNIX}
        createTextFile(dir + '/build.sh', fContentModifier.modify(strBuildShWpo));
        fpChmod(dir + '/build.sh', &775);
        {$ENDIF}

        {$IFDEF WINDOWS}
        //WPO not supported
        createTextFile(dir + '/build.cmd', fContentModifier.modify(strBuildCmd));
        {$ENDIF}
    end;

end.
