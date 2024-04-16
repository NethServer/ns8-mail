<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column :md="4" :xlg="4">
        <NsTile
          :light="true"
          kind="clickable"
          @click="goToAppPage(instanceName, 'settingsGeneral')"
          :icon="Settings32"
        >
          <h6>{{ $t("settings.general") }}</h6>
        </NsTile>
      </cv-column>
      <cv-column :md="4" :xlg="4">
        <NsTile
          :light="true"
          kind="clickable"
          @click="goToAppPage(instanceName, 'settingsMailboxes')"
          :icon="Box32"
        >
          <h6>{{ $t("settings.mailboxes") }}</h6>
        </NsTile>
      </cv-column>
      <cv-column :md="4" :xlg="4">
        <NsTile
          :light="true"
          kind="clickable"
          @click="goToAppPage(instanceName, 'settingsMasterUsers')"
          :icon="UserMilitary32"
        >
          <h6>{{ $t("settings_master_users.title") }}</h6>
        </NsTile>
      </cv-column>
      <cv-column :md="4" :xlg="4">
        <NsTile
          :light="true"
          kind="clickable"
          @click="goToAppPage(instanceName, 'settingsQueue')"
          :icon="MailAll32"
        >
          <h6>{{ $t("settings_queue.title") }}</h6>
        </NsTile>
      </cv-column>
      <cv-column :md="4" :xlg="4">
        <NsTile
          :light="true"
          kind="clickable"
          @click="goToAppPage(instanceName, 'settingsRelay')"
          :icon="SendAlt32"
        >
          <h6>{{ $t("relay.title") }}</h6>
        </NsTile>
      </cv-column>
    </cv-row>
  </cv-grid>
</template>

<script>
import {
  QueryParamService,
  UtilService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import SendAlt32 from "@carbon/icons-vue/es/send--alt/32";
import { mapState } from "vuex";

export default {
  name: "Settings",
  mixins: [UtilService, IconService, QueryParamService, PageTitleService],
  pageTitle() {
    return this.$t("settings.title") + " - " + this.appName;
  },
  data() {
    return {
      SendAlt32,
      q: {
        page: "settings",
      },
      urlCheckInterval: null,
    };
  },
  computed: {
    ...mapState(["instanceName", "appName", "core"]),
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  methods: {
    goTo(path) {
      this.goToAppPage(this.instanceName, path);
    },
  },
};
</script>
