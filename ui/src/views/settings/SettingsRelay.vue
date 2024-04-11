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
    <cv-row>
      <cv-column>
        <cv-tile light>
          <cv-grid fullWidth class="no-padding">
            <cv-row>
              <cv-column>
                <cv-skeleton-text
                  v-if="loading.getRelayConfiguration"
                  heading
                  paragraph
                  :line-count="11"
                  width="80%"
                >
                </cv-skeleton-text>
                <cv-form v-else @submit.prevent="setRelayConfiguration">
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
                    v-model="networks"
                    ref="networks"
                    :invalid-message="error.networks"
                    type="text"
                    :helper-text="$t('relay.settings.ip_helper')"
                    class="text-area-size"
                    rows="6"
                  >
                  </cv-text-area>
                  <NsToggle
                    v-model="postfix_restricted_sender"
                    ref="postfix_restricted_sender"
                    :label="$t('relay.settings.toggle_label')"
                    :form-item="true"
                    value="toggleValue"
                  >
                    <template slot="tooltip">
                      <span v-html="$t('relay.settings.toggle_tooltip')"></span>
                    </template>
                    <template slot="text-left"
                      >{{ $t("common.disabled") }}
                    </template>
                    <template slot="text-right"
                      >{{ $t("common.enabled") }}
                    </template>
                  </NsToggle>
                  <NsButton
                    kind="primary"
                    :icon="Save20"
                    :loading="loading.setRelayConfiguration"
                    :disabled="
                      loading.getRelayConfiguration ||
                      loading.setRelayConfiguration
                    "
                    >{{ $t("relay.settings.save") }}
                  </NsButton>
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
      networks: "",
      postfix_restricted_sender: false,
      loading: {
        getRelayConfiguration: false,
        setRelayConfiguration: false,
      },
      error: {
        getRelayConfiguration: "",
        setRelayConfiguration: "",
        networks: "",
      },
    };
  },
  computed: {
    ...mapState(["core", "appName", "instanceName"]),
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
    this.getRelayConfiguration();
  },
  methods: {
    goToSettings() {
      this.goToAppPage(this.instanceName, "settings");
    },
    arrayToString(networks) {
      return networks.join("\n");
    },
    stringToArray(networks) {
      const lines = networks.split("\n");
      const array = [];

      for (const line of lines) {
        if (line != "") {
          array.push(line);
        }
      }
      return array;
    },
    async getRelayConfiguration() {
      this.loading.getRelayConfiguration = true;
      this.error.getRelayConfiguration = "";
      const taskAction = "get-relay-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getRelayConfigurationAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getRelayConfigurationCompleted
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
        this.error.getRelayConfiguration = this.getErrorMessage(err);
        this.loading.getRelayConfiguration = false;
        return;
      }
    },
    getRelayConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.getRelayConfiguration = false;
    },
    getRelayConfigurationCompleted(taskContext, taskResult) {
      this.loading.getRelayConfiguration = false;
      this.networks = this.arrayToString(taskResult.output.networks);
      this.postfix_restricted_sender =
        taskResult.output.postfix_restricted_sender;
    },
    validateSetRelayConfiguration() {
      this.clearErrors();
      let isValidationOk = true;

      if (!this.networks) {
        this.error.networks = this.$t("common.required_field");

        if (isValidationOk) {
          this.focusElement("networks");
          isValidationOk = false;
        }
      }

      return isValidationOk;
    },
    async setRelayConfiguration() {
      if (!this.validateSetRelayConfiguration()) {
        return;
      }

      this.loading.setRelayConfiguration = true;
      this.error.setRelayConfiguration = "";
      const taskAction = "set-relay-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setRelayConfigurationAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.setRelayConfigurationValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setRelayConfigurationCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            networks: this.stringToArray(this.networks),
            postfix_restricted_sender: this.postfix_restricted_sender,
          },
          extra: {
            title: this.$t("action." + taskAction),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.setRelayConfiguration = this.getErrorMessage(err);
        this.loading.setRelayConfiguration = false;
        return;
      }
    },
    setRelayConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.setRelayConfiguration = false;
    },
    setRelayConfigurationValidationFailed(validationErrors) {
      this.loading.setRelayConfiguration = false;

      const errorLines = [];
      for (const validationError of validationErrors) {
        const line = parseInt(validationError.field.split(".")[1]);
        if (!errorLines.find((x) => x == line + 1)) {
          errorLines.push(line + 1);
        }
      }

      this.error.networks = this.$tc(
        "relay.error.networks_format_error",
        errorLines.length,
        {
          lines: errorLines.join(", "),
        }
      );
    },
    setRelayConfigurationCompleted() {
      this.loading.setRelayConfiguration = false;

      // reload settings
      this.getRelayConfiguration();
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
