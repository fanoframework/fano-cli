(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit AbstractCreateLoggerDependenciesTaskImpl;

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
     * Abstract task that add logger support to project creation
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TAbstractCreateLoggerDependenciesTask = class abstract (TCreateFileTask)
    protected
        fFileAppender : IFileContentAppender;

        procedure createDependencies(
            const dir : string;
            const opt : ITaskOptions;
            const projectType : shortstring
        ); virtual; abstract;

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

    constructor TAbstractCreateLoggerDependenciesTask.create(
        const txtFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier;
        const fAppend : IFileContentAppender
    );
    begin
        inherited create(txtFileCreator, contentModifier);
        fFileAppender := fAppend;
    end;

    function TAbstractCreateLoggerDependenciesTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        //need to call parent run() so baseDirectory can be initialized
        inherited run(opt, longOpt);
        createDependencies(baseDirectory + '/src/Dependencies', opt, longOpt);
        result := self;
    end;
end.
