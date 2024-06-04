<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column>
        <cv-breadcrumb
          aria-label="breadcrumb"
          :no-trailing-slash="true"
          class="breadcrumb"
        >
          <cv-breadcrumb-item>
            <cv-link @click="goToSettings">{{ $t("settings.title") }}</cv-link>
          </cv-breadcrumb-item>
          <cv-breadcrumb-item>
            <span>{{ $t("settings_mailboxes.title") }}</span>
          </cv-breadcrumb-item>
        </cv-breadcrumb>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings_mailboxes.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.setMailboxSettings">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.set-mailbox-settings')"
          :description="error.setMailboxSettings"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getMailboxSettings">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-mailbox-settings')"
          :description="error.getMailboxSettings"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-else>
      <cv-column>
        <cv-tile light>
          <cv-grid fullWidth class="no-padding">
            <cv-row>
              <cv-column>
                <h4 class="mg-bottom-md">
                  {{ $t("settings_mailboxes.quota") }}
                </h4>
                <cv-skeleton-text
                  v-if="loading.getMailboxSettings"
                  heading
                  paragraph
                  :line-count="4"
                  width="80%"
                ></cv-skeleton-text>
                <cv-form v-else @submit.prevent="setMailboxSettings">
                  <NsByteSlider
                    v-model="quota.limit"
                    :label="$t('settings_mailboxes.default_mail_quota')"
                    min="1"
                    max="10240"
                    step="1"
                    stepMultiplier="1023"
                    minLabel=""
                    maxLabel=""
                    showUnlimited
                    :unlimitedLabel="$t('settings_mailboxes.unlimited')"
                    :limitedLabel="$t('settings_mailboxes.specify_quota')"
                    :isUnlimited="quota.unlimited"
                    :byteUnit="quota.byteUnit"
                    showHumanReadableLabel
                    showMibGibToggle
                    tagKind="high-contrast"
                    :invalidMessage="error.limit"
                    :disabled="loading.setMailboxSettings"
                    @unlimited="quota.unlimited = $event"
                    @byteUnit="quota.byteUnit = $event"
                  />
                  <NsButton
                    kind="secondary"
                    :icon="Save20"
                    :loading="loading.setMailboxSettings"
                    :disabled="
                      loading.getMailboxSettings || loading.setMailboxSettings
                    "
                    >{{ $t("common.save_settings") }}</NsButton
                  >
                </cv-form>
              </cv-column>
            </cv-row>
          </cv-grid>
        </cv-tile>
        <cv-tile light>
          <cv-grid fullWidth class="no-padding">
            <cv-row>
              <cv-column>
                <h4 class="mg-bottom-md">
                  {{ $t("settings_mailboxes.shared_mailboxes") }}
                </h4>
                <cv-skeleton-text
                  v-if="loading.getMailboxSettings"
                  heading
                  paragraph
                  :line-count="4"
                  width="80%"
                ></cv-skeleton-text>
                <cv-form v-else @submit.prevent="setMailboxSettings">
                  <NsToggle
                    :label="$t('settings_mailboxes.sharedseen')"
                    value="sharedSeenValue"
                    :form-item="true"
                    v-model="sharedseen.enabled"
                    :disabled="
                      loading.getMailboxSettings || loading.setMailboxSettings
                    "
                    class="toggle-without-label"
                  >
                    <template slot="tooltip">
                      <span>{{
                        $t("settings_mailboxes.sharedseen_explanation_tooltips")
                      }}</span>
                    </template>
                    <template slot="text-left">{{
                      $t("common.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("common.enabled")
                    }}</template>
                  </NsToggle>
                  <NsButton
                    kind="secondary"
                    :icon="Save20"
                    :loading="loading.setMailboxSettings"
                    :disabled="
                      loading.getMailboxSettings || loading.setMailboxSettings
                    "
                    >{{ $t("common.save_settings") }}</NsButton
                  >
                </cv-form>
              </cv-column>
            </cv-row>
          </cv-grid>
        </cv-tile>
        <cv-tile light>
          <cv-grid fullWidth class="no-padding">
            <cv-row>
              <cv-column>
                <h4 class="mg-bottom-md">
                  {{ $t("settings_mailboxes.spam") }}
                </h4>
                <cv-skeleton-text
                  v-if="loading.getMailboxSettings"
                  heading
                  paragraph
                  :line-count="7"
                  width="80%"
                ></cv-skeleton-text>
                <cv-form v-else @submit.prevent="setMailboxSettings">
                  <NsSlider
                    v-model="spamRetention.value"
                    :label="$t('settings_mailboxes.default_spam_retention')"
                    min="1"
                    max="180"
                    step="1"
                    stepMultiplier="10"
                    minLabel=""
                    maxLabel=""
                    showUnlimited
                    :unlimitedLabel="$t('settings_mailboxes.forever')"
                    :limitedLabel="$t('settings_mailboxes.specify_retention')"
                    :isUnlimited="spamRetention.unlimited"
                    :invalidMessage="error.value"
                    :disabled="loading.setMailboxSettings"
                    :unitLabel="$t('mailboxes.days')"
                    @unlimited="spamRetention.unlimited = $event"
                  />
                  <NsToggle
                    value="spamFolderValue"
                    :form-item="true"
                    v-model="spamFolder.enabled"
                    :disabled="loading.setMailboxSettings"
                    :class="[
                      'toggle-without-label',
                      'mg-top-sm',
                      { 'mg-bottom-md': spamFolder.enabled },
                    ]"
                  >
                    <template slot="text-left"
                      >{{ $t("settings_mailboxes.move_spam_to_junk_folder") }}
                    </template>
                    <template slot="text-right"
                      >{{ $t("settings_mailboxes.move_spam_to_junk_folder") }}
                    </template>
                  </NsToggle>
                  <NsTextInput
                    v-show="spamFolder.enabled"
                    v-model.trim="spamFolder.name"
                    :label="$t('settings_mailboxes.junk_folder_name')"
                    :invalid-message="$t(error.spam_folder)"
                    :disabled="loading.setMailboxSettings"
                    class="toggle-dependent"
                    ref="spamFolder"
                  />
                  <!-- add a prefix to spam messages subject (the same component is in Filter page) -->
                  <NsToggle
                    value="prefixSpamValue"
                    :form-item="true"
                    v-model="addPrefixToSpamSubject.enabled"
                    :disabled="
                      loading.getMailboxSettings || loading.setMailboxSettings
                    "
                    :class="[
                      'toggle-without-label',
                      { 'mg-bottom-md': addPrefixToSpamSubject.enabled },
                    ]"
                    ref="isAddPrefixToSpamSubject"
                  >
                    <template slot="text-left">{{
                      $t("filter.add_prefix_to_spam_subject")
                    }}</template>
                    <template slot="text-right">{{
                      $t("filter.add_prefix_to_spam_subject")
                    }}</template>
                  </NsToggle>
                  <NsTextInput
                    v-if="addPrefixToSpamSubject.enabled"
                    v-model.trim="addPrefixToSpamSubject.prefix"
                    :label="$t('filter.prefix')"
                    :invalid-message="error.spamSubjectPrefix"
                    :disabled="
                      loading.getMailboxSettings || loading.setMailboxSettings
                    "
                    class="toggle-dependent"
                    ref="spamSubjectPrefix"
                  />
                  <NsButton
                    kind="secondary"
                    :icon="Save20"
                    :loading="loading.setMailboxSettings"
                    :disabled="
                      loading.getMailboxSettings || loading.setMailboxSettings
                    "
                    >{{ $t("common.save_settings") }}</NsButton
                  >
                </cv-form>
              </cv-column>
            </cv-row>
          </cv-grid>
        </cv-tile>
      </cv-column>
    </cv-row>
  </cv-grid>
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

export default {
  name: "SettingsMailboxes",
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings_mailboxes.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settingsMailboxes",
      },
      urlCheckInterval: null,
      quota: {
        limit: "10",
        unlimited: true,
        byteUnit: "gib",
      },
      spamRetention: {
        value: "30",
        unlimited: true,
      },
      spamFolder: {
        enabled: true,
        name: "",
      },
      addPrefixToSpamSubject: {
        enabled: false,
        prefix: "",
      },
      sharedseen: {
        enabled: true,
      },
      loading: {
        getMailboxSettings: false,
        setMailboxSettings: false,
      },
      error: {
        getMailboxSettings: "",
        setMailboxSettings: "",
        limit: "",
        value: "",
        spam_folder: "",
        spamSubjectPrefix: "",
      },
    };
  },
  computed: {
    ...mapState(["core", "appName", "instanceName"]),
  },
  watch: {
    "spamFolder.enabled": function () {
      if (this.spamFolder.enabled) {
        this.$nextTick(() => {
          this.focusElement("spamFolder");
        });
      }
    },
    "addPrefixToSpamSubject.enabled": function () {
      if (this.addPrefixToSpamSubject.enabled) {
        this.$nextTick(() => {
          this.focusElement("spamSubjectPrefix");
        });
      }
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
    this.getMailboxSettings();
  },
  methods: {
    goToSettings() {
      this.goToAppPage(this.instanceName, "settings");
    },
    async getMailboxSettings() {
      this.loading.getMailboxSettings = true;
      this.error.getMailboxSettings = "";
      const taskAction = "get-mailbox-settings";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getMailboxSettingsAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getMailboxSettingsCompleted
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
        this.error.getMailboxSettings = this.getErrorMessage(err);
        this.loading.getMailboxSettings = false;
        return;
      }
    },
    getMailboxSettingsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getMailboxSettings = this.$t("error.generic_error");
      this.loading.getMailboxSettings = false;
    },
    getMailboxSettingsCompleted(taskContext, taskResult) {
      this.loading.getMailboxSettings = false;
      const settings = taskResult.output;
      this.quota.unlimited = !settings.quota.limit;

      if (settings.quota.limit) {
        // show quota in MiB if it's not a multiple of 1 GiB
        if (settings.quota.limit % 1024 !== 0) {
          this.quota.byteUnit = "mib";
          this.quota.limit = settings.quota.limit.toString();
        } else {
          this.quota.byteUnit = "gib";
          this.quota.limit = (settings.quota.limit / 1024).toString();
        }
      }
      this.spamRetention.unlimited = !settings.spam_retention.value;

      if (settings.spam_retention.value) {
        this.spamRetention.value = settings.spam_retention.value.toString();
      }

      this.spamFolder.enabled = settings.spam_folder.enabled;

      if (settings.spam_folder.enabled) {
        this.spamFolder.name = settings.spam_folder.name;
      } else {
        this.spamFolder.name = "";
      }
      this.sharedseen.enabled = settings.sharedseen.enabled;

      // spam prefix
      this.addPrefixToSpamSubject.enabled = settings.spam_prefix.enabled;
      this.addPrefixToSpamSubject.prefix = settings.spam_prefix.prefix;
    },
    validateSetMailboxSettings() {
      this.clearErrors();
      let isValidationOk = true;

      // move spam to junk folder, but no folder name is provided

      if (this.spamFolder.enabled && !this.spamFolder.name) {
        this.error.spam_folder = this.$t(
          "settings_mailboxes.move_spam_but_no_folder"
        );

        if (isValidationOk) {
          this.focusElement("spam_folder");
          isValidationOk = false;
        }
      }
      if (
        this.addPrefixToSpamSubject.enabled &&
        !this.addPrefixToSpamSubject.prefix
      ) {
        this.error.spamSubjectPrefix = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("spamSubjectPrefix");
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    async setMailboxSettings() {
      if (!this.validateSetMailboxSettings()) {
        return;
      }

      this.loading.setMailboxSettings = true;
      this.error.setMailboxSettings = "";
      const taskAction = "set-mailbox-settings";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setMailboxSettingsAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.setMailboxSettingsValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setMailboxSettingsCompleted
      );

      // quota

      let quota = {
        limit: 0,
      };

      if (!this.quota.unlimited) {
        if (this.quota.byteUnit === "gib") {
          quota.limit = parseInt(this.quota.limit) * 1024;
        } else {
          // mib
          quota.limit = parseInt(this.quota.limit);
        }
      }

      // spam folder

      let spamFolder = {
        enabled: this.spamFolder.enabled,
      };

      if (this.spamFolder.enabled) {
        spamFolder.name = this.spamFolder.name;
      }

      // spam retention

      let spamRetention = {
        value: 0,
      };

      if (!this.spamRetention.unlimited) {
        spamRetention.value = parseInt(this.spamRetention.value);
      }

      // sharedseen
      let sharedseen = {
        enabled: this.sharedseen.enabled,
      };

      // spam prefix

      let spamPrefix = {
        enabled: this.addPrefixToSpamSubject.enabled,
      };

      if (this.addPrefixToSpamSubject.enabled) {
        spamPrefix.prefix = this.addPrefixToSpamSubject.prefix;
      }

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            quota: quota,
            spam_folder: spamFolder,
            spam_retention: spamRetention,
            sharedseen: sharedseen,
            spam_prefix: spamPrefix,
          },
          extra: {
            title: this.$t("action." + taskAction),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.setMailboxSettings = this.getErrorMessage(err);
        this.loading.setMailboxSettings = false;
        return;
      }
    },
    setMailboxSettingsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setMailboxSettings = this.$t("error.generic_error");
      this.loading.setMailboxSettings = false;
    },
    setMailboxSettingsValidationFailed(validationErrors) {
      this.loading.setMailboxSettings = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "settings_mailboxes." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    setMailboxSettingsCompleted() {
      this.loading.setMailboxSettings = false;

      // reload settings
      this.getMailboxSettings();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.cv-form .bx--form-item {
  margin-bottom: $spacing-07;
}

.toggle-dependent {
  margin-bottom: $spacing-07;
}
</style>
