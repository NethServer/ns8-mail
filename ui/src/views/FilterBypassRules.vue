<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column>
          <cv-breadcrumb
            aria-label="breadcrumb"
            :no-trailing-slash="true"
            class="breadcrumb"
          >
            <cv-breadcrumb-item>
              <cv-link @click="goToFilter">{{ $t("filter.title") }}</cv-link>
            </cv-breadcrumb-item>
            <cv-breadcrumb-item>
              <span>{{ $t("filter_bypass_rules.title") }}</span>
            </cv-breadcrumb-item>
          </cv-breadcrumb>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column class="page-title">
          <h2>
            {{ $t("filter_bypass_rules.title") }}
            <cv-interactive-tooltip
              alignment="center"
              direction="right"
              class="info"
            >
              <template slot="trigger">
                <Information16 />
              </template>
              <template slot="content">
                {{ $t("filter_bypass_rules.bypass_rules_tooltip") }}
              </template>
            </cv-interactive-tooltip>
          </h2>
        </cv-column>
      </cv-row>
      <cv-row class="toolbar">
        <cv-column>
          <NsButton
            kind="secondary"
            :icon="Add20"
            @click="showCreateBypassRuleModal"
            :disabled="loading.listBypassRules"
            >{{ $t("filter_bypass_rules.create_bypass_rule") }}
          </NsButton>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <!-- //// check errorTitle and errorDescription -->
            <NsDataTable
              :allRows="rules"
              :columns="i18nTableColumns"
              :rawColumns="tableColumns"
              :sortable="true"
              :pageSizes="[10, 25, 50, 100]"
              :overflow-menu="true"
              isSearchable
              :searchPlaceholder="$t('filter_bypass_rules.search_rule')"
              :searchClearLabel="core.$t('common.clear_search')"
              :noSearchResultsLabel="core.$t('common.no_search_results')"
              :noSearchResultsDescription="
                core.$t('common.no_search_results_description')
              "
              :isLoading="loading.listBypassRules"
              :skeletonRows="5"
              :isErrorShown="!!error.listBypassRules"
              :errorTitle="$t('action.list-bypass-rules')"
              :errorDescription="error.listBypassRules"
              :itemsPerPageLabel="core.$t('pagination.items_per_page')"
              :rangeOfTotalItemsLabel="
                core.$t('pagination.range_of_total_items')
              "
              :ofTotalPagesLabel="core.$t('pagination.of_total_pages')"
              :backwardText="core.$t('pagination.previous_page')"
              :forwardText="core.$t('pagination.next_page')"
              :pageNumberLabel="core.$t('pagination.page_number')"
              @updatePage="tablePage = $event"
            >
              <template slot="empty-state">
                <NsEmptyState :title="$t('filter_bypass_rules.no_bypass_rule')">
                  <template #description>
                    <div>
                      {{ $t("filter_bypass_rules.no_bypass_rule_description") }}
                    </div>
                  </template>
                </NsEmptyState>
              </template>
              <template slot="data">
                <cv-data-table-row
                  v-for="(row, rowIndex) in tablePage"
                  :key="`${rowIndex}`"
                  :value="`${rowIndex}`"
                >
                  <cv-data-table-cell>
                    <span>{{
                      $t(`filter_bypass_rules.allow_${row.direction}`)
                    }}</span>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <span>{{ row.value }}</span>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <span>{{
                      $t(`filter_bypass_rules.type_${row.type}`)
                    }}</span>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <div class="justify-flex-end">
                      <cv-icon-button
                        :label="$t('common.delete')"
                        kind="danger"
                        :icon="TrashCan20"
                        size="small"
                        tipPosition="left"
                        tipAlignment="center"
                        @click="willDeleteBypassRule(row)"
                      />
                    </div>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
          </cv-tile>
          <!-- <NsInfoCard ////
            light
            :title="rule.value"
            :icon="Rule32"
          >
            <template slot="content">
              <div class="card-content">
                <div class="row description">
                  {{ getDescription(rule) }}
                </div>
                <NsButton
                  kind="danger--ghost"
                  :icon="TrashCan20"
                  @click="willDeleteBypassRule(rule)"
                  class="row"
                >
                  {{ $t("filter_bypass_rules.delete_rule") }}
                </NsButton>
              </div>
            </template>
          </NsInfoCard> -->
        </cv-column>
      </cv-row>
    </cv-grid>
    <!-- create bypass rule modal -->
    <CreateBypassRuleModal
      :isShown="isShownCreateBypassRuleModal"
      @hide="hideCreateBypassRuleModal"
      @reloadBypassRules="listBypassRules"
    />
  </div>
</template>

<script>
// import to from "await-to-js"; ////
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";
import Information16 from "@carbon/icons-vue/es/information/16";
import CreateBypassRuleModal from "@/components/CreateBypassRuleModal";

//// review

export default {
  name: "MailFilter",
  components: { Information16, CreateBypassRuleModal },
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("filter_bypass_rules.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "filterBypassRules",
      },
      urlCheckInterval: null,
      tablePage: [],
      tableColumns: ["direction", "value", "type"],
      rules: [],
      isShownCreateBypassRuleModal: false,
      deleteBypassRuleTimeout: [],
      loading: {
        listBypassRules: false,
      },
      error: {
        listBypassRules: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("filter_bypass_rules.col_" + column);
      });
    },
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  created() {
    this.listBypassRules();
  },
  methods: {
    goToFilter() {
      this.goToAppPage(this.instanceName, "filter");
    },
    showCreateBypassRuleModal() {
      this.isShownCreateBypassRuleModal = true;
    },
    hideCreateBypassRuleModal() {
      this.isShownCreateBypassRuleModal = false;
    },
    willDeleteBypassRule(rule) {
      const notification = {
        id: this.getUuid(),
        title: this.$t(
          "filter_bypass_rules.bypass_rule_is_going_to_be_deleted",
          {
            value: rule.value,
          }
        ),
        type: "info",
        toastTimeout: this.DELETE_DELAY - 1000,
        actionLabel: this.core.$t("common.cancel"),
        action: {
          type: "callback",
          callback: this.cancelDeleteBypassRule.bind(null, rule),
        },
      };
      this.createNotificationForApp(notification);

      const timeout = setTimeout(() => {
        // remove notification from drawer
        this.deleteNotificationForApp(notification.id);

        // delete timeout
        this.deleteBypassRuleTimeout = this.deleteBypassRuleTimeout.filter(
          (el) => el.name !== rule.value
        );

        // call api to remove address
        this.removeBypassRule(rule);
      }, this.DELETE_DELAY);

      this.deleteBypassRuleTimeout.push({
        name: rule.value,
        timeout,
        notification,
      });

      // remove bypass rule from table
      this.rules = this.rules.filter((r) => r.value !== rule.value);
    },
    cancelDeleteBypassRule(rule) {
      const timeoutFound = this.deleteBypassRuleTimeout.find(
        (el) => el.name === rule.value
      );

      console.log("cancelDeleteBypassRule, timeoutFound", timeoutFound); ////

      if (timeoutFound) {
        clearTimeout(timeoutFound.timeout);

        // remove notification from drawer
        this.deleteNotificationForApp(timeoutFound.notification.id);

        // delete timeout
        this.deleteBypassRuleTimeout = this.deleteBypassRuleTimeout.filter(
          (el) => el.name !== rule.value
        );
      }

      // reload bypass rules
      this.listBypassRules();
    },
    getDescription(rule) {
      const typeString = this.$t(`filter_bypass_rules.type_${rule.type}`);
      return this.$t(`filter_bypass_rules.allow_${rule.direction}_type`, {
        type: typeString,
      });
    },
    listBypassRules() {
      console.log("listBypassRules"); ////

      //// remove mock
      const rules = [
        {
          value: "nicedomain.org",
          type: "domain",
          direction: "from",
        },
        {
          value: "9.9.9.9",
          type: "ip",
          direction: "to",
        },
        {
          value: "importantclient@domain.com",
          type: "email",
          direction: "from",
        },
      ];

      rules.sort(this.sortByProperty("direction"));
      this.rules = rules;
    },
    removeBypassRule() {
      console.log("removeBypassRule"); ////
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

//// remove (css rules moved to core)
.card-content {
  flex-direction: column;
  text-align: center;

  .row {
    margin-bottom: $spacing-05;
  }

  .row:last-child {
    margin-bottom: 0;
  }
}

.description {
  color: $ui-04;
}

.justify-flex-end {
  display: flex;
  justify-content: flex-end;
}
</style>