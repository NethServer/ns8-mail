<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column :md="4" :xlg="10" class="page-title">
          <h2>{{ $t("mailboxes.title") }}</h2>
        </cv-column>
        <cv-column :md="4" :xlg="6">
          <div class="page-toolbar">
            <NsButton
              kind="tertiary"
              size="field"
              :icon="Settings20"
              @click="goToMailboxesSettings()"
              class="page-toolbar-item"
              >{{ $t("mailboxes.settings") }}</NsButton
            >
          </div>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <NsInlineNotification
            kind="warning"
            :title="core.$t('common.use_landscape_mode')"
            :description="core.$t('common.use_landscape_mode_description')"
            class="landscape-warning"
          />
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <NsTabs
              :container="false"
              :aria-label="core.$t('common.tab_navigation')"
              :noDefaultToFirst="true"
              @tab-selected="tabSelected"
            >
              <cv-tab
                id="tab-1"
                :label="$t('mailboxes.user_mailboxes')"
                :selected="q.view === 'user-mailboxes'"
              >
                <UserMailboxes />
              </cv-tab>
              <cv-tab
                id="tab-2"
                :label="$t('mailboxes.public_mailboxes')"
                :selected="q.view === 'public-mailboxes'"
              >
                <PublicMailboxes />
              </cv-tab>
            </NsTabs>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
  </div>
</template>

<script>
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";
import UserMailboxes from "@/components/mailboxes/UserMailboxes";
import PublicMailboxes from "@/components/mailboxes/PublicMailboxes";

export default {
  name: "Mailboxes",
  components: { UserMailboxes, PublicMailboxes },
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("mailboxes.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "mailboxes",
        view: "",
      },
      urlCheckInterval: null,
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
  mounted() {
    if (!this.q.view) {
      this.q.view = "user-mailboxes";
    }
  },
  methods: {
    goToMailboxesSettings() {
      this.goToAppPage(this.instanceName, "settingsMailboxes");
    },
    tabSelected(tabNum) {
      if (tabNum == 0) {
        this.q.view = "user-mailboxes";
      } else if (tabNum == 1) {
        this.q.view = "public-mailboxes";
      }
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
