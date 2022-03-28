# Buran
Work in progress AsteroidOS desktop linux synchronisation client. Contains code modified from starship and telescope.
The name is currently not set in stone, but is named after the buran space programme. 

The aim is to provide a native linux synchronisation client for [AsteroidOS](https://asteroidos.org), with feature parity with [AsteroidOS Sync](https://github.com/AsteroidOS/AsteroidOSSync) for android phones. 

Application development was initially started for use on PostmarketOS (and other mobile phone linux distributions) so the application has two UIs switchable through the UI settings menu. 

## How to build
Building the software requires a C++ compiler (clang and gcc have been tested so far) and a Qt development environment which includes Qt Linguist tools, and CMake.

### Debug build
To build a debug version,

```
cmake -DCMAKE_BUILD_TYPE=Debug -S . -B build
cmake --build build
```

and then run with ``build/src/buran``

For the debug version, the executable does not embed any of the qml resources, and so is dependent on being in the directory it is built in, using relative paths.  For this reason the debug version does not have an install option.


### Release build
To build a release version,

```
cmake -DCMAKE_BUILD_TYPE=Release -S . -B build
cmake --build build
```

Like the debug version, it can be run without installation:
``build/src/buran``

Because the release executable includes all of the required qml resources, it may also be installed:

```
sudo cmake --build build -t install
```

