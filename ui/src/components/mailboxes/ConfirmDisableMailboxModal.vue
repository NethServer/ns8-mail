<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    @modal-hidden="$emit('hide')"
    @primary-click="$emit('confirm')"
  >
    <template slot="title">{{ $t("mailboxes.disable_mailbox") }}</template>
    <template slot="content">
      <div
        v-html="
          $t('mailboxes.confirm_disable_mailbox', {
            mailbox: mailbox ? mailbox.user : '',
          })
        "
        class="mg-bottom-md"
      ></div>
      <div>{{ $t("mailboxes.confirm_disable_mailbox_2") }}</div>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{
      $t("mailboxes.disable_mailbox")
    }}</template>
  </NsModal>
</template>

<script>
import { UtilService, IconService } from "@nethserver/ns8-ui-lib";

export default {
  name: "ConfirmDisableMailboxModal",
  mixins: [UtilService, IconService],
  props: {
    isShown: Boolean,
    mailbox: { type: [Object, null] },
    core: { type: Object },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";
</style>
