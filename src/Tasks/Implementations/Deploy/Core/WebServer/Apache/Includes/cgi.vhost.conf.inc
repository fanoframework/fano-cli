(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strCgiVhostConf: string =
    '<VirtualHost *:80>' + LineEnding +
    '' + LineEnding +
    '    ServerAdmin admin@[[SERVER_NAME]]' + LineEnding +
    '    DocumentRoot "[[DOC_ROOT]]"' + LineEnding +
    '' + LineEnding +
    '    ServerName [[SERVER_NAME]]' + LineEnding +
    '    ServerAlias *.[[SERVER_NAME]]' + LineEnding +
    '' + LineEnding +
    '    ErrorLog [[APACHE_LOG_DIR]]' + DirectorySeparator + '[[SERVER_NAME]]-error.log' + LineEnding +
    '    CustomLog [[APACHE_LOG_DIR]]' + DirectorySeparator + '[[SERVER_NAME]]-access.log combined' + LineEnding +
    '' + LineEnding +
    '    <Directory "[[DOC_ROOT]]">' + LineEnding +
    '        Options -MultiViews -FollowSymlinks +SymlinksIfOwnerMatch +ExecCGI' + LineEnding +
    '        AllowOverride FileInfo Indexes' + LineEnding +
    '        Require all granted' + LineEnding +
    '        AddHandler cgi-script .cgi' + LineEnding +
    '        DirectoryIndex app.cgi' + LineEnding +
    '' + LineEnding +
    '        <IfModule mod_rewrite.c>' + LineEnding +
    '            RewriteEngine On' + LineEnding +
    '' + LineEnding +
    '            # redirect http to https' + LineEnding +
    '            # RewriteCond %{HTTPS} off' + LineEnding +
    '            # RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]' + LineEnding +
    '' + LineEnding +
    '            RewriteCond %{REQUEST_FILENAME} !-d' + LineEnding +
    '            RewriteCond %{REQUEST_FILENAME} !-f' + LineEnding +
    '            RewriteRule ^(.*)$ app.cgi [L]' + LineEnding +
    '        </IfModule>' + LineEnding +
    '' + LineEnding +
    '    </Directory>' + LineEnding +
    '' + LineEnding +
    '</VirtualHost>';
