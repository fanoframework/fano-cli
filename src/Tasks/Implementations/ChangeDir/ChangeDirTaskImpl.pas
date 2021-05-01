(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit ChangeDirTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    DecoratorTaskImpl;

type

    (*!--------------------------------------
     * Task that change active directory after
     * other task is finished
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TChangeDirTask = class(TDecoratorTask)
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    SysUtils;


    function TChangeDirTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var targetDir : string;
    begin
        fActualTask.run(opt, longOpt);
        if opt.hasOption('cd') then
        begin
            targetDir := getCurrentDir() + '/' + opt.getOptionValue(longOpt);
            chDir(targetDir);
            writeln('Change current directory to ', targetDir);
        end;
        result := self;
    end;
end.
