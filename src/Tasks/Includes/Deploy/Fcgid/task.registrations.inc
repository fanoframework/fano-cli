(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TXDeployFCgidTaskFactory.create();
try
    appInst.registerTask(
        'deploy-fcgid',
        formatColor('--deploy-fcgid', TXT_GREEN) + '=[server name] Deploy as FastCGI web application with mod_fcgid.' + LineEnding +
        '     --doc-root=[document-root] if omitted, public directory in current directory is used.' + LineEnding +
        '     --server-ip=[web server ip] if omitted, 127.0.0.1 is assumed.',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
