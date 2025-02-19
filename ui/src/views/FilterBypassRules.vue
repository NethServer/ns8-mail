<!--
  Copyright (C) 2023 Nethesis S.r.l.
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
      <cv-row>
        <cv-column>
          <NsInlineNotification
            v-if="error.removeBypassRule"
            kind="error"
            :title="$t('action.remove-bypass-rule')"
            :description="error.removeBypassRule"
            :showCloseButton="false"
          />
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
                      <NsButton
                        kind="tertiary"
                        :icon="TrashCan20"
                        size="small"
                        @click="showDeleteRuleModal(row)"
                        >{{ $t("common.delete") }}
                      </NsButton>
                    </div>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
    <!-- create bypass rule modal -->
    <CreateBypassRuleModal
      :isShown="isShownCreateBypassRuleModal"
      @hide="hideCreateBypassRuleModal"
      @reloadBypassRules="listBypassRules"
    />
    <!-- delete filter rule modal -->
    <NsDangerDeleteModal
      :isShown="isShownDeleteRuleModal"
      :name="currentRule.value"
      :title="$t('filter_bypass_rules.delete_filter_rule')"
      :warning="core.$t('common.please_read_carefully')"
      :description="
        $t('filter_bypass_rules.delete_rule_confirm', {
          name: currentRule ? currentRule.value : '',
        })
      "
      :typeToConfirm="
        core.$t('common.type_to_confirm', {
          name: currentRule ? currentRule.value : '',
        })
      "
      :isErrorShown="!!error.removeBypassRule"
      :errorTitle="$t('action.remove-bypass-rule')"
      :errorDescription="error.removeBypassRule"
      @hide="hideDeleteRuleModal"
      @confirmDelete="removeBypassRule(currentRule)"
    >
      <template slot="explanation">
        <p class="mg-top-sm">
          {{ core.$t("common.this_action_is_not_reversible") }}
        </p>
      </template>
    </NsDangerDeleteModal>
  </div>
</template>

<script>
import to from "await-to-js";
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
      isShownDeleteRuleModal: false,
      currentRule: {
        direction: "",
        value: "",
        type: "",
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
        removeBypassRule: "",
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
    showDeleteRuleModal(rule) {
      this.currentRule = rule;
      this.isShownDeleteRuleModal = true;
    },
    hideDeleteRuleModal() {
      this.isShownDeleteRuleModal = false;
    },
    goToFilter() {
      this.goToAppPage(this.instanceName, "filter");
    },
    showCreateBypassRuleModal() {
      this.isShownCreateBypassRuleModal = true;
    },
    hideCreateBypassRuleModal() {
      this.isShownCreateBypassRuleModal = false;
    },
    async listBypassRules() {
      this.loading.listBypassRules = true;
      this.error.listBypassRules = "";
      const taskAction = "list-bypass-rules";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listBypassRulesAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listBypassRulesCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.listBypassRules = this.getErrorMessage(err);
        this.loading.listBypassRules = false;
        return;
      }
    },
    listBypassRulesAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listBypassRules = this.$t("error.generic_error");
      this.loading.listBypassRules = false;
    },
    listBypassRulesCompleted(taskContext, taskResult) {
      const rules = taskResult.output.bypass_rules;
      rules.sort(this.sortByProperty("direction"));
      this.rules = rules;
      this.loading.listBypassRules = false;
    },
    async removeBypassRule(rule) {
      this.loading.removeBypassRule = true;
      this.error.removeBypassRule = "";
      const taskAction = "remove-bypass-rule";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.removeBypassRuleAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.removeBypassRuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            direction: rule.direction,
            type: rule.type,
            value: rule.value,
          },
          extra: {
            title: this.$t("filter_bypass_rules.delete_bypass_rule_for", {
              value: rule.value,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.removeBypassRule = this.getErrorMessage(err);
        this.loading.removeBypassRule = false;
        return;
      }
    },
    removeBypassRuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.removeBypassRule = this.$t("error.generic_error");
      this.loading.removeBypassRule = false;
    },
    removeBypassRuleCompleted() {
      this.loading.removeBypassRule = false;
      this.hideDeleteRuleModal();
      this.listBypassRules();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
.justify-flex-end {
  display: flex;
  justify-content: flex-end;
}
</style>
