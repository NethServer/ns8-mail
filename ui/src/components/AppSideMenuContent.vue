<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div class="app-side-menu-content">
    <div class="instance-name">
      <div v-if="instanceLabel">{{ instanceLabel }}</div>
      <div v-else-if="instanceName">{{ instanceName }}</div>
      <cv-skeleton-text
        v-else
        :width="instanceNameSkeletonWidth"
      ></cv-skeleton-text>
    </div>

    <cv-side-nav-items>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'status')"
        :class="{ 'current-page': isLinkActive('status') }"
      >
        <template v-slot:nav-icon><Activity20 /></template>
        <span>{{ $t("status.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'domains')"
        :class="{ 'current-page': isLinkActive('domains') }"
      >
        <template v-slot:nav-icon><Wikis20 /></template>
        <span>{{ $t("domains.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'filter')"
        :class="{ 'current-page': isFilterActive() }"
      >
        <template v-slot:nav-icon><Filter20 /></template>
        <span>{{ $t("filter.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'mailboxes')"
        :class="{ 'current-page': isLinkActive('mailboxes') }"
      >
        <template v-slot:nav-icon><Box20 /></template>
        <span>{{ $t("mailboxes.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'addresses')"
        :class="{ 'current-page': isLinkActive('addresses') }"
      >
        <template v-slot:nav-icon><At20 /></template>
        <span>{{ $t("addresses.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'deferredQueue')"
        :class="{ 'current-page': isLinkActive('deferredQueue') }"
      >
        <template v-slot:nav-icon><MailAll20 /></template>
        <span>{{ $t("queue.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'settings')"
        :class="{ 'current-page': isSettingsActive() }"
      >
        <template v-slot:nav-icon><Settings20 /></template>
        <span>{{ $t("settings.title") }}</span>
      </cv-side-nav-link>
      <cv-side-nav-link
        @click="goToAppPage(instanceName, 'about')"
        :class="{ 'current-page': isLinkActive('about') }"
      >
        <template v-slot:nav-icon><Information20 /></template>
        <span>{{ $t("about.title") }}</span>
      </cv-side-nav-link>
    </cv-side-nav-items>
  </div>
</template>

<script>
import Settings20 from "@carbon/icons-vue/es/settings/20";
import Information20 from "@carbon/icons-vue/es/information/20";
import Activity20 from "@carbon/icons-vue/es/activity/20";
import Wikis20 from "@carbon/icons-vue/es/wikis/20";
import Box20 from "@carbon/icons-vue/es/box/20";
import At20 from "@carbon/icons-vue/es/at/20";
import Filter20 from "@carbon/icons-vue/es/filter/20";
import MailAll20 from "@carbon/icons-vue/es/mail--all/20";
import { mapState } from "vuex";
import { QueryParamService, UtilService } from "@nethserver/ns8-ui-lib";

export default {
  name: "AppSideMenuContent",
  components: {
    Settings20,
    Information20,
    Activity20,
    Wikis20,
    At20,
    Box20,
    Filter20,
    MailAll20,
  },
  mixins: [QueryParamService, UtilService],
  data() {
    return {
      instanceNameSkeletonWidth: "70%",
    };
  },
  computed: {
    ...mapState(["instanceName", "instanceLabel", "core"]),
  },
  created() {
    // register to appNavigation event
    this.$root.$on("appNavigation", this.onAppNavigation);
  },
  beforeDestroy() {
    // remove event listener
    this.$root.$off("appNavigation");
  },
  methods: {
    isLinkActive(page) {
      return this.getPage() === page;
    },
    isSettingsActive() {
      return this.getPage().startsWith("settings");
    },
    isFilterActive() {
      return this.getPage().startsWith("filter");
    },
    onAppNavigation() {
      // highlight current page in side menu
      this.$forceUpdate();
    },
  },
};
</script>

<style scoped lang="scss">
.instance-name span {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
