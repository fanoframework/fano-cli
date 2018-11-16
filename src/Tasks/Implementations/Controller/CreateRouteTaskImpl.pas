(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateRouteTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    FileContentReaderIntf,
    FileContentWriterIntf,
    DirectoryCreatorIntf;

type

    (*!--------------------------------------
     * Task that add controller route
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateRouteTask = class(TInterfacedObject, ITask)
    private
        fileReader : IFileContentReader;
        fileWriter : IFileContentWriter;
        directoryCreator : IDirectoryCreator;
    public
        constructor create(
            fReader : IFileContentReader;
            fWriter : IFileContentWriter;
            dirCreator : IDirectoryCreator
        );

        destructor destroy(); override;

        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask;
    end;

implementation

uses

    SysUtils,
    Classes;

const

    BASE_ROUTE_DIR = 'src' + DirectorySeparator + 'Routes' + DirectorySeparator;

    constructor TCreateRouteTask.create(
        fReader : IFileContentReader;
        fWriter : IFileContentWriter;
        dirCreator : IDirectoryCreator
    );
    begin
        fileReader := fReader;
        fileWriter := fWriter;
        directoryCreator := dirCreator;
    end;

    destructor TCreateRouteTask.destroy();
    begin
        inherited destroy();
        fileReader := nil;
        fileWriter := nil;
        directoryCreator := nil;
    end;

    function TCreateRouteTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var controllerName : string;
        routeContent : string;
        {$INCLUDE src/Tasks/Implementations/Controller/Includes/routes.inc.inc}
    begin
        controllerName := opt.getOptionValue(longOpt);
        //create main entry to main routes file
        routeContent := fileReader.read(BASE_ROUTE_DIR + 'routes.inc');
        routeContent := routeContent +
            '{$INCLUDE ' + controllerName + '/routes.inc}' + LineEnding;
        fileWriter.write(BASE_ROUTE_DIR + 'routes.inc', routeContent);

        //create controller route file
        directoryCreator.createDirIfNotExists(BASE_ROUTE_DIR + controllerName);
        strCtrlRoutesInc := strCtrlRoutesInc + LineEnding +
            format(
              'router.get(''/%s'', container.get(''%sController'') as IRouteHandler);',
              [lowerCase(controllerName), lowerCase(controllerName)]
            ) + LineEnding;
        fileWriter.write(BASE_ROUTE_DIR + controllerName + '/routes.inc', strCtrlRoutesInc);

        result := self;
    end;
end.