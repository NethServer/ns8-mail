<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-tile light class="public-mailbox-acl-item">
    <div class="mg-right-md">{{ acl.subject.ui_name || acl.subject.name }}</div>
    <cv-content-switcher @selected="onAclSelected" class="rights-switcher">
      <cv-content-switcher-button owner-id="ro" :selected="csbRoSelected">{{
        $t("mailboxes.read")
      }}</cv-content-switcher-button>
      <cv-content-switcher-button owner-id="rw" :selected="csbRwSelected">{{
        $t("mailboxes.read_and_write")
      }}</cv-content-switcher-button>
      <cv-content-switcher-button owner-id="full" :selected="csbFullSelected">{{
        $t("mailboxes.full_control")
      }}</cv-content-switcher-button>
    </cv-content-switcher>
  </cv-tile>
</template>

<script>
import { UtilService } from "@nethserver/ns8-ui-lib";

export default {
  name: "PublicMailboxAclItem",
  components: {},
  mixins: [UtilService],
  props: {
    acl: {
      type: Object,
      required: true,
    },
  },
  computed: {
    csbRoSelected() {
      return this.acl.rights.rtype === "ro";
    },
    csbRwSelected() {
      return this.acl.rights.rtype === "rw";
    },
    csbFullSelected() {
      return this.acl.rights.rtype === "full";
    },
  },
  methods: {
    onAclSelected(value) {
      this.acl.rtype = value;
      this.$emit("setAclRights", this.acl, value);
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.public-mailbox-acl-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  margin-bottom: $spacing-03;
}

.rights-switcher {
  max-width: 32rem;
}
</style>
