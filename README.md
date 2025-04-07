# Docker container for the core GAP system

The Docker container for the core GAP system is available at DockerHub here:
https://hub.docker.com/r/jamesdbmitchell/gap-docker-minimal

This GAP Docker container provides only the core GAP system and several packages
which are needed by GAP (PackageManager, GAPDoc, PrimGrp, SmallGrp, TransGrp).
It may be used, for example, in automated tests of different configurations of
GAP packages by installing them in the `pkg` subdirectory of
`/home/gap/inst/gap-4.X.Y/`. 

If you install Docker, you may run GAP in this container interactively.

```
$ docker run --rm -i -t jamesdbmitchell/gap-docker-minimal:version-4.13.0
gap@59748b4d40a2:~$ gap -A -T
 *********   GAP 4.13.0 of YYYY-MM-DD
 *  GAP  *   https://www.gap-system.org
 *********   Architecture: x86_64-pc-linux-gnu-default64-kv8
 Configuration:  gmp 6.2.0, GASMAN, readline
 Loading the library and packages ...
 Packages:   GAPDoc 1.6.6, PrimGrp 3.4.2, SmallGrp 1.5.1, TransGrp 3.6.3
 Try '??help' for help. See also '?copyright', '?cite' and '?authors'
gap>
```
