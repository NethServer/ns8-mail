<template>
  <NsWizard
    size="default"
    :visible="isShown"
    :cancelLabel="core.$t('common.cancel')"
    :previousLabel="core.$t('common.previous')"
    :nextLabel="
      isLastStep ? $t('welcome.create_domain') : core.$t('common.next')
    "
    :isPreviousDisabled="isFirstStep || loading.configureModule"
    :isNextDisabled="isNextButtonDisabled"
    :isNextLoading="loading.configureModule"
    :isCancelDisabled="true"
    @previousStep="previousStep"
    @nextStep="nextStep"
    auto-hide-off
  >
    <template slot="title">{{ $t("welcome.title") }}</template>
    <template slot="content">
      <cv-form>
        <NsInlineNotification
          v-if="error.getDefaults"
          kind="error"
          :title="$t('action.get-defaults')"
          :description="error.getDefaults"
          :showCloseButton="false"
        />
        <template v-if="step == 'mailHostname'">
          <cv-skeleton-text
            v-if="loading.getDefaults"
            :paragraph="true"
            :line-count="6"
          ></cv-skeleton-text>
          <!-- no user domain configured -->
          <template v-else-if="!userDomains.length">
            <NsEmptyState :title="$t('welcome.no_domain_configured')">
              <template #description>
                <div>
                  {{ $t("welcome.no_domain_configured_description") }}
                </div>
                <NsButton
                  kind="ghost"
                  :icon="Events20"
                  @click="goToDomainsAndUsers"
                  class="empty-state-button"
                >
                  {{ $t("welcome.go_to_domains_and_users") }}
                </NsButton>
              </template>
            </NsEmptyState>
          </template>
          <!-- there are user domains configured -->
          <template v-else>
            <div class="mg-bottom-xlg">
              <div>{{ $t("welcome.welcome_message") }}</div>
            </div>
            <NsTextInput
              v-model.trim="hostname"
              :label="$t('welcome.mail_hostname')"
              :invalid-message="error.hostname"
              :disabled="loading.configureModule"
              @input="onChangeMailHostname"
              ref="hostname"
            />
            <NsTextInput
              v-model.trim="mail_domain"
              :label="$t('welcome.primary_mail_domain')"
              :invalid-message="error.mail_domain"
              :disabled="loading.configureModule"
              ref="mail_domain"
            />
          </template>
        </template>
        <template v-else-if="step == 'userDomain'">
          <div class="mg-bottom-xlg">
            {{ $t("welcome.select_domain_description") }}
          </div>
          <cv-grid class="no-padding">
            <cv-row>
              <cv-column
                v-for="userDomain in userDomains"
                :key="userDomain.name"
                :md="4"
              >
                <NsTile
                  light
                  kind="selectable"
                  v-model="userDomain.selected"
                  :footerIcon="Events20"
                  @click="deselectOtherDomains(userDomain)"
                  value="domainValue"
                  :disabled="loading.configureModule"
                >
                  <h6>
                    {{ userDomain.name }}
                  </h6>
                  <div class="mg-top-md">
                    <span>{{ core.$t("domains." + userDomain.location) }}</span>
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
        </template>
      </cv-form>
    </template>
  </NsWizard>
</template>

<script>
import { UtilService, TaskService, IconService } from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import { mapState, mapActions } from "vuex";

export default {
  name: "FirstConfigurationModal",
  mixins: [UtilService, TaskService, IconService],
  props: {
    isShown: {
      type: Boolean,
      default: true,
    },
  },
  data() {
    return {
      step: "",
      steps: ["mailHostname", "userDomain"],
      hostname: "",
      mail_domain: "",
      userDomains: [],
      loading: {
        configureModule: false,
        getDefaults: false,
        getConfiguration: false,
      },
      error: {
        configureModule: "",
        getDefaults: "",
        getConfiguration: "",
        hostname: "",
        mail_domain: "",
      },
    };
  },
  computed: {
    ...mapState(["core", "instanceName"]),
    stepIndex() {
      return this.steps.indexOf(this.step);
    },
    isFirstStep() {
      return this.stepIndex == 0;
    },
    isLastStep() {
      return this.stepIndex == this.steps.length - 1;
    },
    selectedUserDomain() {
      return this.userDomains.find((domain) => domain.selected);
    },
    isNextButtonDisabled() {
      return (
        this.loading.configureModule ||
        (this.step == "mailHostname" &&
          (!this.hostname || !this.mail_domain)) ||
        (this.step == "userDomain" && !this.selectedUserDomain)
      );
    },
  },
  watch: {
    isShown: function () {
      if (this.isShown) {
        // show first step
        this.step = this.steps[0];
        this.getDefaults();
      }
    },
  },
  created() {
    this.step = this.steps[0];
  },
  mounted() {
    if (this.isShown) {
      this.getDefaults();
    }
  },
  methods: {
    ...mapActions(["setAppConfiguredInStore"]),
    nextStep() {
      if (this.isNextButtonDisabled) {
        return;
      }

      if (this.isLastStep) {
        this.configureModule();
      } else {
        this.step = this.steps[this.stepIndex + 1];
      }
    },
    previousStep() {
      if (!this.isFirstStep) {
        this.step = this.steps[this.stepIndex - 1];
      }
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
      this.hostname = defaults.hostname;
      this.mail_domain = defaults.mail_domain;

      // user domains

      this.userDomains = defaults.user_domains.map((d) => {
        return {
          name: d.name,
          schema: d.schema,
          location: d.location,
          selected: false,
        };
      });

      if (this.userDomains.length == 1) {
        this.userDomains[0].selected = true;
      }
      this.loading.getDefaults = false;

      this.$nextTick(() => {
        if (this.userDomains.length) {
          this.focusElement("hostname");
        }
      });
    },
    async configureModule() {
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
            hostname: this.hostname,
            mail_domain: this.mail_domain,
            user_domain: this.selectedUserDomain.name,
          },
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
        this.error.configureModule = this.getErrorMessage(err);
        this.loading.configureModule = false;
        return;
      }
    },
    configureModuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.configureModule = false;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "welcome." + validationError.error,
          "error." + validationError.error
        );

        if (param === "mail_domain") {
          this.step = "mailHostname";
        }

        if (!focusAlreadySet) {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    configureModuleCompleted() {
      this.loading.configureModule = false;

      // close first configuration wizard
      this.setAppConfiguredInStore(true);

      // go to domains page
      this.goToAppPage(this.instanceName, "domains");

      this.$nextTick(() => {
        this.$root.$emit("reloadDomains");

        // reload configuration
        this.$emit("configured");
      });
    },
    onChangeMailHostname() {
      const match = /[^.]+\.(.+)/.exec(this.hostname);

      if (match && match.length > 1) {
        this.mail_domain = match[1];
      }
    },
    deselectOtherDomains(domain) {
      for (let d of this.userDomains) {
        if (d.name !== domain.name) {
          d.selected = false;
        }
      }
    },
    goToDomainsAndUsers() {
      this.core.$router.push("/domains");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
