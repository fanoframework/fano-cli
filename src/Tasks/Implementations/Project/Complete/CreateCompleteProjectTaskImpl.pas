(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateCompleteProjectTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    WithOptionsDecoratorTaskImpl;

type

    (*!--------------------------------------
     * Task that create full-featured web application project
     * directory structure using fano web framework
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateCompleteProjectTask = class(TWithOptionsDecoratorTask)
    private
        function isSupportedProject(const longOpt : string) : boolean;
    public
        function hasOption(const longOpt: string) : boolean; override;
        function getOptionValue(const longOpt: string) : string; override;
        function getOptionValueDef(const longOpt: string; const defValue : string) : string; override;
    end;

implementation

    function TCreateCompleteProjectTask.hasOption(const longOpt: string) : boolean;
    begin
        result := fOrigOpts.hasOption(longOpt) or
            //make full-featured project by pretending all command line options
            //is set if they are not set
            (longOpt = 'with-middleware') or
            (longOpt = 'config') or
            (longOpt = 'with-session') or
            (longOpt = 'with-csrf');
    end;

    function TCreateCompleteProjectTask.isSupportedProject(const longOpt : string) : boolean;
    begin
        result := (longOpt = 'project-cgi') or
            (longOpt = 'project-fcgi') or
            (longOpt = 'project-fcgid') or
            (longOpt = 'project-scgi') or
            (longOpt = 'project-uwgi') or
            (longOpt = 'project-mhd');
    end;

    function TCreateCompleteProjectTask.getOptionValue(const longOpt: string) : string;
    begin
        if isSupportedProject(longOpt) then
        begin
            result := fOrigOpts.getOptionValue('project');
        end else
        begin
            result := fOrigOpts.getOptionValue(longOpt);
        end;
    end;

    function TCreateCompleteProjectTask.getOptionValueDef(const longOpt: string; const defValue : string) : string;
    begin
        if isSupportedProject(longOpt) then
        begin
            result := fOrigOpts.getOptionValueDef('project', defValue);
        end else
        begin
            result := fOrigOpts.getOptionValueDef(longOpt, defValue);
        end;
    end;
end.
