(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{%../Includes/task.registrations.inc}

appInst.registerTask(
    'txt2inc',
    formatColor('--txt2inc', TXT_GREEN) + ' Generate Pascal string variable declaration from file string.' + LineEnding +
    '     --src=[source file path] if omitted, STDIN is used.' + LineEnding +
    '     --dst=[destination file path]' + LineEnding +
    '           if omitted and --src is set, use --src file path concatenated with inc extension' + LineEnding +
    '           if omitted and --src is not set, output to STDOUT.' + LineEnding +
    '     --var=[name of variable] if omitted, "myStr" is used.' + LineEnding,
    TText2IncTask.create()
);
