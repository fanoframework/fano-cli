(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TSystemDDaemonTaskFactory.create();
try
    appInst.registerTask(
        'daemon-sysd',
        formatColor('--daemon-sysd', TXT_GREEN) + '=[service name] Register daemon as service in SystemD.' + LineEnding +
        '     --user=[username] User whose service will be run as. If not set, current non-root user is used.' + LineEnding +
        '     --bin=[application binary] Path of executable binary. If not set then, default bin/app.cgi is used.',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
