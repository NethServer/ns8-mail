<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal size="default" :visible="isShown" @modal-hidden="$emit('hide')">
    <template slot="title">{{ $t("queue.deferred_queue_details") }}</template>
    <template v-if="queue.queue_id" slot="content">
      <div class="key-value-setting">
        <span class="label">{{ $t("queue.queue_id") }}</span>
        <span class="value">{{ queue.queue_id }}</span>
      </div>
      <div v-if="queue.arrival_time" class="key-value-setting">
        <span class="label">{{ $t("queue.arrival_time") }}</span>
        <span class="value">{{
          formatDate(new Date(queue.arrival_time * 1000), "yyyy-MM-dd HH.mm")
        }}</span>
      </div>
      <div v-if="queue.message_size" class="key-value-setting">
        <span class="label">{{ $t("queue.message_size") }}</span>
        <span class="value">{{ queue.message_size | byteFormat }}</span>
      </div>
      <div v-if="queue.sender" class="key-value-setting">
        <span class="label">{{ $t("queue.sender") }}</span>
        <span class="value">{{ queue.sender }}</span>
      </div>
      <div v-if="queue.recipients" class="key-value-setting">
        <span v-for="recipient in queue.recipients" :key="recipient.address">
          <div>
            <span class="label"
              >{{ $t("queue.recipient") }}
              {{ Number(queue.recipients.indexOf(recipient)) + 1 }}</span
            >
            <span class="value">{{ recipient.address }}</span>
          </div>
          <div class="mg-bottom">
            <div class="label">{{ $t("queue.delay_reason") }}</div>
            <span class="value">{{ recipient.delay_reason }}</span>
          </div>
        </span>
      </div>
    </template>
    <template slot="primary-button">{{ $t("queue.close") }}</template>
  </NsModal>
</template>

<script>
import { UtilService } from "@nethserver/ns8-ui-lib";
import { DateTimeService } from "@nethserver/ns8-ui-lib";

export default {
  name: "ShowQueueDetailModal",
  mixins: [UtilService, DateTimeService],
  props: {
    isShown: Boolean,
    queue: { type: [Object, null] },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
.mg-bottom{
  margin-bottom: 1rem;
}
</style>
