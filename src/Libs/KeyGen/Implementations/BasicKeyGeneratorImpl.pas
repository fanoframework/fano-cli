(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit BasicKeyGeneratorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    KeyGeneratorIntf

    {$IFDEF WINDOWS}
    ,jwawincrypt
    {$ENDIF};

type

    (*!--------------------------------------
     * Interface for class that having capability
     * to generate random key
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TBasicKeyGenerator = class(TInterfacedObject, IKeyGenerator)
    private
        {$IFDEF WINDOWS}
        FProvider: HCRYPTPROV;
        {$ENDIF}

        function readRandomBytes(const numberOfBytes : integer) : TBytes;
        function encodeB64(aob: TBytes): string;
    public
        constructor create();
        destructor destroy(); override;
        function generate(const len : integer; const prefix : string = '') : string;
    end;

implementation

uses

    Classes,
    Base64
    {$IFDEF UNIX}
    , BaseUnix
    {$ENDIF};

    constructor TBasicKeyGenerator.create();
    {$IFDEF WINDOWS}
    var ctxAcquired : boolean;
    {$ENDIF}
    begin
        {$IFDEF WINDOWS}
        ctxAcquired := CryptAcquireContext(
            FProvider,
            nil,
            nil,
            PROV_RSA_FULL,
            CRYPT_VERIFYCONTEXT or CRYPT_SILENT
        );
        if not ctxAcquired then
        begin
            raiseLastOSError();
        end;
        {$ENDIF}
    end;

    destructor TBasicKeyGenerator.destroy();
    begin
        {$IFDEF WINDOWS}
        if FProvider <> 0 then
        begin
            CryptReleaseContext(FProvider, 0);
        end;
        {$ENDIF}
        inherited destroy();
    end;

    {$IFDEF UNIX}
    function TBasicKeyGenerator.readRandomBytes(const numberOfBytes : integer) : TBytes;
    var fs : TFileStream;
        bytes : TBytes;
    begin
        fs := TFileStream.create('/dev/urandom', fmOpenRead);
        try
            setLength(bytes, numberOfBytes);
            fs.readBuffer(bytes[0], numberOfBytes);
            result := bytes;
        finally
            fs.free();
        end;
    end;
    {$ENDIF}

    {$IFDEF WINDOWS}
    (*!------------------------------------------------
     * read random bytes using Windows CryptoAPI
     *-------------------------------------------------
     * @author: ASerge
     * @credit: https://forum.lazarus.freepascal.org/index.php/topic,35523.msg235007.html#msg235007
     *-------------------------------------------------*)
    function TBasicKeyGenerator.readRandomBytes(const numberOfBytes : integer) : TBytes;
    var resAddr : PByte;
    begin
        result := default(TBytes);
        setLength(result, numberOfBytes);
        resAddr := @result[0];
        if not CryptGenRandom(FProvider, numberOfBytes, resAddr) then
        begin
            raiseLastOSError();
        end;
    end;
    {$ENDIF}

    (*!------------------------------------------------
     * encode array of bytes to Base64 string
     *-------------------------------------------------
     * @param aob array of bytes
     * @return Base64 encoded string
     *-------------------------------------------------
     * @author: howardpc
     * @credit: https://forum.lazarus.freepascal.org/index.php?topic=23646.0
     *-------------------------------------------------*)
    function TBasicKeyGenerator.encodeB64(aob: TBytes): string;
    var
        i: integer;
        tmp: string;
    begin
        setLength(tmp, length(aob));
        for i := low(aob) to high(aob) do
        begin
            tmp[i+1] := char(aob[i]);
        end;
        result := encodeStringBase64(tmp);
    end;

    function TBasicKeyGenerator.generate(const len : integer; const prefix : string = '') : string;
    begin
        result := prefix + encodeB64(readRandomBytes(len));
    end;

end.
