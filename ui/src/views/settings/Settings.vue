<!--
  Copyright (C) 2022 Nethesis S.r.l.
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
          @click="goToAppPage(instanceName, 'settingsMailboxes')"
          :icon="Box32"
        >
          <h6>{{ $t("settings_mailboxes.title") }}</h6>
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
import { mapState } from "vuex";

export default {
  name: "Settings",
  mixins: [UtilService, IconService, QueryParamService, PageTitleService],
  pageTitle() {
    return this.$t("settings.title") + " - " + this.appName;
  },
  data() {
    return {
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