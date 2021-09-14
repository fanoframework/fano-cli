# Fano CLI

Fano CLI is command line tools to help scaffolding web application using [Fano Web Framework](https://github.com/fanoframework/fano).

[![MIT License](https://img.shields.io/github/license/fanoframework/fano-cli.svg)](https://github.com/fanoframework/fano-cli/blob/master/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/fanoframework/fano-cli.svg)](https://github.com/fanoframework/fano-cli/releases)

- [Scaffolding with Fano CLI](https://fanoframework.github.io/scaffolding-with-fano-cli/)

## Requirement

- Linux or FreeBSD or Windows
- [Free Pascal](https://www.freepascal.org/) >= 3.0,
- git

## Installation

### TLDR

Run

```
$ git clone https://github.com/fanoframework/fano-cli.git
$ cd fano-cli
$ ./tools/config.setup.sh
$ ./build.sh
```
For easier access, copy `bin/out/fanocli` executable binary to globally accessible location, for example

```
$ sudo cp bin/out/fanocli /usr/local/bin/fanocli
```
or you can put absolute path of `bin/out` directory in `PATH` environment variable.

In FreeBSD, before you run `build.sh`, edit `build.cfg` and replace target OS compilation to `-Tfreebsd`.

### Setting up

Make sure [Free Pascal](https://www.freepascal.org/) is installed. Run

    $ fpc -i

If you see something like `Free Pascal Compiler version 3.x.x`,  you are good to go.

Clone this repository

    $ git clone https://github.com/fanoframework/fano-cli.git

## Copy compiler configurations

Copy `*.cfg.sample` to `*.cfg`.

```
$ cp build.prod.cfg.sample build.prod.cfg
$ cp build.dev.cfg.sample build.dev.cfg
$ cp build.cfg.sample build.cfg
```

Make adjustment as you need in `build.cfg`, `build.prod.cfg`, `build.dev.cfg`.

These `*.cfg` files contain some Free Pascal compiler switches that you can turn on/off to change how executable is compiled and generated. For complete
explanation on available compiler switches, consult Free Pascal documentation.

`tools/config.setup.sh` shell script is provided to simplify copying those
configuration files. Following shell command is similar to command above.

    $ ./tools/config.setup.sh

## Build

Run `build.sh` (or `build.cmd` if on Windows) script to compile application.

    $ ./build.sh

By default, it will output binary executable in `bin/out` directory.

### Build for different environment

To build for different environment, set `BUILD_TYPE` environment variable.

#### Build for production environment

    $ BUILD_TYPE=prod ./build.sh

Build process will use compiler configuration defined in `build.cfg` and `build.prod.cfg`. By default, `build.prod.cfg` contains some compiler switches that will aggressively optimize executable both in speed and size.

#### Build for development environment

    $ BUILD_TYPE=dev ./build.sh

Build process will use compiler configuration defined in `build.cfg` and `build.dev.cfg`.

If `BUILD_TYPE` environment variable is not set, production environment will be assumed.

## Change executable output directory

Compilation will output executable to directory defined in `EXEC_OUTPUT_DIR`
environment variable. By default is `bin/out` directory.

    $ EXEC_OUTPUT_DIR=/path/to/exec/dir ./build.sh

## Change compiled units output directory

Compilation will output compiled units to directory defined in `UNIT_OUTPUT_DIR`
environment variable. By default is `bin/unit` directory.

    $ UNIT_OUTPUT_DIR=/path/to/compiled/units/dir ./build.sh

## Change Free Pascal compiler binary

By default, build script uses `fpc` command. If `fpc` can not be found or if you want to use different Free Pascal version, you can set compiler binary with `FPC_BIN`
environment variable. By default it is `fpc`.

    $ FPC_BIN=/path/to/fpc ./build.sh

You will very likely need to set location of `fpc.cfg` file to match Free Pascal version. For example, if you have multiple version of Free Pascal installation and you want to compile using Free Pascal version 3.0.4 as shown in following command.

```
$ PPC_CONFIG_PATH=/path/to/fpc-3.0.4 FPC_BIN=/path/to/fpc-3.0.4/fpc ./build.sh
```
where `PPC_CONFIG_PATH` is environment variable which Free Pascal uses to look for `fpc.cfg` file for Free Pascal version 3.0.4.

## Run

Copy `bin/out/fanocli` executable file to directory that is accessible globally, for example `/usr/local/bin`,

```
$ sudo cp bin/out/fanocli /usr/local/bin
```

then you can run

```
$ fanocli --help
```

Read [Scaffolding with Fano CLI](https://fanoframework.github.io/scaffolding-with-fano-cli/) for more information.

## Versioning Number

Fano CLI follows [Semantic Versioning 2.0.0](https://semver.org#semantic-versioning-200).

## Copyright Notice

Read [NOTICE](NOTICE)

## Known Issues

### Issue with GNU Linker

When running `build.sh` script, you may encounter following warning:

```
/usr/bin/ld: warning: bin/out/link.res contains output sections; did you forget -T?
```

This is known issue between Free Pascal and GNU Linker. See
[FAQ: link.res syntax error, or "did you forget -T?"](https://www.freepascal.org/faq.var#unix-ld219) and only happens with Free Pascal 3.0.4 or older. Free Pascal 3.2.0 or newer does not have this issue.

However, this warning is minor and can be ignored. It does not affect output executable.

### Missing /etc/fpc.cfg

`build.sh` script may show error about missing `/etc/fpc.cfg` file. This may happen if you install Free Pascal in non default directory or using tools such as [fpcupdeluxe](https://github.com/LongDirtyAnimAlf/fpcupdeluxe). To remedy this situation, create symbolic link in `/etc` to actual `fpc.cfg` file. Alternatively you can set `PPC_CONFIG_PATH` environment variable as described above.

```
$ sudo ln -s ~/fpcupdeluxe/fpc/bin/x86_64-linux/fpc.cfg /etc/fpc.cfg
```

### Issue with unsynchronized compiled unit with unit source

Sometime Free Pascal can not compile your code because, for example, you deleted a
unit source code (.pas) but old generated unit (.ppu, .o, .a files) still there
or when you switch between git branches. Solution is to remove those files.

By default, generated compiled units are in `bin/unit` directory.
But do not delete `README.md` file inside this directory, as it is not being ignored by git.

```
$ rm bin/unit/*.ppu
$ rm bin/unit/*.o
$ rm bin/unit/*.rsj
$ rm bin/unit/*.a
```

Following shell command will remove all files inside `bin/unit` directory except
`README.md` file.

    $ find bin/unit ! -name 'README.md' -type f -exec rm -f {} +

`tools/clean.sh` script is provided to simplify this task. Following shell command is similar as command above.

    $ ./tools/clean.sh

### Windows user

Free Pascal supports Windows as target operating system, however, this repository is not yet tested on Windows. To target Windows, in `build.cfg` replace
compiler switch `-Tlinux` with `-Twin64` and uncomment line `#-WC` to
become `-WC`.

### Lazarus user

While you can use Lazarus IDE, it is not mandatory tool. Any text editor for code editing (Atom, Visual Studio Code, Sublime, Vim etc) should suffice.

## Contributing

Just create pull request if you have improvement you want to add.
