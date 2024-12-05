<!--
  Copyright (C) 2024 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div class="repo-selector">
    <div class="repo-list">
      <!-- skeleton -->
      <div v-if="loading">
        <cv-tile
          v-for="index in 2"
          :key="index"
          :light="light"
          class="repo-tile"
        >
          <cv-skeleton-text
            :paragraph="true"
            :line-count="2"
          ></cv-skeleton-text>
        </cv-tile>
      </div>
      <!-- no repositories -->
      <NsEmptyState
        v-else-if="!repositories.length"
        :title="$t('mailboxes.no_backup_found')"
      >
        <template #description>
          {{
            $t("mailboxes.no_backup_found_description", {
              module: instanceName,
            })
          }}
        </template>
      </NsEmptyState>
      <!-- repo list -->
      <NsTile
        v-else
        v-for="(repo, index) of repositories"
        :key="index"
        :light="light"
        kind="selectable"
        :selected="repo.repository_id === value"
        value="repoValue"
        @click="onTileClick(repo)"
        class="repo-tile"
      >
        <div>
          {{ repo.repository_name }}
        </div>
        <!-- repository url -->
        <div class="secondary-row">
          {{ repo.repository_url }}
        </div>
        <!-- timestamp -->
        <div class="secondary-row">
          {{ formatDate(new Date(repo.timestamp * 1000), "PPpp") }}
        </div>
        <!-- node and/or cluster -->
        <div
          v-if="repo.node_fqdn || repo.is_generated_locally !== null"
          class="secondary-row"
        >
          <template v-if="repo.node_fqdn && repo.is_generated_locally !== null">
            <!-- node and cluster -->
            <template v-if="repo.is_generated_locally">
              {{
                $t("mailboxes.from_node_name_of_this_cluster", {
                  name: repo.node_fqdn,
                })
              }}
            </template>
            <template v-else>
              {{
                $t("mailboxes.from_node_name_of_different_cluster", {
                  name: repo.node_fqdn,
                })
              }}
            </template>
          </template>
          <template v-else-if="repo.node_fqdn">
            <!-- node only -->
            {{
              $t("mailboxes.from_node_name", {
                name: repo.node_fqdn,
              })
            }}
          </template>
          <template v-else>
            <!-- cluster only -->
            <template v-if="repo.is_generated_locally">
              {{ $t("mailboxes.from_this_cluster") }}
            </template>
            <template v-else>
              {{ $t("mailboxes.from_different_cluster") }}
            </template>
          </template>
        </div>
      </NsTile>
    </div>
  </div>
</template>

<script>
import { UtilService, DateTimeService } from "@nethserver/ns8-ui-lib";

export default {
  name: "BackupRepositorySelector",
  components: {},
  mixins: [UtilService, DateTimeService],
  props: {
    value: {
      type: String,
      required: true,
    },
    repositories: {
      type: Array,
      required: true,
    },
    instanceName: {
      type: String,
      required: true,
    },
    loading: {
      type: Boolean,
      default: false,
    },
    light: Boolean,
  },
  methods: {
    onTileClick(repo) {
      if (repo.repository_id !== this.value) {
        this.$emit("input", repo.repository_id);
      } else {
        // tile has been deselected
        this.$emit("input", "");
      }
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.repo-selector {
  display: flex;
  flex-direction: column;
}

.repo-list {
  overflow-y: auto;
  max-height: 21rem;
}

.ns-tile.repo-tile,
.cv-tile.repo-tile {
  margin-bottom: $spacing-03;
}

.secondary-row {
  margin-top: $spacing-02;
  color: $ui-04;
}
</style>
