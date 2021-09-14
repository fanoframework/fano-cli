(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateDirTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    DirectoryCreatorIntf,
    BaseProjectTaskImpl;

type

    (*!--------------------------------------
     * Task that create web application project
     * directory structure using fano web framework
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateDirTask = class(TBaseProjectTask)
    private
        directoryCreator : IDirectoryCreator;
        function createDirIfNotExists(const dir : string) : string;
        procedure createDirectoryStructures(const baseDir : string);
    public
        constructor create(const dirCreator : IDirectoryCreator);
        destructor destroy(); override;
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    sysutils;

    constructor TCreateDirTask.create(const dirCreator : IDirectoryCreator);
    begin
        directoryCreator := dirCreator;
    end;

    destructor TCreateDirTask.destroy();
    begin
        inherited destroy();
        directoryCreator := nil;
    end;

    function TCreateDirTask.createDirIfNotExists(const dir : string) : string;
    begin
        result := directoryCreator.createDirIfNotExists(dir);
    end;

    procedure TCreateDirTask.createDirectoryStructures(const baseDir : string);
    var currentDir : string;
    begin
        createDirIfNotExists(baseDir);
        currentDir := getCurrentDir();
        chDir(baseDir);

        createDirIfNotExists('src');
        createDirIfNotExists('src/App');
        createDirIfNotExists('src/Dependencies');
        createDirIfNotExists('src/Routes');
        createDirIfNotExists('config');
        createDirIfNotExists('resources');
        createDirIfNotExists('resources/Templates');
        createDirIfNotExists('resources/scss');
        createDirIfNotExists('resources/js');
        createDirIfNotExists('public');
        createDirIfNotExists('storages');
        createDirIfNotExists('storages/logs');
        createDirIfNotExists('storages/sessions');
        createDirIfNotExists('bin');
        createDirIfNotExists('bin/out');
        createDirIfNotExists('bin/unit');
        createDirIfNotExists('tools');
        createDirIfNotExists('vendor');
        chDir(currentDir);
    end;

    function TCreateDirTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        //need to call parent run() so baseDirectory can be initialized
        inherited run(opt, longOpt);
        createDirectoryStructures(baseDirectory);
        result := self;
    end;
end.
