# Buran
Work in progress AsteroidOS desktop linux synchronisation client. Contains code modified from starship and telescope.
The name is currently not set in stone, but is named after the buran space programme. 

The aim is to provide a native linux synchronisation client for asteroidos, with feature parity with Asteroidos-sync for android phones. 

Application development was initially started for use on PostmarketOS (and other mobile phone linux distributions) so the application has two UIs switchable through the UI settings menu. 

The build instrcutions are only provided for testing purposes. Currently, the application can be built with
``cmake -B build``
``cmake --build build``
and then run with
``build/src/buran``

Work needs to be done on the build system. Currently the executable does not embed any of the qml resources, and so is dependent on being in the directory it is built in, using relative paths. There is currently no install target for this reason.

