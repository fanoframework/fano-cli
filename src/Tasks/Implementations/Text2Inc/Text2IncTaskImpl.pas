(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit Text2IncTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    Classes,
    SysUtils;

type

    (*!--------------------------------------
     * Task that convert file string into
     * pascal string variable
     *---------------------------------------------
     * If we have file with content as follows
     * hello world
     * It will create new file with content as follows
     * varName : string =
     * 'hello world';
     *---------------------------------------------
     * @credit https://github.com/zamronypj/txt2inc
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TText2IncTask = class(TInterfacedObject, ITask)
    private
        function readStdIn() : string;
        procedure txt2inc(
            const src : TStrings;
            const dst : TStrings;
            const varName : string
        );
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask;
    end;

implementation

uses

    iostream,
    StrFormats;

    function TText2IncTask.readStdIn() : string;
    var
        buffer: string;
        Count: Integer;
        MyStream: TStringStream;
        InputStream: TIOStream;
    begin
        MyStream := TStringStream.Create('');
        try
            InputStream := TIOStream.Create(iosInput);
            try
                setLength(buffer, 4 * 1024);
                repeat
                    Count := InputStream.read(buffer[1], Length(buffer));
                    if Count > 0 then
                    begin
                        MyStream.write(buffer[1], count);
                    end;
                until Count = 0;
                result := MyStream.dataString;
            finally
                InputStream.Free;
            end;
        finally
            MyStream.Free;
        end;
    end;

    procedure TText2IncTask.txt2inc(
        const src : TStrings;
        const dst : TStrings;
        const varName : string
    );
    var i : integer;
    begin
        dst.add(varName + ' : string = ');

        for i:=0 to src.count-2 do
        begin
            dst.add('    ' + QuotedStr(src[i]) + ' + LineEnding + ');
        end;

        if (src.count > 0) then
        begin
            dst.add('    ' + QuotedStr(src[src.count-1]) + ';');
        end;
    end;

    function TText2IncTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var srcFile : string;
        dstFile : string;
        varName : string;
        src : TStrings;
        dst : TStrings;
    begin
        result := self;
        src:= TStringList.Create();
        try
            dst:= TStringList.Create();
            try
                srcFile := opt.getOptionValue('src');
                if (srcFile = '') or (not opt.hasOption('src')) then
                begin
                    src.text := readStdIn();
                end else
                begin
                    if not FileExists(srcFile) then
                    begin
                        writeln('Error. File ' + formatColor(srcFile, TXT_RED) + ' does not exist.');
                        exit;
                    end;
                    src.loadFromFile(srcFile);
                end;


                dstFile := opt.getOptionValue('dst');
                if (dstFile = '') and (srcFile <> '') then
                begin
                    dstFile := srcFile + '.inc';
                end;

                if (dstFile <> '') and (FileExists(dstFile)) and (not opt.hasOption('force')) then
                begin
                    writeln(
                        'Error. File ' +
                        formatColor(dstFile, TXT_RED) +
                        ' exists. Add ' +
                        formatColor('--force', TXT_GREEN) +
                        ' to overwrite it.'
                    );
                    exit;
                end;

                varName := opt.getOptionValueDef('var', 'myStr');


                txt2inc(src, dst, varName);

                if (dstFile = '') then
                begin
                    writeln();
                    writeln('{-------------begin----------------}');
                    write(dst.text);
                    writeln('{-------------end------------------}');
                    writeln();
                end else
                begin
                    dst.saveToFile(dstFile);
                    writeln('OK. ' + formatColor(dstFile, TXT_GREEN) + ' created');
                end;

            finally
                dst.free();
            end;
        finally
            src.free();
        end;
    end;
end.
