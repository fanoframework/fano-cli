(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CompositeWpoTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    ConditionalCompositeTaskImpl;

type

    (*!--------------------------------------
     * whole program optimization (WPO) task that run
     * first task if option --with-wpo is set otherwise run
     * second task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCompositeWpoTask = class(TConditionalCompositeTask)
    protected
        function condition(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : boolean; override;
    end;

implementation

    function TCompositeWpoTask.condition(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : boolean;
    begin
        result := opt.hasOption('with-wpo');
    end;
end.
