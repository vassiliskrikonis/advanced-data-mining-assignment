Assignment on Advanced Data Mining
----------------------------------

Instructions
============

The project uses _Docker_ and _Docker-Compose_ and consists of 2 docker services:
 - an Ubuntu 14.04 installation to run RTEC using the yap 6.2.2 Prolog distro
 - a miniconda installation "equipped" with _PyViz_ library to run the jupyter notebook report and the visualisations for the FlinkCEP and RTEC data.

In the provided configuration, running `docker-compose up`, spins up the containers and runs the jupyter notebook. Copying and pasting the generated url in a browser window will open up the running jupyter notebook server. _The docker image for the pyviz installation is about 4Gb in download size._

To access the yap installation in the Ubuntu image, just run a bash for the `yap` service, e.g.

```
$ docker-compose run yap
```

the above command will log in a terminal session with the ubuntu container right inside the `RTEC-dsc-msc/examples/maritime` directory.
