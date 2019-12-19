<!--
# Copyright (c) 2017 SONATA-NFV and Paderborn University
# ALL RIGHTS RESERVED.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Neither the name of the SONATA-NFV, Paderborn University
# nor the names of its contributors may be used to endorse or promote
# products derived from this software without specific prior written
# permission.
#
# This work has been performed in the framework of the SONATA project,
# funded by the European Commission under Grant number 671517 through
# the Horizon 2020 and 5G-PPP programmes. The authors would like to
# acknowledge the contributions of their colleagues of the SONATA
# partner consortium (www.sonata-nfv.eu).
-->


# vim-emu: A NFV multi-PoP emulation platform

This emulation platform was created to support network service developers to locally prototype and test their network services in realistic end-to-end multi-PoP scenarios. It allows the execution of real network functions, packaged as Docker containers, in emulated network topologies running locally on the developer's machine. The emulation platform also offers OpenStack-like APIs for each emulated PoP so that it can integrate with MANO solutions, like OSM. The core of the emulation platform is based on [Containernet](https://containernet.github.io).

The emulation platform `vim-emu` is developed as part of OSM's DevOps MDG.

---
## Acknowledgments

This software was originally developed by the [SONATA project](http://www.sonata-nfv.eu) and the [5GTANGO project](https://5gtango.eu/), funded by the European Commission under grant number 671517 and 761493 through the Horizon 2020 and 5G-PPP programs.

## Cite this work

If you use the emulation platform for your research and/or other publications, please cite the following paper to reference our work:

* M. Peuster, H. Karl, and S. v. Rossem: [MeDICINE: Rapid Prototyping of Production-Ready Network Services in Multi-PoP Environments](http://ieeexplore.ieee.org/document/7919490/). IEEE Conference on Network Function Virtualization and Software Defined Networks (NFV-SDN), Palo Alto, CA, USA, pp. 148-153. doi: 10.1109/NFV-SDN.2016.7919490. (2016)

Bibtex:

```bibtex
@inproceedings{peuster2016medicine, 
    author={M. Peuster and H. Karl and S. van Rossem}, 
    booktitle={2016 IEEE Conference on Network Function Virtualization and Software Defined Networks (NFV-SDN)}, 
    title={MeDICINE: Rapid prototyping of production-ready network services in multi-PoP environments}, 
    year={2016}, 
    volume={}, 
    number={}, 
    pages={148-153}, 
    doi={10.1109/NFV-SDN.2016.7919490},
    month={Nov}
}
```

---
## Installation

There are multiple ways to install and use the emulation platform. The easiest way is the automated installation using the OSM installer. The bare-metal installation requires a freshly installed **Ubuntu 18.04 LTS** and is done by an Ansible playbook. Another option is to use a nested Docker environment to run the emulator inside a Docker container.

### Automated OSM installation

This installation option applies if you want to use vim-emu in combination with OSM.

```sh
./install_osm.sh --vimemu
```

This command will install OSM as well as the emulator (as a Docker container) on a local machine. It is recommended to use a machine with Ubuntu 18.04 LTS. More details about this installation option can be found in the [OSM wiki](https://osm.etsi.org/wikipub/index.php/VIM_emulator).

### Standalone installation

#### Option 1: Bare-metal installation

```sh
sudo apt-get install ansible git aptitude
```

##### Step 1. Containernet installation

```sh
cd
git clone https://github.com/containernet/containernet.git
cd ~/containernet/ansible
sudo ansible-playbook -i "localhost," -c local install.yml
cd ..
sudo make develop
```

##### Step 2. vim-emu installation

```sh
cd
git clone https://osm.etsi.org/gerrit/osm/vim-emu.git
cd ~/vim-emu/ansible
sudo ansible-playbook -i "localhost," -c local install.yml
cd ..
sudo python3 setup.py develop
```

#### Option 2: Nested Docker Deployment
This option requires a Docker installation on the host machine on which the emulator should be deployed.

Build:
```sh
git clone https://osm.etsi.org/gerrit/osm/vim-emu.git
cd ~/vim-emu
# build the container:
docker build -t vim-emu-img .
```

Run:
```sh
# run the (interactive) container:
docker run --name vim-emu -it --rm --privileged --pid='host' -v /var/run/docker.sock:/var/run/docker.sock vim-emu-img /bin/bash
```

---
## Usage

### Example

This simple example shows how to start the emulator with a simple topology (terminal 1) and how to start (terminal 2) some empty VNF containers in the emulated datacenters (PoPs) by using the vim-emu CLI.

First terminal:
```sh
# start the emulation platform with a single NFV data center
sudo python3 examples/default_single_dc_topology.py
```

Second terminal (use `docker exec vim-emu <command>` for nested Docker deployment):
```sh
# start two simple VNFs
vim-emu compute start -d dc1 -n vnf1
vim-emu compute start -d dc1 -n vnf2
vim-emu compute list
```

First terminal:
```sh
# check the connectivity between the two VNFs
# press <ENTER> <ENTER>
containernet> vnf1 ifconfig
containernet> vnf1 ping -c2 vnf2
```


A more advanced example that includes OSM can be found in the [official vim-emu documentation in the OSM wiki](https://osm.etsi.org/wikipub/index.php/VIM_emulator).

---
## Documentation

* [Official vim-emu repository mirror on GitHub](https://github.com/containernet/vim-emu)
* [Official vim-emu documentation in the OSM wiki](https://osm.etsi.org/wikipub/index.php/VIM_emulator)
* [Full vim-emu documentation on GitHub](https://github.com/containernet/vim-emu)
* [Mininet](http://mininet.org)
* [Containernet](https://containernet.github.io)
* [Maxinet](https://maxinet.github.io)

---
## Development

### How to contribute?

Please check [this OSM wiki page](https://osm.etsi.org/wikipub/index.php/Workflow_with_OSM_tools) to learn how to contribute to a OSM module.

### Testing

```sh
sudo pytest -v
```

---
## Contributors

* [Manuel Peuster (lead developer)](https://github.com/mpeuster)
* [Hadi Razzaghi Kouchaksaraei](https://github.com/hadik3r)
* [Wouter Tavernier](https://github.com/wtaverni)
* [Geoffroy Chollon](https://github.com/cgeoffroy)
* [Eduard Maas](https://github.com/edmaas)
* [Malte Splietker](https://github.com/splietker)
* [Johannes Kampmeyer](https://github.com/xschlef)
* [Stefan Schneider](https://github.com/StefanUPB)
* [Erik Schilling](https://github.com/Ablu)
* [Rafael Schellenberg](https://github.com/RafaelSche)

## License

The emulation platform is published under Apache 2.0 license. Please see the LICENSE file for more details.

## Contact

Manuel Peuster
* Mail: <manuel (at) peuster (dot) de>
* Twitter: [@ManuelPeuster](https://twitter.com/ManuelPeuster)
* GitHub: [@mpeuster](https://github.com/mpeuster)
* Website: [https://peuster.de](https://peuster.de)


