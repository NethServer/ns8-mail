<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div class="public-mailbox-acl">
    <div>
      <label class="bx--label">
        {{ $t("mailboxes.acl") }}
      </label>
    </div>
    <PublicMailboxAclItem
      v-for="(acl, index) in acls"
      :key="index"
      :acl="acl"
      @setAclRights="onSetAclRights"
    />
  </div>
</template>

<script>
import { UtilService } from "@nethserver/ns8-ui-lib";
import PublicMailboxAclItem from "./PublicMailboxAclItem.vue";

export default {
  name: "PublicMailboxAcl",
  components: { PublicMailboxAclItem },
  mixins: [UtilService],
  props: {
    acls: {
      type: Array,
      required: true,
    },
  },
  methods: {
    onSetAclRights(acl, rtype) {
      const aclFound = this.acls.find(
        (a) =>
          a.subject.name === acl.subject.name &&
          a.subject.dtype === acl.subject.dtype
      );

      if (aclFound) {
        aclFound.rights.rtype = rtype;
      }
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";
</style>
