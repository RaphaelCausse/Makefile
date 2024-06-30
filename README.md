[![OS](https://img.shields.io/badge/os-linux-blue.svg)](https://shields.io/)
[![OS](https://img.shields.io/badge/os-windows-blue.svg)](https://shields.io/)

# MAKEFILE

Makefile template for small to medium sized C projects, for Linux and Windows.

You can build the project in two modes : **Release** or **Debug**.

By default, the build is in **Debug** mode.

Declare all the source files you want to compile in the `sources.mk`.

Please follow recommended project layout.

<br>

# Table of Contents
 
- [Project Layout](#project-layout)
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Author](#author)

<br>

## PROJECT LAYOUT

To use this makefile template properly, please follow the project layout bellow.
```
──┬─[ Project ]
  │
  ├──── LICENSE.md
  ├──── README.md
  │
  ├──── Makefile
  ├──── sources.mk   # Important: declare in that file all the source files to compile
  │
  ├──┬─[ src ]
  │  │
  │  ├──── *.c
  │  ├──── *.h
  │  ...
  │
  ...
```
Note that this layout of the project, including `src` directory and `sources.mk` file, is automatically created when executing the command : `make init`
<br>

## INSTALLATION

**Clone** this repository :
```
git clone https://github.com/RaphaelCausse/Makefile.git
```
**Move** to the cloned directory :
```
cd Makefile
```
**Copy** the Makefile in your project at root level of your project directory.
```
cp Makefile <path_to_your_project>
```
**Initialize** the project layout, in your project directory :
```
cd <path_to_your_project>
make init
```

<br>

## USAGE

**Update** the `sources.mk` file with the sources files to compile.

**Update** the Makefile for compiler and linker options for your needs. Check the variables in the `#### PATHS ####` and `#### COMPILER ####` sections.

**Build** the project in Release mode :
```
make release
```
**Build** the project in Debug mode :
```
make debug
```
**Run** the target in Release mode (with optional arguments) :
```
make run
make run ARGS="your arguments"
```
**Run** the target in Debug mode (with optional arguments) :
```
make rund
make rund ARGS="your arguments"
```
<br>

## FEATURES

**Clean** the project by removing generated files :
```
make clean
```
**Display** info about the project :
```
make info
```
**Display** help message:
```
make help
```
<br>

## AUTHOR

Raphael CAUSSE
