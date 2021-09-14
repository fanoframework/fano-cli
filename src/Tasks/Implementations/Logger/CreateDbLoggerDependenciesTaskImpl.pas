(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateDbLoggerDependenciesTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    AbstractCreateLoggerDependenciesTaskImpl;

type

    (*!--------------------------------------
     * Task that add logger support to project creation
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateDbLoggerDependenciesTask = class(TAbstractCreateLoggerDependenciesTask)
    protected
        procedure createDependencies(
            const dir : string;
            const opt : ITaskOptions;
            const projectType : shortstring
        ); override;
    end;

implementation

    procedure TCreateDbLoggerDependenciesTask.createDependencies(
        const dir : string;
        const opt : ITaskOptions;
        const projectType : shortstring
    );
    var
        {$INCLUDE src/Tasks/Implementations/Logger/Includes/dblogger.dependencies.inc}
    begin
        fFileAppender.append(
            dir + DirectorySeparator + 'main.dependencies.inc',
            strLoggerDependencies
        );
    end;
end.
