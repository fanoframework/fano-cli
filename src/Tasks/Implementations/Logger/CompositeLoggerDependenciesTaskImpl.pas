(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CompositeLoggerDependenciesTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    NamedCompositeTaskImpl;

type

    (*!--------------------------------------
     * Task that run task using value of --with-logger options
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCompositeLoggerDependenciesTask = class(TNamedCompositeTask)
    protected
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
        ) : shortstring; override;
    end;

implementation

    (*!--------------------------------------
    * get task name
    *---------------------------------------------
    * @param opt current task options
    * @param longOpt current long option name
    * @return task name string
    *---------------------------------------*)
    function TCompositeLoggerDependenciesTask.getTaskName(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : shortstring;
    begin
        result := opt.getOptionValueDef('with-logger', 'file');
    end;
end.
