(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (GPL 3.0)
 *------------------------------------------------------------- *)
unit CreateControllerTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf;

type

    (*!--------------------------------------
     * Task that scaffolding controller class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateControllerTask = class(TInterfacedObject, ITask)
    private
        createControllerFileTask : ITask;
        createControllerFactoryFileTask : ITask;
        createRouteTask : ITask;
    public
        constructor create(
            const createCtrlFileTask : ITask;
            const createCtrlFactoryFileTask : ITask;
            const createCtrlRouteTask : ITask
        );
        destructor destroy(); override;
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask;
    end;

implementation

    constructor TCreateControllerTask.create(
        const createCtrlFileTask : ITask;
        const createCtrlFactoryFileTask : ITask;
        const createCtrlRouteTask : ITask
    );
    begin
        createControllerFileTask := createCtrlFileTask;
        createControllerFactoryFileTask := createCtrlFactoryFileTask;
        createRouteTask := createCtrlRouteTask;
    end;

    destructor TCreateControllerTask.destroy();
    begin
        inherited destroy();
        createControllerFileTask := nil;
        createControllerFactoryFileTask := nil;
        createRouteTask := nil;
    end;

    function TCreateControllerTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        createControllerFileTask.run(opt, longOpt);
        createControllerFactoryFileTask.run(opt, longOpt);
        createRouteTask.run(opt, longOpt);
        result := self;
    end;
end.
