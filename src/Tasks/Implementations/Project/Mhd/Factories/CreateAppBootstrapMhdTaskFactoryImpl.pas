(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateAppBootstrapMhdTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf,
    TextFileCreatorIntf,
    ContentModifierIntf,
    CreateAppBootstrapTaskFactoryImpl;

type

    (*!--------------------------------------
     * factory class for http application bootstrap task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateAppBootstrapMhdTaskFactory = class(TCreateAppBootstrapTaskFactory)
    protected
        function buildBootstrapTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask; override;
    end;

implementation

uses

    GroupTaskImpl,

    CreateMhdAppFileTaskImpl,
    CreateMhdReadmeFileTaskImpl,
    CreateDaemonBootstrapFileTaskImpl,
    CreateDepFileTaskImpl,
    CreateRouteFileTaskImpl;


    function TCreateAppBootstrapMhdTaskFactory.buildBootstrapTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    begin
        result := TGroupTask.create([
            TCreateMhdAppFileTask.create(textFileCreator, contentModifier),
            TCreateMhdReadmeFileTask.create(textFileCreator, contentModifier),
            TCreateDaemonBootstrapFileTask.create(textFileCreator, contentModifier),
            TCreateDepFileTask.create(textFileCreator, contentModifier),
            TCreateRouteFileTask.create(textFileCreator, contentModifier)
        ]);
    end;

end.
