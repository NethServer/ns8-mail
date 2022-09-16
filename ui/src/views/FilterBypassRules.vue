<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column>
          <cv-breadcrumb
            aria-label="breadcrumb"
            :no-trailing-slash="true"
            class="breadcrumb"
          >
            <cv-breadcrumb-item>
              <cv-link @click="goToFilter">{{ $t("filter.title") }}</cv-link>
            </cv-breadcrumb-item>
            <cv-breadcrumb-item>
              <span>{{ $t("filter_bypass_rules.title") }}</span>
            </cv-breadcrumb-item>
          </cv-breadcrumb>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column class="subpage-title">
          <h3>{{ $t("filter_bypass_rules.title") }}</h3>
        </cv-column>
      </cv-row>
    </cv-grid>
  </div>
</template>

<script>
// import to from "await-to-js"; ////
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";

//// review

export default {
  name: "MailFilter",
  components: {},
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("filter_bypass_rules.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "filterBypassRules",
      },
      urlCheckInterval: null,
      loading: {},
      error: {},
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
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
  created() {},
  methods: {
    goToFilter() {
      this.goToAppPage(this.instanceName, "filter");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
