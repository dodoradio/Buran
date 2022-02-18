# asteroidsyncservice
A synchronization daemon for [AsteroidOS](http://asteroidos.org/) watches. Forked from [Rockpool](https://github.com/abranson/rockpool).

asteroidsyncserviced is a daemon relying on libasteroid to synchronize data from a given platform to a watch. It comes with a QML module named asteroidsyncservice. It is used by starship, a SailfishOS synchronization app and Telescope, an Ubuntu Touch synchronization app.

## Building

To build asteroidsyncservice, all submodules must be loaded.

  - `git submodule update --init`

Current qmake build configuration options:

  - `Starship: CONFIG+=starship`
  - `Telescope: CONFIG+=telescope`

Install bluetooth

  - `sudo apt-get install qtconnectivity5-dev`

Create build dir

  - `mkdir build && cd build`

Run qmake:

  - `qmake -makefile -o Makefile "CONFIG+=telescope" ../asteroidsyncservice.pro`

Run make:

  - `make`
