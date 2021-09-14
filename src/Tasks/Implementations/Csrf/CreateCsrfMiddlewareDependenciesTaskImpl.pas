(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateCsrfMiddlewareDependenciesTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    TextFileCreatorIntf,
    ContentModifierIntf,
    FileContentAppenderIntf,
    CreateFileTaskImpl;

type

    (*!--------------------------------------
     * task that add CSRF middleware to project
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateCsrfMiddlewareDependenciesTask = class(TCreateFileTask)
    protected
        fFileAppender : IFileContentAppender;
        procedure createDependencies(const dir : string);
    public
        constructor create(
            const txtFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier;
            const fAppend : IFileContentAppender
        );

        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

    constructor TCreateCsrfMiddlewareDependenciesTask.create(
        const txtFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier;
        const fAppend : IFileContentAppender
    );
    begin
        inherited create(txtFileCreator, contentModifier);
        fFileAppender := fAppend;
    end;

    procedure TCreateCsrfMiddlewareDependenciesTask.createDependencies(const dir : string);
    var
        {$INCLUDE src/Tasks/Implementations/Csrf/Includes/csrf.dependencies.inc}
    begin
        fFileAppender.append(
            dir + DirectorySeparator + 'middlewares.dependencies.inc',
            strCsrfDependencies
        );
    end;

    function TCreateCsrfMiddlewareDependenciesTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        //need to call parent run() so baseDirectory can be initialized
        inherited run(opt, longOpt);
        createDependencies(baseDirectory + '/src/Dependencies');
        result := self;
    end;
end.
