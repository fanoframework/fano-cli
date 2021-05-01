(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit NamedCompositeTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf;

type

    TNamedTask = record
        name : shortstring;
        task : ITask;
    end;
    TNamedTaskArr = array of TNamedTask;

    (*!--------------------------------------
     * Abstract task that run selected task from group of tasks
     * using its associated name
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TNamedCompositeTask = class abstract (TInterfacedObject, ITask)
    protected
        fTasks : TNamedTaskArr;

        (*!--------------------------------------
         * get task name
         *---------------------------------------------
         * @param opt current task options
         * @param longOpt current long option name
         * @return task name string
         *---------------------------------------*)
        function getTaskName(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : shortstring; virtual; abstract;
    public
        constructor create(const atasks : TNamedTaskArr);

        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; virtual;
    end;

implementation

    constructor TNamedCompositeTask.create(const atasks : TNamedTaskArr);
    begin
        fTasks := atasks;
    end;

    function TNamedCompositeTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var taskName : shortString;
        i : integer;
    begin
        result := self;
        taskName := getTaskName(opt, longOpt);
        for i:= 0 to length(fTasks) -1 do
        begin
            if taskName = fTasks[i].name then
            begin
                fTasks[i].task.run(opt, longOpt);
                break;
            end;
        end;
    end;
end.
