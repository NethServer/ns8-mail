<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    @modal-hidden="$emit('hide')"
    @primary-click="$emit('confirm')"
  >
    <template slot="title"
      >{{ $t("queue.delete_email") }}: {{ queue.queue_id }}</template
    >
    <template slot="content">
      <div>{{ $t("queue.confirm_delete_queued_message") }}</div>
    </template>
    <template slot="secondary-button">{{ $t("queue.cancel") }}</template>
    <template slot="primary-button">{{ $t("queue.delete") }}</template>
  </NsModal>
</template>

<script>
import { UtilService, IconService } from "@nethserver/ns8-ui-lib";

export default {
  name: "ConfirmDeleteQueueModal",
  mixins: [UtilService, IconService],
  props: {
    isShown: Boolean,
    queue: { type: [Object, null] },
    core: { type: Object },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
