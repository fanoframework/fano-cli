(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TCreateCompleteProjectTaskFactory.create();
try
    appInst.registerTask(
        'project',
        '--project=[project-name] Create new full-featured project' + LineEnding +
        '     --protocol=[cgi,fcgi,fcgid,scgi,uwsgi,mhd] if omitted, CGI is assumed.',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
