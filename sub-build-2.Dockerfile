FROM maddouri/cling-ubuntu-docker_sub-build-1

MAINTAINER Mohamed-Yassine MADDOURI

RUN /usr/bin/env bash /root/build-cling.sh  sub_build_2       \
                                            write_cling_sha1  \
                                            cleanup
