strModelDependenciesInc: string =
    '(*!------------------------------------------------------------' + LineEnding +
    ' * [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    ' *' + LineEnding +
    ' * @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    ' * @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    ' * @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    ' *------------------------------------------------------------- *)' + LineEnding +
    '' + LineEnding +
    '{%dependencies.inc}' + LineEnding +
    '' + LineEnding +
    '{---put your dependencies registration here---}' + LineEnding +
    '';