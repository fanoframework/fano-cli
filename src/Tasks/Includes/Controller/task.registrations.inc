(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TCreateControllerTaskFactory.create();
try
    appInst.registerTask(
        'controller',
        formatColor('--controller', TXT_GREEN) + '=[controller-name] Create new controller' + LineEnding +
        '     --route=[route pattern] if omitted, controller name is assumed.' + LineEnding +
        '     --method=[request method] if omitted, HTTP GET is assumed.',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
