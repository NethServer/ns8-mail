<!--
  Copyright (C) 2024 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div class="snapshot-selector">
    <div class="snapshot-list">
      <!-- skeleton -->
      <div v-if="loading">
        <cv-tile
          v-for="index in 2"
          :key="index"
          :light="light"
          class="snapshot-tile"
        >
          <cv-skeleton-text
            :paragraph="true"
            :line-count="2"
          ></cv-skeleton-text>
        </cv-tile>
      </div>
      <!-- no snapshot to restore -->
      <NsEmptyState
        v-else-if="!snapshots.length"
        :title="$t('mailboxes.no_snapshot_to_restore')"
      />
      <!-- snapshot list -->
      <NsTile
        v-else
        v-for="(snapshot, index) of snapshotsLoaded"
        :key="index"
        :light="light"
        kind="selectable"
        :selected="snapshot.id === value"
        value="snapshotValue"
        @click="onTileClick(snapshot)"
        class="snapshot-tile"
      >
        <div>
          {{ formatDate(new Date(snapshot.timestamp * 1000), "PPpp") }}
        </div>
        <div v-if="index == 0" class="secondary-row">
          {{ $t("mailboxes.most_recent") }}
        </div>
      </NsTile>
      <infinite-loading
        :identifier="infiniteId"
        @infinite="infiniteScrollHandler"
      ></infinite-loading>
    </div>
  </div>
</template>

<script>
import { UtilService, DateTimeService } from "@nethserver/ns8-ui-lib";

export default {
  name: "BackupSnapshotSelector",
  components: {},
  mixins: [UtilService, DateTimeService],
  props: {
    value: {
      type: String,
      required: true,
    },
    snapshots: {
      type: Array,
      required: true,
    },
    loading: {
      type: Boolean,
      default: false,
    },
    light: Boolean,
  },
  data() {
    return {
      // infinite scroll
      snapshotsLoaded: [],
      pageNum: 0,
      pageSize: 20,
      infiniteId: +new Date(),
    };
  },
  watch: {
    snapshots: function () {
      this.snapshotsLoaded = [];
      this.pageNum = 0;
      this.infiniteId += 1;
      this.infiniteScrollHandler();
    },
  },
  methods: {
    onTileClick(snapshot) {
      if (snapshot.id !== this.value) {
        this.$emit("input", snapshot.id);
      } else {
        // tile has been deselected
        this.$emit("input", "");
      }
    },
    infiniteScrollHandler($state) {
      const pageItems = this.snapshots.slice(
        this.pageNum * this.pageSize,
        (this.pageNum + 1) * this.pageSize
      );

      if (pageItems.length) {
        this.pageNum++;
        this.snapshotsLoaded.push(...pageItems);

        if ($state) {
          $state.loaded();
        }
      } else {
        if ($state) {
          $state.complete();
        }
      }
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.snapshot-selector {
  display: flex;
  flex-direction: column;
}

.snapshot-list {
  overflow-y: auto;
  max-height: 21rem;
}

.ns-tile.snapshot-tile,
.cv-tile.snapshot-tile {
  margin-bottom: $spacing-03;
}

.secondary-row {
  margin-top: $spacing-02;
  color: $ui-04;
}
</style>
