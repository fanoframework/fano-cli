(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TCreateProjectTaskFactory.create(
    TCreateProjectDependenciesTaskFactory.create(),
    TCreateAppBootstrapCgiTaskFactory.create()
);
try
    appInst.registerTask(
        'project-cgi',
        formatColor('--project-cgi', TXT_GREEN) + '=[project-name] Create new CGI project.' + LineEnding +
        '     --config=[json, ini] Type of generated application config. If omitted, json is assumed.' + LineEnding +
        '     --with-session=[file, cookie, db] Add session support' + LineEnding +
        '     --with-middleware Add middleware support' + LineEnding +
        '     --with-csrf Add CSRF support' + LineEnding +
        '     --with-logger=[file, db, syslog] Add logger dependencies' + LineEnding +
        '     --no-git if omitted, git repository is created.' + LineEnding +
        '     --no-initial-commit if omitted, git repository is created with initial commit.',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
