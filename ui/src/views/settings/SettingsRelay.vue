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
            <span>{{ $t("relay.title") }}</span>
          </cv-breadcrumb-item>
        </cv-breadcrumb>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("relay.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.setRelaySettings">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.set-mailbox-settings')"
          :description="error.setRelaySettings"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getRelaySettings">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-mailbox-settings')"
          :description="error.getRelaySettings"
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
                  v-if="loading.getRelaySettings"
                  heading
                  paragraph
                  :line-count="8"
                  width="80%"
                ></cv-skeleton-text>
                <cv-form v-else @submit.prevent="setRelaySettings">
                  <div class="text-area-label-and-tooltip">
                    <span class="text-area-label">{{
                      $t("relay.settings.ip_label")
                    }}</span>
                    <cv-interactive-tooltip
                      alignment="center"
                      direction="bottom"
                      class="tooltip-icon info"
                    >
                      <template slot="trigger">
                        <Information16 />
                      </template>
                      <template slot="content">
                        <div>
                          {{ $t("relay.settings.ip_tooltip") }}
                        </div>
                      </template>
                    </cv-interactive-tooltip>
                  </div>
                  <cv-text-area
                    v-model="ip_addresses"
                    ref="ip_addresses"
                    :invalid-message="$t(error.ip_addresses)"
                    type="text"
                    :helper-text="$t('relay.settings.ip_helper')"
                    :disabled="
                      loading.getRelaySettings || loading.setRelaySettings
                    "
                    class="text-area-size"
                  >
                  </cv-text-area>
                  <NsToggle
                    v-model="enforce"
                    ref="enforce"
                    :label="$t('relay.settings.toggle_label')"
                    :form-item="true"
                    :disabled="
                      loading.getRelaySettings || loading.setRelaySettings
                    "
                    ><template slot="tooltip">
                      <span v-html="$t('relay.settings.toggle_tooltip')"></span>
                    </template>
                    <template slot="text-left">{{
                      $t("common.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("common.enabled")
                    }}</template>
                  </NsToggle>
                  <NsButton
                    kind="primary"
                    :icon="Save20"
                    :loading="loading.setRelaySettings"
                    :disabled="
                      loading.getRelaySettings || loading.setRelaySettings
                    "
                    >{{ $t("relay.settings.save") }}</NsButton
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
import Information16 from "@carbon/icons-vue/es/information/16";

export default {
  name: "settingsRelay",
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  components: {
    Information16,
  },
  pageTitle() {
    return this.$t("relay.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settingsRelay",
      },
      ip_addresses: "",
      enforce: false,
      loading: {
        getRelaySettings: false,
        setRelaySettings: false,
      },
      error: {
        getRelaySettings: "",
        setRelaySettings: "",
        ip_addresses: "",
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
    this.getRelaySettings();
  },
  methods: {
    goToSettings() {
      this.goToAppPage(this.instanceName, "settings");
    },
    async getRelaySettings() {
      this.loading.getRelaySettings = true;
      this.error.getRelaySettings = "";
      const taskAction = "get-queue-settings"; // TODO put correct task
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getRelaySettingsAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getRelaySettingsCompleted
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
        this.error.getRelaySettings = this.getErrorMessage(err);
        this.loading.getRelaySettings = false;
        return;
      }
    },
    getRelaySettingsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getRelaySettings = this.$t("error.generic_error");
      this.loading.getRelaySettings = false;
    },
    getRelaySettingsCompleted(taskContext, taskResult) {
      this.loading.getRelaySettings = false;
      this.ip_addresses = taskResult.output.ip_addresses;
      this.enforce = taskResult.output.enforce;
    },
    validatesetRelaySettings() {
      this.clearErrors();
      let isValidationOk = true;

      if (!this.ip_addresses) {
        this.error.ip_addresses = this.$t("common.required");
        if (isValidationOk) {
          this.focusElement("ip_addresses");
          isValidationOk = false;
        }
      } else if (this.ip_addresses && parseInt(this.ip_addresses) < 1) {
        this.error.ip_addresses = this.$t(
          "settings_queue.must_be_superior_or_equal_to_1"
        );
        if (isValidationOk) {
          this.focusElement("ip_addresses");
          isValidationOk = false;
        }
      } else if (this.ip_addresses && parseInt(this.ip_addresses) > 200) {
        this.error.ip_addresses = this.$t(
          "settings_queue.must_be_inferior_or_equal_to_200"
        );
        if (isValidationOk) {
          this.focusElement("ip_addresses");
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    async setRelaySettings() {
      if (!this.validatesetRelaySettings()) {
        return;
      }
      this.loading.setRelaySettings = true;
      this.error.setRelaySettings = "";
      this.error.ip_addresses = "";
      const taskAction = "set-queue-settings"; // TODO put correct task
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setRelaySettingsAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.setRelaySettingsValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setRelaySettingsCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            ip_addresses: parseInt(this.ip_addresses),
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
        this.error.setRelaySettings = this.getErrorMessage(err);
        this.loading.setRelaySettings = false;
        return;
      }
    },
    setRelaySettingsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setRelaySettings = this.$t("error.generic_error");
      this.loading.setRelaySettings = false;
    },
    setRelaySettingsValidationFailed(validationErrors) {
      this.loading.setRelaySettings = false;
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
    setRelaySettingsCompleted() {
      this.loading.setRelaySettings = false;

      // reload settings
      this.getRelaySettings();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.cv-form .bx--form-item {
  margin-bottom: $spacing-07;
}

.text-area-size {
  width: 50%;
}

.tooltip-icon {
  margin-left: $spacing-02;
}

.text-area-label {
  font-size: 0.75rem;
  letter-spacing: 0.32px;
  width: 100%;
  color: #525252;
  opacity: 1;
  margin-bottom: 5px;
}

.text-area-label-and-tooltip {
  flex-direction: row;
}
</style>
