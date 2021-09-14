(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strBalancerVhostConf: string =
    '<VirtualHost *:80>' + LineEnding +
    '' + LineEnding +
    '    ServerAdmin admin@[[SERVER_NAME]]' + LineEnding +
    '    DocumentRoot "[[DOC_ROOT]]"' + LineEnding +
    '' + LineEnding +
    '    ServerName [[SERVER_NAME]]' + LineEnding +
    '    ServerAlias *.[[SERVER_NAME]]' + LineEnding +
    '' + LineEnding +
    '    ErrorLog "[[APACHE_LOG_DIR]]' + DirectorySeparator + '[[SERVER_NAME]]-error.log"' + LineEnding +
    '    CustomLog "[[APACHE_LOG_DIR]]' + DirectorySeparator + '[[SERVER_NAME]]-access.log" combined' + LineEnding +
    '' + LineEnding +
    '    <Directory "[[DOC_ROOT]]">' + LineEnding +
    '        Options -MultiViews -FollowSymlinks +SymlinksIfOwnerMatch +ExecCGI' + LineEnding +
    '        AllowOverride FileInfo Indexes' + LineEnding +
    '        Require all granted' + LineEnding +
    '    </Directory>' + LineEnding +
    '' + LineEnding +
    '    <Proxy balancer://[[SERVER_NAME]]> ' + LineEnding +
    '        [[LOAD_BALANCER_MEMBERS]] ' + LineEnding +
    '        ProxySet lbmethod=[[LOAD_BALANCER_METHOD]] ' + LineEnding +
    '    </Proxy> ' + LineEnding +
    '    ProxyRequests Off' + LineEnding +
    '    ProxyPassMatch "/css|js|images|img|plugins|bower_components(.*)|webfonts" !' + LineEnding +
    '    ProxyPassMatch ^/(.*)$ "balancer://[[SERVER_NAME]]"' + LineEnding +
    '</VirtualHost>';
