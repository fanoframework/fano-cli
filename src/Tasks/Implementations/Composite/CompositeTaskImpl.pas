(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CompositeTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf;

type

    (*!--------------------------------------
     * Task that compose from other tasks
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCompositeTask = class(TInterfacedObject, ITask)
    protected
        firstTask : ITask;
        secondTask : ITask;
    public
        constructor create(const frstTask : ITask; const secTask : ITask);
        destructor destroy(); override;

        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; virtual;
    end;

implementation

    constructor TCompositeTask.create(const frstTask : ITask; const secTask : ITask);
    begin
        firstTask := frstTask;
        secondTask := secTask;
    end;

    destructor TCompositeTask.destroy();
    begin
        firstTask := nil;
        secondTask := nil;
        inherited destroy();
    end;

    function TCompositeTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        firstTask.run(opt, longOpt);
        secondTask.run(opt, longOpt);
        result := self;
    end;
end.
