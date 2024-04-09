<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column :md="4" :xlg="10" class="page-title">
          <h2>{{ $t("relay.title") }}</h2>
        </cv-column>
        <cv-column :md="4" :xlg="6">
          <div class="page-toolbar">
            <NsButton
              kind="tertiary"
              size="field"
              :icon="Settings20"
              @click="goToRelaySettings()"
              class="page-toolbar-item"
              >{{ $t("relay.settings_button") }}</NsButton
            >
          </div>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <NsInlineNotification
            kind="warning"
            :title="core.$t('common.use_landscape_mode')"
            :description="core.$t('common.use_landscape_mode_description')"
            class="landscape-warning"
          />
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <cv-grid class="no-padding">
              <cv-row>
                <cv-column>
                  <NsButton
                    kind="primary"
                    :icon="Add20"
                    @click="null"
                    :disabled="
                      loading.listRelayRules ||
                      loading.editRelayRule ||
                      loading.deleteRelayRule ||
                      loading.addRelayRule
                    "
                    >{{ $t("relay.add_relay_rule") }}
                  </NsButton>
                  <NsButton
                    kind="secondary"
                    :icon="Add20"
                    @click="null"
                    :disabled="
                      hasWildcard ||
                      loading.listRelayRules ||
                      loading.editRelayRule ||
                      loading.deleteRelayRule ||
                      loading.addRelayRule
                    "
                    class="wildcard-button"
                    >{{ $t("relay.add_wildcard_rule") }}
                  </NsButton>
                </cv-column>
              </cv-row>
              <cv-row class="table-margin">
                <cv-column>
                  <NsDataTable
                    :allRows="relayRules"
                    :columns="i18nTableColumns"
                    :rawColumns="tableColumns"
                    :pageSizes="[10, 25, 50, 100]"
                    :overflow-menu="true"
                    isSearchable
                    :searchPlaceholder="$t('common.search')"
                    :searchClearLabel="core.$t('common.clear_search')"
                    :noSearchResultsLabel="core.$t('common.no_search_results')"
                    :noSearchResultsDescription="
                      core.$t('common.no_search_results_description')
                    "
                    :isLoading="
                      loading.listRelayRules || loading.setMailboxEnabled
                    "
                    :skeletonRows="5"
                    :isErrorShown="!!error.listRelayRules"
                    :errorTitle="$t('relay.list_relay_rules')"
                    :errorDescription="error.listRelayRules"
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
                      <NsEmptyState :title="$t('relay.no_relay_rules')">
                        <template #description>
                          <div>
                            {{ $t("relay.no_relay_rules_description") }}
                          </div>
                        </template>
                      </NsEmptyState>
                    </template>
                    <template slot="data">
                      <cv-data-table-row
                        v-for="(row, rowIndex) in tablePage"
                        :key="`${rowIndex}`"
                        :value="`${rowIndex}`"
                        class="table-row"
                      >
                        <cv-data-table-cell class="rule-subject-cell">
                          <p class="rule_subject_text">
                            {{ $t("relay." + row.rule_type) }}
                          </p>
                          <p class="rule_subject_text">
                            {{
                              row.rule_type == "wildcard"
                                ? $t("relay.any_address")
                                : row.rule_subject
                            }}
                          </p>
                        </cv-data-table-cell>
                        <cv-data-table-cell>
                          {{ row.host }}
                        </cv-data-table-cell>
                        <cv-data-table-cell>
                          {{
                            row.has_password
                              ? $t("common.enabled")
                              : $t("common.disabled")
                          }}
                        </cv-data-table-cell>
                        <cv-data-table-cell>
                          <NsTag
                            v-if="row.enabled"
                            kind="green"
                            :label="$t('common.enabled')"
                          ></NsTag>
                          <NsTag
                            v-else
                            kind="high-contrast"
                            :label="$t('common.disabled')"
                          ></NsTag>
                        </cv-data-table-cell>
                        <cv-data-table-cell class="table-overflow-menu-cell">
                          <cv-overflow-menu
                            flip-menu
                            class="table-overflow-menu"
                          >
                            <cv-overflow-menu-item
                              @click="toggleEditRule(row)"
                              :disabled="
                                loading.listRelayRules ||
                                loading.editRelayRule ||
                                loading.deleteRelayRule ||
                                loading.addRelayRule
                              "
                            >
                              <NsMenuItem
                                :icon="Edit20"
                                :label="core.$t('common.edit')"
                              />
                            </cv-overflow-menu-item>
                            <cv-overflow-menu-item
                              @click="toggleEnableDisableRule(row)"
                              :disabled="
                                loading.listRelayRules ||
                                loading.editRelayRule ||
                                loading.deleteRelayRule ||
                                loading.addRelayRule
                              "
                            >
                              <NsMenuItem
                                :icon="
                                  row.enabled ? ViewOffFilled20 : ViewFilled20
                                "
                                :label="
                                  row.enabled
                                    ? $t('relay.disable_rule')
                                    : $t('relay.enable_rule')
                                "
                              />
                            </cv-overflow-menu-item>
                            <cv-overflow-menu-item
                              @click="toggleDeleteRule(row)"
                              :disabled="
                                loading.listRelayRules ||
                                loading.editRelayRule ||
                                loading.deleteRelayRule ||
                                loading.addRelayRule
                              "
                              danger
                            >
                              <NsMenuItem
                                :icon="TrashCan20"
                                :label="$t('common.delete')"
                              />
                            </cv-overflow-menu-item>
                          </cv-overflow-menu>
                        </cv-data-table-cell>
                      </cv-data-table-row>
                    </template>
                  </NsDataTable>
                </cv-column>
              </cv-row>
            </cv-grid>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
  </div>
</template>

<script>
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";
import to from "await-to-js";
import { ViewOffFilled20, ViewFilled20 } from "@carbon/icons-vue";

export default {
  name: "Relay",
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("relay.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "relay",
      },
      ViewOffFilled20,
      ViewFilled20,
      hasWildcard: false,
      tablePage: [],
      tableColumns: ["rule_subject", "host", "has_password", "enabled"],
      relayRules: [],
      ruleToEdit: {},
      ruleToDelete: {},
      isEditDialogShow: false,
      isDeleteDialogShow: false,
      loading: {
        listRelayRules: false,
        editRelayRule: false,
        deleteRelayRule: false,
        addRelayRule: false,
      },
      error: {
        listRelayRules: "",
        editRelayRule: "",
        deleteRelayRule: "",
        addRelayRule: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("relay." + column);
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
    this.listRelayRules();
  },
  methods: {
    goToRelaySettings() {
      this.goToAppPage(this.instanceName, "settingsRelay");
    },
    async listRelayRules() {
      this.relayRules = [];
      const taskAction = "list-relay-rules";
      const eventId = this.getUuid();
      this.loading.listRelayRules = true;

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listRelayRulesAborted
      );

      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listRelayRulesCompleted
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
        const errMessage = this.getErrorMessage(err);
        this.error.listRelayRules = errMessage;
        this.loading.listRelayRules = false;
      }
    },
    listRelayRulesAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listRelayRules = this.$t("error.generic_error");
      this.loading.listRelayRules = false;
    },
    listRelayRulesCompleted(taskContext, taskResult) {
      this.hasWildcard = taskResult.output.has_wildcard;
      this.relayRules = taskResult.output.rules;
      this.relayRules = [
        {
          rule_type: "sender",
          rule_subject: "titi@azerty2.com",
          host: "smtp2.domain.com",
          port: 587,
          tls: false,
          username: "",
          has_password: false,
          enabled: true,
        },
        {
          rule_type: "sender",
          rule_subject: "fii.com",
          host: "smtp2.domain.com",
          port: 587,
          tls: false,
          username: "",
          has_password: false,
          enabled: false,
        },
        {
          rule_type: "recipient",
          rule_subject: "toto@azerty2.com",
          host: "ciao.domain.com",
          port: 587,
          tls: false,
          username: "",
          has_password: false,
          enabled: true,
        },
        {
          rule_type: "recipient",
          rule_subject: "azerty2.com",
          host: "smtp2.domain.com",
          port: 587,
          tls: false,
          username: "stephane",
          has_password: true,
          enabled: false,
        },
        {
          rule_type: "wildcard",
          rule_subject: "*",
          host: "smtp.domain.com",
          port: 587,
          tls: true,
          username: "helene",
          has_password: true,
          enabled: true,
        },
      ];
      this.loading.listRelayRules = false;
    },
    toggleEditRule(row) {
      this.isEditDialogShow = true;
      this.ruleToEdit = row;
    },
    toggleDeleteRule(row) {
      this.isDeleteDialogShow = true;
      this.ruleToDelete = row;
    },
    toggleEnableDisableRule(row) {
      this.ruleToEdit = row;
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.wildcard-button {
  margin-left: 1rem;
}

.table-margin {
  margin-top: 2rem;
}

.rule-subject-cell {
  flex-direction: column;
  align-items: start;
}

.rule_subject_text {
  font-size: 14px;
}

.table-row {
  height: 60px;
}
</style>
