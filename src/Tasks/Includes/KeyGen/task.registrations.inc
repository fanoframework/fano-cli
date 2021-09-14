(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TKeyGenTaskFactory.create();
try
    appInst.registerTask(
        'key',
        formatColor('--key', TXT_GREEN) + '=[length] Generate random key.',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
