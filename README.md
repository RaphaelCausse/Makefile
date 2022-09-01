[![OS](https://img.shields.io/badge/os-linux-blue.svg)](https://shields.io/)
[![Status](https://img.shields.io/badge/status-completed-success.svg)](https://shields.io/)

# GENERIC MAKEFILE

Generic Makefile for small to medium sized C/C++ projects.

The Makefile assumes source code is broken up in two groups, header files (.h/.hpp) and implementation files (.c/.cpp).

You can build the project in two modes: Release or Debug.

By default, the building process is in Release mode.

<br>

## PROJECT DIRECTORY LAYOUT

To use this generic makefile properly, please follow this project directory layout.
```
──┬─[ Project ]
  │
  ├──── Makefile
  ├──── README.md
  ├──── LICENSE.md
  │
  ├──┬─[ include ]
  │  └─── *.h / *.hpp
  │
  ├──┬─[ src ]
  │  ├─── main.c / main.cpp
  │  └─── *.c / *.cpp
  │
  ├──┬─[ obj ]
  │  ├──┬─[ debug ]
  │  │  └─── *.o
  │  └──┬─[ release ]
  │     └─── *.o
  │
  ├──┬─[ bin ]
  │  ├──┬─[ debug ]
  │  │  └─── app
  │  └──┬─[ release ]
  │     └─── app
  │
  └────...
```
**_NOTE:_**<br>
`bin` and `obj` directories and their subdirectories are not mandatory, they are created if they don't exist.

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

**Build** the project (default is Release mode):
```bash
make
```
or **build** the project in Debug mode:
```bash
make debug
```
**Run** the target (default is Release target) :
```
make run
```
or **run** the Debug target:
```bash
make run MODE=1
```

<br>

## FEATURES

**Clean** the project directory :
```bash
make clean
```
**Display** info about files in project directory:
```bash
make info
```
**Display** help message:
```bash
make help
```
<br>

## AUTHOR

Raphael CAUSSE, 08/2022.

Developped on Manjaro Linux, Visual Studio Code.