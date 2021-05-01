(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit DuplicateCheckTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    SysUtils,
    DecoratorTaskImpl;

type

    (*!--------------------------------------
     * Task that run other task only if
     * controller, view, model, middleware
     * with same name not already defined
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TDuplicateCheckTask = class abstract (TDecoratorTask)
    protected
        function getType() : string; virtual; abstract;
        function isDuplicate(
            const opt : ITaskOptions;
            const longOpt : shortstring;
            const srcDir : string;
            const objName : string
        ) : boolean; virtual; abstract;
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

    function TDuplicateCheckTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var objName : string;
        srcDir : string;
        objType : string;
    begin
        result := self;
        objName := opt.getOptionValue(longOpt);
        objType := getType();
        if (objName = '') then
        begin
            writeln('Name of ', objType, ' can not be empty.');
            writeln('Run with --help to view available task.');
            exit();
        end;

        srcDir := getCurrentDir() + DirectorySeparator + 'src';

        if (isDuplicate(opt, longOpt, srcDir, objName)) then
        begin
            writeln('Cannot create ', objType, ', duplicate name ', objName);
            exit();
        end;

        fActualTask.run(opt, longOpt);
    end;
end.
