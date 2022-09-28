<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <NsInfoCard
      :title="$t('filter.title')"
      :icon="Filter32"
      :loading="loading"
      :light="light"
      class="ns-filter-status-card ns-card"
    >
      <!-- <cv-tile kind="standard" :light="light" class="ns-filter-status-card"> ////
      <div class="row">
        <NsSvg :svg="Filter32" />
      </div>
      <div class="row">
        <h3 class="title">{{ $t("filter.title") }}</h3>
      </div>
      <div v-if="loading" class="row">
        <cv-skeleton-text
          :paragraph="true"
          :line-count="2"
          class="mg-top-sm"
        ></cv-skeleton-text>
      </div>
      <template v-else> -->
      <template slot="content">
        <div class="card-content">
          <div class="table-wrapper">
            <div class="table">
              <!-- filter -->
              <div class="tr">
                <div class="td label">{{ $t("filter.title") }}</div>
                <div class="td value">
                  <span v-if="isFilterEnabled">
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
              <!-- antispam -->
              <div class="tr">
                <div class="td label">{{ $t("filter.antispam") }}</div>
                <div class="td value">
                  <span v-if="isAntispamEnabled">
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
                  <span v-if="isAntivirusEnabled">
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
            :disabled="loading"
            class="mg-top-sm"
            >{{ $t("status.go_to_filter") }}
          </NsButton>
        </div>
      </template>
      <!-- <div> ////
        <div class="row mg-top-sm">
          <NsButton
            kind="tertiary"
            size="field"
            :icon="ArrowRight20"
            @click="goToBackup"
            :disabled="loading"
            >{{ $t("status.go_to_filter") }}
          </NsButton>
        </div>
      </div> -->
    </NsInfoCard>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { UtilService, IconService, TaskService } from "@nethserver/ns8-ui-lib";

//// review

export default {
  name: "FilterStatusCard",
  components: {},
  mixins: [UtilService, IconService, TaskService],
  props: {
    isFilterEnabled: Boolean,
    isAntispamEnabled: Boolean,
    isAntivirusEnabled: Boolean,
    loading: Boolean,
    light: Boolean,
  },
  computed: {
    ...mapState(["instanceName", "core"]),
  },
  created() {}, ////
  methods: {
    goToFilter() {
      this.goToAppPage(this.instanceName, "filter");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.status {
  font-weight: bold;
}

//// remove classes already on the core

.table-wrapper {
  display: flex;
  justify-content: center;
  margin-bottom: 0.5rem;
}

.table {
  display: table;
}

.tr {
  display: table-row;
}

.td {
  display: table-cell;
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

.card-content {
  flex-direction: column;
  text-align: center;

  .row {
    margin-bottom: $spacing-05;
  }

  .description {
    color: $ui-04;
  }
}

.status-icon {
  position: relative;
  top: 2px;
}

//// remove
.ns-disabled {
  color: #767676 !important;
  fill: #767676 !important;
}
//// end remove
</style>
