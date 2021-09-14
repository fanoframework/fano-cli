(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit SingleInfoTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ListIntf,
    TaskOptionsIntf,
    TaskIntf;

type

    (*!--------------------------------------
     * Task that display help information
     * for single task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TSingleInfoTask = class(TInterfacedObject, ITask)
    private
        fTaskList : IList;
    public
        constructor create(const tasks : IList);
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask;
    end;

implementation

uses

    TaskItemTypes;

    constructor TSingleInfoTask.create(const tasks : IList);
    begin
        fTaskList := tasks;
    end;

    function findTask(const taskList : IList; const taskName : string) : PTaskItem;
    var i, taskCount : integer;
        item : PTaskItem;
    begin
        result := nil;
        taskCount := taskList.count();
        for i:=0 to taskCount-1 do
        begin
            item := taskList.get(i);
            if taskName = item^.longOption then
            begin
                result := item;
                exit;
            end;
        end;
    end;

    function TSingleInfoTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var taskName : string;
        taskItem : PTaskItem;
    begin
        taskName := opt.getOptionValue('task');
        taskItem := findTask(fTaskList, taskName);

        writeln('Fano CLI, utility for Fano Framework');
        writeln('https://fanoframework.github.io');
        writeln();

        if (taskItem = nil) then
        begin
            writeln('Task ' + taskName + ' is not found.');
        end else
        begin
            writeln('Usage: fanocli --' + taskName + ' [Task Parameters]');
            writeln();
            writeln('   ', taskItem^.description);
        end;
        result := self;
    end;
end.
