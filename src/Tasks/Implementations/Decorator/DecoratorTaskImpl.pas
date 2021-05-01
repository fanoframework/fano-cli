(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit DecoratorTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf;

type

    (*!--------------------------------------
     * Task that decorate other task
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TDecoratorTask = class(TInterfacedObject, ITask)
    protected
        fActualTask : ITask;
    public
        constructor create(const task : ITask);
        destructor destroy(); override;

        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; virtual;
    end;

implementation

    constructor TDecoratorTask.create(const task : ITask);
    begin
        fActualTask := task;
    end;

    destructor TDecoratorTask.destroy();
    begin
        fActualTask := nil;
        inherited destroy();
    end;

    function TDecoratorTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        fActualTask.run(opt, longOpt);
        result := self;
    end;
end.
