#!/usr/bin/awk

#
# Copyright (C) 2022 Nethesis S.r.l.
# http://www.nethesis.it - nethserver@nethesis.it
#
# This script is part of NethServer.
#
# NethServer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License,
# or any later version.
#
# NethServer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with NethServer.  If not, see COPYING.
#

# Parse a template_map inline table values and extract the keys matching "keysel"
# For instance, for
#      key1=lmtp:10.5.4.1:24 key2=smtp:192.168.12.13:25
#
# 1. keysel==lmtp: => key1
# 2. keysel==smtp: => key2

{
    for(f=1; f<length(); f++) {
        pos = index($f, keysel)
        if(pos == 0) {
            continue
        }
        printf("%s ", substr($f, 0, pos - 1))
    }
    printf("\n")
}
