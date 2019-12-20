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

FROM containernet/containernet:latest

ENV SON_EMU_IN_DOCKER 1
ENV PIP_DEFAULT_TIMEOUT=100

# install emulator (using its Ansible playbook)
WORKDIR /
COPY . /vim-emu
WORKDIR /vim-emu/ansible
RUN ansible-playbook -i "localhost," -c local --skip-tags "notindocker" install.yml
WORKDIR /vim-emu
RUN python3 setup.py develop

# Hotfix: Do not use latest tinyrpc lib, since it breaks Ryu
RUN pip3 install "tinyrpc==1.0.3"
RUN pip3 install wheel --upgrade

# Force python3
RUN mv /usr/bin/python /usr/bin/python2 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# Important: This entrypoint is required to start the OVS service
ENTRYPOINT ["/vim-emu/utils/docker/entrypoint.sh"]
CMD ["python3", "examples/default_single_dc_topology.py"]

# open ports for emulator APIs
# SONATA GK
EXPOSE 5000
# EMU REST API
EXPOSE 5001
# Monitoring (Prometheus)
EXPOSE 8081
# Monitoring (GW)
EXPOSE 9091
# OpenStack-fake
EXPOSE 4000
# OpenStack-fake
EXPOSE 10243
# OpenStack-fake
EXPOSE 9005
# OpenStack-fake (Keystone)
EXPOSE 6001
# OpenStack-fake
EXPOSE 9775
# OpenStack-fake
EXPOSE 10697
