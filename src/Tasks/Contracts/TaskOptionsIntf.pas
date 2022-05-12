(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit TaskOptionsIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!--------------------------------------
     * interface for any class having capability
     * to query command line options of a task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    ITaskOptions = interface
        ['{D2AF03BD-3B30-4C1D-9F14-3BAEE0E17C23}']
        function hasOption(const longOpt: string) : boolean;
        function getOptionValue(const longOpt: string) : string;
        function getOptionValueDef(const longOpt: string; const defValue : string) : string;
    end;

implementation

end.
