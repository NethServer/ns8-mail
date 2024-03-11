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
            <span>{{ $t("settings_queue.title") }}</span>
          </cv-breadcrumb-item>
        </cv-breadcrumb>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings_queue.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.setQueueSettings">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.set-mailbox-settings')"
          :description="error.setQueueSettings"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getQueueSettings">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-mailbox-settings')"
          :description="error.getQueueSettings"
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
                <cv-skeleton-text
                  v-if="loading.getQueueSettings"
                  heading
                  paragraph
                  :line-count="4"
                  width="80%"
                ></cv-skeleton-text>
                <cv-form v-else @submit.prevent="setQueueSettings">
                  <NsTextInput
                    v-model.trim="maximal_queue_lifetime"
                    ref="maximal_queue_lifetime"
                    :invalid-message="$t(error.maximal_queue_lifetime)"
                    type="number"
                    min="1"
                    max="200"
                    placeholder="120"
                    :label="$t('settings_queue.maximal_queue_lifetime')"
                    :helper-text="
                      $t('settings_queue.maximal_queue_lifetime_helper')
                    "
                    tooltipAlignment="start"
                    tooltipDirection="right"
                    :disabled="
                      loading.getQueueSettings || loading.setQueueSettings
                    "
                  >
                    <template slot="tooltip">
                      {{ $t("settings_queue.maximal_queue_lifetime_tooltip") }}
                    </template>
                  </NsTextInput>

                  <NsButton
                    kind="secondary"
                    :icon="Save20"
                    :loading="loading.setQueueSettings"
                    :disabled="
                      loading.getQueueSettings || loading.setQueueSettings
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
  name: "SettingsQueue",
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
        page: "settingsQueue",
      },
      urlCheckInterval: null,
      maximal_queue_lifetime: "120",
      loading: {
        getQueueSettings: false,
        setQueueSettings: false,
      },
      error: {
        getQueueSettings: "",
        setQueueSettings: "",
        maximal_queue_lifetime: "",
      },
    };
  },
  computed: {
    ...mapState(["core", "appName", "instanceName"]),
  },
  watch: {},
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
    this.getQueueSettings();
  },
  methods: {
    goToSettings() {
      this.goToAppPage(this.instanceName, "settings");
    },
    async getQueueSettings() {
      this.loading.getQueueSettings = true;
      this.error.getQueueSettings = "";
      const taskAction = "get-queue-settings";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getQueueSettingsAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getQueueSettingsCompleted
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
        this.error.getQueueSettings = this.getErrorMessage(err);
        this.loading.getQueueSettings = false;
        return;
      }
    },
    getQueueSettingsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getQueueSettings = this.$t("error.generic_error");
      this.loading.getQueueSettings = false;
    },
    getQueueSettingsCompleted(taskContext, taskResult) {
      this.loading.getQueueSettings = false;
      this.maximal_queue_lifetime = taskResult.output.maximal_queue_lifetime;
    },
    validateSetQueueSettings() {
      this.clearErrors();
      let isValidationOk = true;

      if (!this.maximal_queue_lifetime) {
        this.error.maximal_queue_lifetime = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("maximal_queue_lifetime");
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    async setQueueSettings() {
      if (!this.validateSetQueueSettings()) {
        return;
      }
      this.loading.setQueueSettings = true;
      this.error.setQueueSettings = "";
      this.error.maximal_queue_lifetime = "";
      const taskAction = "set-queue-settings";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setQueueSettingsAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.setQueueSettingsValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setQueueSettingsCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            maximal_queue_lifetime: parseInt(this.maximal_queue_lifetime),
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
        this.error.setQueueSettings = this.getErrorMessage(err);
        this.loading.setQueueSettings = false;
        return;
      }
    },
    setQueueSettingsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setQueueSettings = this.$t("error.generic_error");
      this.loading.setQueueSettings = false;
    },
    setQueueSettingsValidationFailed(validationErrors) {
      this.loading.setQueueSettings = false;
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
    setQueueSettingsCompleted() {
      this.loading.setQueueSettings = false;

      // reload settings
      this.getQueueSettings();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.cv-form .bx--form-item {
  margin-bottom: $spacing-07;
}
</style>
