<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <NsInfoCard
      :title="$t('filter.title')"
      :icon="Filter32"
      :loading="loading"
      :isErrorShown="isErrorShown"
      :errorTitle="errorTitle"
      :errorDescription="errorDescription"
      :light="light"
      class="ns-filter-status-card ns-card"
    >
      <template slot="content">
        <div v-show="!loading && !isErrorShown" class="card-content">
          <div class="table-wrapper">
            <div class="table">
              <!-- antispam -->
              <div class="tr">
                <div class="td label">{{ $t("filter.antispam") }}</div>
                <div class="td value">
                  <span v-if="loading" class="skeleton-container">
                    <cv-skeleton-text class="skeleton-line"></cv-skeleton-text>
                  </span>
                  <span v-else-if="isAntispamEnabled">
                    <span>{{ $t("common.enabled") }}</span>
                    <NsSvg
                      :svg="CheckmarkFilled16"
                      class="ns-success mg-left-sm status-icon"
                    />
                  </span>
                  <template v-else>
                    <span>
                      {{ $t("common.disabled") }}
                    </span>
                    <NsSvg
                      :svg="CloseFilled16"
                      class="ns-disabled mg-left-sm status-icon"
                    />
                  </template>
                </div>
              </div>
              <!-- antivirus -->
              <div class="tr">
                <div class="td label">{{ $t("filter.antivirus") }}</div>
                <div class="td value">
                  <span v-if="loading" class="skeleton-container">
                    <cv-skeleton-text class="skeleton-line"></cv-skeleton-text>
                  </span>
                  <span v-else-if="isAntivirusEnabled">
                    <span>{{ $t("common.enabled") }}</span>
                    <NsSvg
                      :svg="CheckmarkFilled16"
                      class="ns-success mg-left-sm status-icon"
                    />
                  </span>
                  <template v-else>
                    <span>{{ $t("common.disabled") }}</span>
                    <NsSvg
                      :svg="CloseFilled16"
                      class="ns-disabled mg-left-sm status-icon"
                    />
                  </template>
                </div>
              </div>
            </div>
          </div>
          <NsButton
            kind="ghost"
            :icon="ArrowRight20"
            @click="goToFilter"
            class="mg-top-sm"
            >{{ $t("status.go_to_filter") }}
          </NsButton>
        </div>
      </template>
    </NsInfoCard>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { UtilService, IconService, TaskService } from "@nethserver/ns8-ui-lib";

export default {
  name: "FilterStatusCard",
  components: {},
  mixins: [UtilService, IconService, TaskService],
  props: {
    isAntispamEnabled: Boolean,
    isAntivirusEnabled: Boolean,
    loading: Boolean,
    isErrorShown: {
      type: Boolean,
      default: false,
    },
    errorTitle: String,
    errorDescription: String,
    light: Boolean,
  },
  computed: {
    ...mapState(["instanceName", "core"]),
  },
  methods: {
    goToFilter() {
      this.goToAppPage(this.instanceName, "filter");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.skeleton-container {
  display: inline-block;
  width: 5rem;
}

.skeleton-line {
  position: relative;
  top: 0.7rem;
}

.label {
  padding-right: 0.75rem;
  font-weight: bold;
  text-align: right;
  padding-bottom: 0.5rem;
}

.value {
  text-align: left;
}

.status-icon {
  position: relative;
  top: 2px;
}
</style>
