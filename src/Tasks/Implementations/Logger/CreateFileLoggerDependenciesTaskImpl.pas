(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateFileLoggerDependenciesTaskImpl;

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
    TCreateFileLoggerDependenciesTask = class(TAbstractCreateLoggerDependenciesTask)
    protected
        procedure createDependencies(
            const dir : string;
            const opt : ITaskOptions;
            const projectType : shortstring
        ); override;
    public
    end;

implementation

    procedure TCreateFileLoggerDependenciesTask.createDependencies(
        const dir : string;
        const opt : ITaskOptions;
        const projectType : shortstring
    );
    var
        {$INCLUDE src/Tasks/Implementations/Logger/Includes/filelogger.dependencies.inc}
        appDir : string;
    begin
        if (projectType = 'project-cgi') or (projectType = 'project-fcgid') then
        begin
            appDir := 'extractFileDir(getCurrentDir())';
        end else
        begin
            appDir := 'getCurrentDir()';
        end;
        fContentModifier.setVar('[[BASE_DIR]]', appDir);

        fFileAppender.append(
            dir + DirectorySeparator + 'main.dependencies.inc',
            fContentModifier.modify(strLoggerDependencies)
        );
    end;

end.
