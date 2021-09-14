(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TCreateModelTaskFactory.create();
try
    appInst.registerTask(
        'model',
        formatColor('--model', TXT_GREEN) + '=[model-name] Create new model',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
