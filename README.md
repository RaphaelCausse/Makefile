[![OS](https://img.shields.io/badge/os-linux-blue.svg)](https://shields.io/)
[![Status](https://img.shields.io/badge/status-completed-success.svg)](https://shields.io/)

# SIMPLE GENERIC MAKEFILE

Generic Makefile for small to medium sized C/C++ projects.

The Makefile assumes source code is broken up in two groups, header files (.h/.hpp for C/C++) and implementation files (.c/.cpp for C/C++).

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
  ├──┬─[ build ]
  │  ├─── exec
  │  └──┬─[ obj ]
  │     └─── *.o
  │
  ├──┬─[ include ]
  │  └─── *.h / *.hpp
  │
  ├──┬─[ src ]
  │  ├─── main.c / main.cpp
  │  └─── *.c / *.cpp
  │
  └────...
```
<br>

## INSTALLATION

**Clone** this repository:
```
git clone https://github.com/RaphaelCausse/Simple-Generic-Makefile.git
```
**Move** to the cloned directory :
```
cd Simple-Generic-Makefile
```
**Compile** the project :
```bash
make
```
**Run** the executable :
```
make run
```
<br>

## FEATURES

**Clean** the project directory :
```bash
make clean
```
<br>

## AUTHOR

Raphael CAUSSE, 08/2022.

Developped on Manjaro Linux, Visual Studio Code.