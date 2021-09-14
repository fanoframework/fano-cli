(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strScgiVhostConf: string =
    'server {' + LineEnding +
    '' + LineEnding +
    '    listen 80;' + LineEnding +
    '    root "[[DOC_ROOT]]";' + LineEnding +
    '' + LineEnding +
    '    server_name [[SERVER_NAME]] *.[[SERVER_NAME]];' + LineEnding +
    '' + LineEnding +
    '    error_log "[[NGINX_LOG_DIR]]' + DirectorySeparator + '[[SERVER_NAME]]-error.log";' + LineEnding +
    '    access_log "[[NGINX_LOG_DIR]]' + DirectorySeparator + '[[SERVER_NAME]]-access.log";' + LineEnding +
    '' + LineEnding +
    '    location / {' + LineEnding +
    '        try_files $uri @[[SERVER_NAME]];' + LineEnding +
    '    }' + LineEnding +
    '' + LineEnding +
    '    location @[[SERVER_NAME]] {' + LineEnding +
    '        scgi_pass [[HOST]]:[[PORT]];' + LineEnding +
    '        include scgi_params;' + LineEnding +
    '    }' + LineEnding +
    '' + LineEnding +
    '}';
