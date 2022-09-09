<!--
  Copyright (C) 2022 Nethesis S.r.l.
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
            <span>{{ $t("settings_general.title") }}</span>
          </cv-breadcrumb-item>
        </cv-breadcrumb>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column class="subpage-title">
        <h3>{{ $t("settings_general.title") }}</h3>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.configureModule">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.configure-module')"
          :description="error.configureModule"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getConfiguration">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-configuration')"
          :description="error.getConfiguration"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <template v-else>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <cv-grid fullWidth class="no-padding">
              <cv-row>
                <cv-column>
                  <cv-skeleton-text
                    v-if="loading.getConfiguration || loading.getDefaults"
                    heading
                    paragraph
                    :line-count="7"
                    width="80%"
                  ></cv-skeleton-text>
                  <cv-form v-else @submit.prevent="configureModule">
                    <NsTextInput
                      v-model.trim="config.hostname"
                      :label="$t('settings_general.mail_hostname')"
                      :invalid-message="error.hostname"
                      :disabled="loading.configureModule"
                      ref="hostname"
                    />
                    <label class="bx--label">
                      {{ $t("settings_general.user_domain") }}
                    </label>
                    <cv-grid class="no-padding">
                      <cv-row>
                        <cv-column
                          v-for="userDomain in userDomains"
                          :key="userDomain.name"
                          :md="4"
                          :xlg="4"
                        >
                          <NsTile
                            kind="selectable"
                            v-model="userDomain.selected"
                            :footerIcon="Events20"
                            @click="deselectOtherDomains(userDomain)"
                            value="domainValue"
                            :disabled="loading.configureModule"
                            class="no-mg-bottom"
                          >
                            <h6>
                              {{ userDomain.name }}
                            </h6>
                            <div class="mg-top-md">
                              <span>{{
                                core.$t("domains." + userDomain.location)
                              }}</span>
                              <span v-if="userDomain.schema == 'rfc2307'">
                                {{ core.$t("domains.openldap") }}
                              </span>
                              <span v-else-if="userDomain.schema == 'ad'">
                                {{ core.$t("domains.samba") }}
                              </span>
                            </div>
                          </NsTile>
                        </cv-column>
                      </cv-row>
                    </cv-grid>
                    <div
                      class="validation-failed-invalid-message"
                      v-if="error.user_domain"
                    >
                      {{ error.user_domain }}
                    </div>
                    <NsButton
                      kind="primary"
                      :icon="Save20"
                      :loading="loading.configureModule"
                      :disabled="
                        loading.getConfiguration ||
                        loading.getDefaults ||
                        loading.configureModule
                      "
                      class="mg-top-xlg"
                      >{{ $t("common.save_settings") }}</NsButton
                    >
                  </cv-form>
                </cv-column>
              </cv-row>
            </cv-grid>
          </cv-tile>
        </cv-column>
      </cv-row>
    </template>
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
  name: "SettingsGeneral",
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings_general.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settingsGeneral",
      },
      urlCheckInterval: null,
      config: { hostname: "", user_domain: {} },
      userDomains: [],
      loading: {
        getConfiguration: false,
        configureModule: false,
        getDefaults: false,
      },
      error: {
        getConfiguration: "",
        configureModule: "",
        getDefaults: "",
        hostname: "",
        user_domain: "",
      },
    };
  },
  computed: {
    ...mapState(["core", "appName", "instanceName"]),
    selectedUserDomain() {
      return this.userDomains.find((domain) => domain.selected);
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
    this.getConfiguration();
    this.getDefaults();
  },
  methods: {
    goToSettings() {
      this.goToAppPage(this.instanceName, "settings");
    },
    async getConfiguration() {
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
      const taskAction = "get-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getConfigurationAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getConfigurationCompleted
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
        this.error.getConfiguration = this.getErrorMessage(err);
        this.loading.getConfiguration = false;
        return;
      }
    },
    getConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getConfiguration = this.$t("error.generic_error");
      this.loading.getConfiguration = false;
    },
    getConfigurationCompleted(taskContext, taskResult) {
      this.loading.getConfiguration = false;
      const config = taskResult.output;
      this.config.hostname = config.hostname;
      this.config.user_domain = config.user_domain;

      // select user domain if get-defaults has completed
      if (this.userDomains.length) {
        this.selectUserDomain(config.user_domain.name);
      }
    },
    selectUserDomain(userDomainName) {
      const userDomain = this.userDomains.find(
        (ud) => ud.name === userDomainName
      );

      if (userDomain) {
        userDomain.selected = true;
      }
    },
    validateConfigureModule() {
      this.clearErrors();
      let isValidationOk = true;

      // hostname

      if (!this.config.hostname) {
        this.error.hostname = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("hostname");
          isValidationOk = false;
        }
      }

      // user domain

      if (!this.selectedUserDomain) {
        this.error.user_domain = this.$t("common.required");

        if (isValidationOk) {
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    async configureModule() {
      if (!this.validateConfigureModule()) {
        return;
      }

      this.loading.configureModule = true;
      this.error.configureModule = "";
      const taskAction = "configure-module";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.configureModuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.configureModuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.configureModuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            hostname: this.config.hostname,
            user_domain: this.selectedUserDomain.name,
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
        this.error.configureModule = this.getErrorMessage(err);
        this.loading.configureModule = false;
        return;
      }
    },
    configureModuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.configureModule = this.$t("error.generic_error");
      this.loading.configureModule = false;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "settings_general." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    configureModuleCompleted() {
      this.loading.configureModule = false;

      // reload settings
      this.getConfiguration();
    },
    async getDefaults() {
      this.loading.getDefaults = true;
      this.error.getDefaults = "";
      const taskAction = "get-defaults";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getDefaultsAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getDefaultsCompleted
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
        this.error.getDefaults = this.getErrorMessage(err);
        this.loading.getDefaults = false;
        return;
      }
    },
    getDefaultsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.getDefaults = false;
    },
    getDefaultsCompleted(taskContext, taskResult) {
      const defaults = taskResult.output;
      this.userDomains = defaults.user_domains.map((d) => {
        return {
          name: d.name,
          schema: d.schema,
          location: d.location,
          selected: false,
        };
      });

      // select user domain if get-configuration has completed
      if (this.config.user_domain.name) {
        this.selectUserDomain(this.config.user_domain.name);
      }

      this.loading.getDefaults = false;
    },
    deselectOtherDomains(domain) {
      for (let d of this.userDomains) {
        if (d.name !== domain.name) {
          d.selected = false;
        }
      }
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.cv-form .bx--form-item {
  margin-bottom: $spacing-07;
}

.no-mg-bottom {
  margin-bottom: 0 !important;
}
</style>
