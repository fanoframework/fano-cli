(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)

{$INCLUDE Deploy/units.inc}
{$INCLUDE Info/units.inc}

KeyGenTaskImpl,
KeyGenTaskFactoryImpl,
GuidGenTaskImpl,
Text2IncTaskImpl,

{$INCLUDE Project/units.inc}

CreateControllerTaskFactoryImpl,
CreateViewTaskFactoryImpl,
CreateModelTaskFactoryImpl,
CreateMvcTaskFactoryImpl,
CreateMiddlewareTaskFactoryImpl,
JsMinifierTaskFactoryImpl,
CssMinifierTaskFactoryImpl,
SystemDDaemonTaskFactoryImpl;
