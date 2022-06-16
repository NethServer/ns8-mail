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

import agent
import cluster.userdomains

def get_user_domains():
    rdb = agent.redis_connect()
    domains = cluster.userdomains.list_domains(rdb).values()
    ldap_domains = [element for element in domains if element['protocol'] == 'ldap']
    return sorted(
        ldap_domains,
        key=lambda rec: rec['name'],
    )
