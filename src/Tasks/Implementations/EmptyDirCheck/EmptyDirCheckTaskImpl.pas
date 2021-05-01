(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit EmptyDirCheckTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    DecoratorTaskImpl;

type

    (*!--------------------------------------
     * Task that run other task only if
     * target directory is not exists or empty
     *------------------------------------------
     * This is to protect creating project accidentally
     * on existing directory that contain any files.
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TEmptyDirCheckTask = class(TDecoratorTask)
    private
        function isDirectoryEmpty(baseDir: string): boolean;
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    SysUtils,
    strformats;

resourcestring

    sDirExistsNotEmpty = 'Cannot run task. Directory %s is exists and not empty.';
    sRunWithHelp = 'Run with --help option to view available task.';

    (*!-------------------------------------------
     * test directory is empty
     *--------------------------------------------
     * @param baseDir directory to be checked
     * @return true if directory is empty
     *--------------------------------------------
     * @credit http://wiki.freepascal.org/is_Directory_empty/de
     *--------------------------------------------*)
    function TEmptyDirCheckTask.isDirectoryEmpty(baseDir: string): boolean;
    var
        srcRec : TSearchRec;
        indx : integer;
    begin
        result := false;
        findFirst(
            includeTrailingPathDelimiter(baseDir) + '*',
            faAnyFile,
            srcRec
        );

        for indx := 1 to 2 do
        begin
            if (srcRec.name = '.') or (srcRec.name = '..') then
            begin
                result := (findNext(srcRec) <> 0);
            end;
        end;
        findClose(srcRec);
    end;

    function TEmptyDirCheckTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var baseDir : string;
    begin
        baseDir := opt.getOptionValue(longOpt);
        if ((not directoryExists(baseDir)) or isDirectoryEmpty(baseDir)) then
        begin
            fActualTask.run(opt, longOpt);
        end else
        begin
            writeln(format(sDirExistsNotEmpty, [formatColor(baseDir, TXT_GREEN)]));
            writeln(sRunWithHelp);
        end;
        result := self;
    end;
end.
