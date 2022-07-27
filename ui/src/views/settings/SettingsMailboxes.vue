<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column>
        <cv-breadcrumb
          aria-label="breadcrumb"
          :no-trailing-slash="true"
          class="breadcrumb"
        >
          <cv-breadcrumb-item>
            <cv-link @click="goToSettings">{{ $t("settings.title") }}</cv-link>
          </cv-breadcrumb-item>
          <cv-breadcrumb-item>
            <span>{{ $t("settings_mailboxes.title") }}</span>
          </cv-breadcrumb-item>
        </cv-breadcrumb>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column class="subpage-title">
        <h3>{{ $t("settings_mailboxes.title") }}</h3>
      </cv-column>
    </cv-row>
    <!-- <cv-row v-if="error.getClusterStatus"> ////
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-cluster-status')"
          :description="error.getClusterStatus"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row> -->
  </cv-grid>
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

export default {
  name: "SettingsMailboxes",
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings_mailboxes.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settingsMailboxes",
      },
      urlCheckInterval: null,
      loading: {},
      error: {},
    };
  },
  computed: {
    ...mapState(["core", "appName", "instanceName"]),
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
  created() {
    // this.getClusterStatus(); ////
  },
  methods: {
    goToSettings() {
      this.goToAppPage(this.instanceName, "settings");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";
</style>
