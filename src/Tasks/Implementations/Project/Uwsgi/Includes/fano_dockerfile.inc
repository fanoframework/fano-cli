strDockerfile : string =
    '#------------------------------------------------------------' + LineEnding +
    '# [[APP_NAME]] ([[APP_URL]])' + LineEnding +
    '#' + LineEnding +
    '# @link      [[APP_REPOSITORY_URL]]' + LineEnding +
    '# @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]' + LineEnding +
    '# @license   [[LICENSE_URL]] ([[LICENSE]])' + LineEnding +
    '#--------------------------------------------------------------' + LineEnding +
    '' + LineEnding +
    '#-----------------------------------' + LineEnding +
    '# use Ubuntu 20.04' + LineEnding +
    '#-----------------------------------' + LineEnding +
    'FROM ubuntu' + LineEnding +
    '' + LineEnding +
    'COPY ./config/ /usr/local/fano/config' + LineEnding +
    'COPY ./resources/ /usr/local/fano/resources' + LineEnding +
    'COPY ./public/ /usr/local/fano/public' + LineEnding +
    'COPY ./bin/app.cgi /usr/local/fano/app.cgi' + LineEnding +
    'WORKDIR /usr/local/fano/' + LineEnding +
    'CMD ["/usr/local/fano/app.cgi", "--host=0.0.0.0", "--port=7704"]' + LineEnding;
