(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateCompleteProjectTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf;

type

    (*!--------------------------------------
     * Factory class for create project task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateCompleteProjectTaskFactory = class(TInterfacedObject, ITaskFactory)
    public
        function build() : ITask;
    end;

implementation

uses

    CreateCompleteProjectTaskImpl,
    AllProtocolProjectTaskImpl,
    NamedCompositeTaskImpl,
    CreateProjectTaskFactoryImpl,
    CreateDaemonProjectTaskFactoryImpl,
    CreateProjectDependenciesTaskFactoryImpl,
    CreateAppBootstrapCgiTaskFactoryImpl,
    CreateAppBootstrapFcgiTaskFactoryImpl,
    CreateAppBootstrapFcgidTaskFactoryImpl,
    CreateAppBootstrapScgiTaskFactoryImpl,
    CreateAppBootstrapUwsgiTaskFactoryImpl,
    CreateAppBootstrapMhdTaskFactoryImpl,
    CreateProjectDependenciesMhdTaskFactoryImpl;


    function TCreateCompleteProjectTaskFactory.build() : ITask;
    var namedTask : TNamedTaskArr;
        taskFactory : ITaskFactory;
    begin
        setLength(namedTask, 6);

        taskFactory := TCreateProjectTaskFactory.create(
            TCreateProjectDependenciesTaskFactory.create(),
            TCreateAppBootstrapCgiTaskFactory.create()
        );
        namedTask[0].name := 'cgi';
        namedTask[0].task := taskFactory.build();

        taskFactory := TCreateDaemonProjectTaskFactory.create(
            TCreateProjectDependenciesTaskFactory.create(),
            TCreateAppBootstrapFcgiTaskFactory.create()
        );
        namedTask[1].name := 'fcgi';
        namedTask[1].task := taskFactory.build();

        taskFactory := TCreateDaemonProjectTaskFactory.create(
            TCreateProjectDependenciesTaskFactory.create(),
            TCreateAppBootstrapFcgidTaskFactory.create(),
            'public'
        );
        namedTask[2].name := 'fcgid';
        namedTask[2].task := taskFactory.build();

        taskFactory := TCreateDaemonProjectTaskFactory.create(
            TCreateProjectDependenciesTaskFactory.create(),
            TCreateAppBootstrapScgiTaskFactory.create()
        );
        namedTask[3].name := 'scgi';
        namedTask[3].task := taskFactory.build();

        taskFactory := TCreateDaemonProjectTaskFactory.create(
            TCreateProjectDependenciesTaskFactory.create(),
            TCreateAppBootstrapUwsgiTaskFactory.create()
        );
        namedTask[4].name := 'uwsgi';
        namedTask[4].task := taskFactory.build();

        taskFactory := TCreateDaemonProjectTaskFactory.create(
            TCreateProjectDependenciesMhdTaskFactory.create(
                TCreateProjectDependenciesTaskFactory.create()
            ),
            TCreateAppBootstrapMhdTaskFactory.create()
        );
        namedTask[5].name := 'mhd';
        namedTask[5].task := taskFactory.build();

        result := TCreateCompleteProjectTask.create(
            TAllProtocolProjectTask.create(namedTask)
        );
    end;

end.
