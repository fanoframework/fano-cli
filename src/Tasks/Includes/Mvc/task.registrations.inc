(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TCreateMvcTaskFactory.create();
try
    appInst.registerTask(
        'mvc',
        formatColor('--mvc', TXT_GREEN) + '=[name] Create new controller, model and view',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
