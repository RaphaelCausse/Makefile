[![OS](https://img.shields.io/badge/os-linux-blue.svg)](https://shields.io/)
[![OS](https://img.shields.io/badge/os-windows-blue.svg)](https://shields.io/)
[![Status](https://img.shields.io/badge/status-completed-success.svg)](https://shields.io/)

# MAKEFILE C/C++

Makefile template for small to medium sized C/C++ projects, for Linux and Windows.

You can build the project in two modes: Release or Debug.

By default, the build is in Release mode.

Declare all the source files you want to compile in the `sources.mk` file in the `src` folder.

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

To use this generic makefile properly, please follow this project directory layout.
```
──┬─[ Project ]
  │
  ├──── Makefile
  ├──── README.md
  ├──── LICENSE.md
  │
  ├──┬─[ build ]
  │  └──── *.o
  │
  ├──┬─[ src ]
  │  ├──── sources.mk
  │  │
  │  ├──── main.c / main.cpp
  │  ├──── *.c / *.cpp
  │  ├──── *.h / *.hpp
  │  │
  │  ├──┬─[ module ]
  │  │  ├──── *.c / *.cpp
  │  │  └──── *.h / *.hpp
  │  └...
  │
  └...
```
<br>

## INSTALLATION

**Clone** this repository:
```
git clone https://github.com/RaphaelCausse/Generic-makefile.git
```
**Move** to the cloned directory :
```
cd Generic-makefile
```
**Copy** the Makefile in your project.

<br>

## USAGE

**Build** the project (default is Release mode):
```
make
make release
```
**Build** the project in Debug mode:
```
make debug
```

<br>

## FEATURES

**Clean** the project directory :
```
make clean
```
**Display** info about files in project directory:
```
make info
```
**Display** help message:
```
make help
```
<br>

## AUTHOR

Raphael CAUSSE, 08/2022.
