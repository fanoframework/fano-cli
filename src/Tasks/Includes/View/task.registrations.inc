(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TCreateViewTaskFactory.create();
try
    appInst.registerTask(
        'view',
        formatColor('--view', TXT_GREEN) + '=[view-name] Create new view',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
