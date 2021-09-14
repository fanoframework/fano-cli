#------------------------------------------------------------
# Fano CLI Application (https://fanoframework.github.io)
#
# @link      https://github.com/fanoframework/fano-cli
# @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
# @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
#-------------------------------------------------------------
#!/bin/bash

#------------------------------------------------------
# Scripts to setup configuration files
#------------------------------------------------------

cp build.prod.cfg.sample build.prod.cfg
cp build.dev.cfg.sample build.dev.cfg
cp build.cfg.sample build.cfg

# replace target compilation based on platform
if [["$OSTYPE" == "freebsd"*]]; then
    sed -i '' 's/\-Tlinux/\-Tfreebsd/g' build.cfg
elif [["$OSTYPE" == "msys"*]]; then
    sed -i '' 's/\-Tlinux/\-Twin64/g' build.cfg
fi