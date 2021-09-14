(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

unit StrFormats;

interface

{$MODE OBJFPC}
{$H+}

const

    TXT_BLACK = 30;
    TXT_RED = 31;
    TXT_GREEN = 32;
    TXT_YELLOW = 33;
    TXT_BLUE = 34;
    TXT_MAGENTA = 35;
    TXT_CYAN = 36;
    TXT_LIGHT_GREY = 37;
    TXT_DEFAULT = 39;
    TXT_DARK_GREY = 90;
    TXT_LIGHT_RED = 91;
    TXT_LIGHT_GREEN = 92;
    TXT_LIGHT_YELLOW = 93;
    TXT_LIGHT_BLUE = 94;
    TXT_LIGHT_MAGENTA = 95;
    TXT_LIGHT_CYAN = 96;
    TXT_WHITE = 97;

    (*!--------------------------------------
     * display string with color
     *---------------------------------------
     * @param astr string to display as
     *---------------------------------------*)
    function formatColor(const astr : string; const col: byte) : string;

implementation

uses

    SysUtils;

    function formatColor(const astr : string; const col: byte) : string;
    begin
        {$IFDEF WINDOWS}
        //do nothing on Windows
        result := astr;
        {$ELSE}
        result := format(#27'[1;%dm%s'#27'[0m', [col, astr]);
        {$ENDIF}
    end;
end.
