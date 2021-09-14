(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TCreateMiddlewareTaskFactory.create();
try
    appInst.registerTask(
        'middleware',
        formatColor('--middleware', TXT_GREEN) + '=[middleware-name] Create new middleware',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
