(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

taskFactory := TCssMinifierTaskFactory.create();
try
    appInst.registerTask(
        'cssmin',
        formatColor('--cssmin', TXT_GREEN) + '=[path] Minify CSS file. Path can be file path or directory.' + LineEnding +
        '     --output=[output path] target output path' + LineEnding +
        '         if omitted, it is assumed [path].min.css' + LineEnding +
        '         if output-path = stdout, minified version is output to STDOUT',
        taskFactory.build()
    );
finally
    taskFactory := nil;
end;
