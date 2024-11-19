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
            v-if="hasWildcard || hasRulesByRecipient()"
            kind="info"
            :title="$t('relay.shared_credentials_info_title')"
            :description="$t('relay.shared_credentials_info_description')"
            :showCloseButton="false"
          />
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
                    @click="toggleAddRule()"
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
                    @click="toggleAddWildcardRule()"
                    :disabled="
                      hasWildcard ||
                      loading.listRelayRules ||
                      loading.editRelayRule ||
                      loading.deleteRelayRule ||
                      loading.addRelayRule
                    "
                    class="wildcard-button"
                    >{{ $t("relay.set_default_rule") }}
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
                          {{ row.host }}:{{ row.port }}
                        </cv-data-table-cell>
                        <cv-data-table-cell>
                          <div
                            v-if="row.has_password"
                          >
                            {{ row.username }}
                          </div>
                          <NsTag
                            v-else
                            kind="high-contrast"
                            :label="$t('common.disabled')"
                          ></NsTag>
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
                                :icon="Power20"
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
    <NsModal
      size="default"
      :visible="isAddDialogShow || isEditDialogShow || isAddWildcardDialogShow"
      :primary-button-disabled="loading.editRelayRule || loading.addRelayRule"
      :isLoading="loading.editRelayRule || loading.addRelayRule"
      @modal-hidden="onModalHidden"
      @primary-click="onModalConfirm"
    >
      <template slot="title">{{ modalTitle }}</template>
      <template slot="content">
        <cv-form @submit.prevent="onModalConfirm">
          <p class="radio-menu-label" v-if="isAddDialogShow">
            {{ $t("relay.rule_type") }}
          </p>
          <cv-radio-group vertical v-if="isAddDialogShow">
            <cv-radio-button
              v-model="form.rule_type"
              value="sender"
              :label="$t('relay.sender')"
              ref="form.rule_type"
              checked
            ></cv-radio-button>
            <cv-radio-button
              v-model="form.rule_type"
              value="recipient"
              :label="$t('relay.recipient')"
              ref="form.rule_type"
            ></cv-radio-button>
          </cv-radio-group>
          <p
            class="radio-menu-label radio-menu-error"
            v-if="error.form.rule_type"
          >
            {{ $t("common.required") }}
          </p>
          <NsTextInput
            v-if="!isAddWildcardDialogShow && form.rule_type != 'wildcard'"
            :disabled="isEditDialogShow"
            v-model.trim="form.rule_subject"
            :label="
              form.rule_type == 'sender'
                ? $t('relay.sender')
                : $t('relay.recipient')
            "
            :placeholder="$t('relay.rule_subject_helper')"
            :invalid-message="error.form.rule_subject"
            ref="form.rule_subject"
            data-modal-primary-focus
          />
          <NsTextInput
            v-model.trim="form.host"
            :label="$t('relay.host')"
            :invalid-message="error.form.host"
            ref="form.host"
            data-modal-primary-focus
          />
          <NsTextInput
            v-model="form.port"
            :placeholder="$t('relay.port_placeholder')"
            :label="$t('relay.port')"
            :invalid-message="error.form.port"
            ref="form.port"
          />
          <NsToggle
            :label="$t('relay.authentication')"
            :form-item="true"
            v-model="authentication"
            ref="authentication"
            value="toggleValue"
            @change="
              if (!authentication) {
                (form.username = ''), (form.password = '');
              }
            "
          >
            <template slot="text-left">{{ $t("common.disabled") }}</template>
            <template slot="text-right">{{ $t("common.enabled") }}</template>
          </NsToggle>
          <NsTextInput
            v-if="authentication"
            v-model="form.username"
            :label="$t('relay.username')"
            :invalid-message="error.form.username"
            ref="form.username"
          />
          <NsTextInput
            v-if="authentication"
            v-model="form.password"
            :label="$t('relay.password')"
            :invalid-message="error.form.password"
            ref="form.password"
            type="password"
            :placeholder="
              isEditDialogShow && form.username ? $t('relay.unchanged') : ''
            "
          />
          <NsToggle
            :label="$t('relay.mandatory_tls')"
            :form-item="true"
            v-model="form.mandatory_tls"
            ref="form.mandatory_tls"
            value="toggleValue"
            tooltipAlignment="center"
            tooltipDirection="right"
          >
            <template slot="tooltip">
              <span>{{ $t("relay.mandatory_tls_tooltip") }}</span>
            </template>
            <template slot="text-left">{{ $t("common.disabled") }}</template>
            <template slot="text-right">{{ $t("common.enabled") }}</template>
          </NsToggle>
        </cv-form>
      </template>
      <template slot="secondary-button">{{ $t("common.cancel") }}</template>
      <template slot="primary-button">{{
        isAddDialogShow
          ? $t("relay.add_rule")
          : isEditDialogShow
          ? $t("relay.edit_rule")
          : $t("relay.set_default_rule")
      }}</template>
    </NsModal>
    <NsModal
      size="default"
      kind="danger"
      :visible="isDeleteDialogShow"
      :primary-button-disabled="loading.deleteRelayRule"
      :isLoading="loading.deleteRelayRule"
      @modal-hidden="onDeleteModalHidden"
      @primary-click="onDeleteModalConfirm"
    >
      <template slot="title">{{ $t("relay.delete_relay_rule") }}</template>
      <template slot="content">
        <span>{{
          form.rule_type == "wildcard"
            ? $t("relay.delete_default_rule")
            : $tc("relay.delete_rule_description", form.rule_subject, {
                ruleType: ruleTypeTranslation,
                ruleSubject: form.rule_subject,
              })
        }}</span>
      </template>
      <template slot="secondary-button">{{ $t("common.cancel") }}</template>
      <template slot="primary-button">{{ $t("relay.delete_rule") }}</template>
    </NsModal>
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
import { Power20 } from "@carbon/icons-vue";

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
      Power20,
      hasWildcard: false,
      tablePage: [],
      tableColumns: ["rule_subject", "host", "has_password", "enabled"],
      relayRules: [],
      isAddDialogShow: false,
      isEditDialogShow: false,
      isAddWildcardDialogShow: false,
      isDeleteDialogShow: false,
      form: {
        rule_type: "sender",
        rule_subject: "",
        host: "",
        port: "",
        username: "",
        password: "",
        mandatory_tls: true,
        enabled: true,
      },
      authentication: false,
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
        form: {
          rule_type: "",
          rule_subject: "",
          host: "",
          port: "",
          username: "",
          password: "",
          mandatory_tls: "",
        },
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("relay.col_" + column);
      });
    },
    modalTitle: function () {
      if (this.isAddDialogShow) {
        return this.$t("relay.add_relay_rule");
      } else if (this.isEditDialogShow) {
        return this.form.rule_type == "wildcard"
          ? this.$t("relay.edit_default_rule")
          : this.$t("relay.edit_relay_rule");
      } else {
        return this.$t("relay.set_default_rule");
      }
    },
    ruleTypeTranslation: function () {
      return this.$t("relay." + this.form.rule_type);
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
    hasRulesByRecipient() {
      for(const row of this.relayRules) {
        if(row.rule_type == "recipient") {
          return true;
        }
      }
      return false;
    },
    goToRelaySettings() {
      this.goToAppPage(this.instanceName, "settingsRelay");
    },
    resetForm(rule) {
      this.form.rule_type = rule ? rule.rule_type : "sender";
      this.form.rule_subject = rule ? rule.rule_subject : "";
      this.form.host = rule ? rule.host : "";
      this.form.port = rule ? rule.port.toString() : "";
      this.form.username = rule ? rule.username : "";
      this.form.password = "";
      this.form.mandatory_tls = rule ? rule.tls : true;
      this.form.enabled = rule ? rule.enabled : true;
      this.authentication = rule ? rule.has_password : false;
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
      this.loading.listRelayRules = false;
    },
    validateForm() {
      this.clearErrors();
      let isValidationOk = true;

      // This specific case is related to enable/disable rule function because we send the same data except for the enabled field
      if (
        !this.isAddDialogShow &&
        !this.isAddWildcardDialogShow &&
        !this.isEditDialogShow
      ) {
        return isValidationOk;
      }

      if (!this.form.host) {
        this.error.form.host = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("form.host");
          isValidationOk = false;
        }
      }

      if (!this.form.port) {
        this.error.form.port = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("form.port");
          isValidationOk = false;
        }
      }

      if (this.form.port && isNaN(this.form.port)) {
        this.error.form.port = this.$t("relay.error.port_must_be_a_number");

        if (isValidationOk) {
          this.focusElement("form.port");
          isValidationOk = false;
        }
      }

      if (this.form.port && isNaN(this.form.port) && this.form.port < 0) {
        this.error.form.port = this.$t("relay.error.port_must_be_positive");

        if (isValidationOk) {
          this.focusElement("form.port");
          isValidationOk = false;
        }
      }

      if (this.authentication && !this.form.username) {
        this.error.form.username = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("form.username");
          isValidationOk = false;
        }
      }

      if (
        this.authentication &&
        (this.isAddDialogShow || this.isAddWildcardDialogShow) &&
        !this.form.password
      ) {
        this.error.form.password = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("form.password");
          isValidationOk = false;
        }
      }

      if (this.isAddDialogShow) {
        if (!this.form.rule_type) {
          this.error.form.rule_type = this.$t("common.required");

          if (isValidationOk) {
            this.focusElement("form.rule_type");
            isValidationOk = false;
          }
        }

        if (!this.form.rule_subject) {
          this.error.form.rule_subject = this.$t("common.required");

          this.focusElement("form.rule_subject");
          isValidationOk = false;
        }
      }

      return isValidationOk;
    },
    validationFailedForm(validationErrors) {
      for (const validationError of validationErrors) {
        const field = validationError.field;
        this.error.form[field] = this.$t(
          "relay.error." + validationError.error
        );
        if (field == "test_rule_credentials") {
          this.error.form.username = this.$t(
            "relay.error." + validationError.error
          );
          this.error.form.password = this.$t(
            "relay.error." + validationError.error
          );
        }
      }
    },
    async addRelayRule() {
      if (!this.validateForm()) {
        return;
      }

      this.loading.addRelayRule = true;
      this.error.addRelayRule = "";
      const taskAction = "add-relay-rule";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.addRelayRuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.addRelayRuleValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.addRelayRuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.addRelayRuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: { ...this.form, port: parseInt(this.form.port) },
          extra: {
            title: this.$t("action." + taskAction),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.addRelayRule = this.getErrorMessage(err);
        this.loading.addRelayRule = false;
        return;
      }
    },
    addRelayRuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.addRelayRule = false;
    },
    addRelayRuleValidationOk() {
      this.loading.addRelayRule = false;

      // hide modal after validation
      this.onModalHidden();
    },
    addRelayRuleValidationFailed(validationErrors) {
      this.loading.addRelayRule = false;

      this.validationFailedForm(validationErrors);
    },
    addRelayRuleCompleted() {
      this.loading.addRelayRule = false;

      // reload rules
      this.onModalHidden();
      this.listRelayRules();
    },
    async editRelayRule() {
      if (!this.validateForm()) {
        return;
      }

      this.loading.editRelayRule = true;
      this.error.editRelayRule = "";
      const taskAction = "alter-relay-rule";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.editRelayRuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.editRelayRuleValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.editRelayRuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.editRelayRuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: { ...this.form, port: parseInt(this.form.port) },
          extra: {
            title: this.$t("action." + taskAction),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.editRelayRule = this.getErrorMessage(err);
        this.loading.editRelayRule = false;
        return;
      }
    },
    editRelayRuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.editRelayRule = false;
    },
    editRelayRuleValidationOk() {
      this.loading.editRelayRule = false;

      // hide modal after validation
      this.onModalHidden();
    },
    editRelayRuleValidationFailed(validationErrors) {
      this.loading.editRelayRule = false;

      this.validationFailedForm(validationErrors);
    },
    editRelayRuleCompleted() {
      this.loading.editRelayRule = false;

      // reload rules
      this.onModalHidden();
      this.listRelayRules();
    },
    async deleteRelayRule() {
      this.loading.deleteRelayRule = true;
      this.error.deleteRelayRule = "";
      const taskAction = "remove-relay-rule";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.deleteRelayRuleAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.deleteRelayRuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: { rule_subject: this.form.rule_subject },
          extra: {
            title: this.$t("action." + taskAction),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.deleteRelayRule = this.getErrorMessage(err);
        this.loading.deleteRelayRule = false;
        return;
      }

      this.onDeleteModalHidden();
    },
    deleteRelayRuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.deleteRelayRule = false;
    },
    deleteRelayRuleCompleted() {
      this.loading.deleteRelayRule = false;

      // reload rules
      this.listRelayRules();
    },
    toggleAddRule() {
      this.resetForm();
      this.isAddDialogShow = true;
    },
    toggleAddWildcardRule() {
      this.resetForm({
        rule_type: "wildcard",
        rule_subject: "*",
        host: "",
        port: "",
        username: "",
        password: "",
        tls: false,
        enabled: true,
      });
      this.authentication = false;
      this.isAddWildcardDialogShow = true;
    },
    toggleEditRule(row) {
      this.resetForm(row);
      this.isEditDialogShow = true;
    },
    toggleEnableDisableRule(row) {
      this.resetForm({ ...row, enabled: !row.enabled });
      this.editRelayRule();
    },
    onModalHidden() {
      this.isAddDialogShow = false;
      this.isEditDialogShow = false;
      this.isAddWildcardDialogShow = false;
      this.clearErrors();
      this.resetForm();
    },
    onModalConfirm() {
      if (this.isAddDialogShow || this.isAddWildcardDialogShow) {
        this.addRelayRule();
      } else if (this.isEditDialogShow) {
        this.editRelayRule();
      }
    },
    toggleDeleteRule(row) {
      this.resetForm(row);
      this.isDeleteDialogShow = true;
    },
    onDeleteModalHidden() {
      this.isDeleteDialogShow = false;
      this.resetForm();
    },
    onDeleteModalConfirm() {
      this.deleteRelayRule();
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

.radio-menu-label {
  font-size: 12px;
  color: #525252;
  margin-top: 2px;
  margin-bottom: 8px;
}

.radio-menu-error {
  color: #da1e28;
  margin-top: -18px;
  margin-bottom: 12px;
}
</style>
