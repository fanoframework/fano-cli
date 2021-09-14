(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit ForceConfigSessionDecoratorTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    ForceConfigDecoratorTaskImpl;

type

    (*!--------------------------------------
     * Task that force --config and--with-session
     * parameter always set
     *---------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TForceConfigSessionDecoratorTask = class(TForceConfigDecoratorTask)
    public
        function hasOption(const longOpt: string) : boolean; override;
        function getOptionValue(const longOpt: string) : string; override;
        function getOptionValueDef(const longOpt: string; const defValue : string) : string; override;
    end;

implementation

    function TForceConfigSessionDecoratorTask.hasOption(const longOpt: string) : boolean;
    begin
        result := inherited hasOption(longOpt);
        if (longOpt = 'with-session') and (result = false) then
        begin
            //--with-session not set but we force --with-session parameter always set
            result := true;
        end;
    end;

    function TForceConfigSessionDecoratorTask.getOptionValue(const longOpt: string) : string;
    begin
        result := inherited getOptionValue(longOpt);
        if (longOpt = 'with-session') and (result = '') then
        begin
            //--with-session not set but we force --with-session parameter always set
            result := 'file';
        end;

        if (longOpt = 'type') and (result = '') then
        begin
            //--with-session not set but we force --with-session parameter always set
            result := 'json';
        end;
    end;

    function TForceConfigSessionDecoratorTask.getOptionValueDef(const longOpt: string; const defValue : string) : string;
    begin
        result := inherited getOptionValueDef(longOpt, defValue);
        if (longOpt = 'with-session') and (result = '') then
        begin
            //--with-session not set but we force --with-session parameter always set
            result := 'file';
        end;

        if (longOpt = 'type') and (result = '') then
        begin
            //--with-session not set but we force --with-session parameter always set
            result := 'json';
        end;
    end;

end.
