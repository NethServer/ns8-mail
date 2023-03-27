<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column :md="4" :xlg="10" class="page-title">
          <h2>{{ $t("filter.title") }}</h2>
        </cv-column>
        <cv-column :md="4" :xlg="6">
          <div class="page-toolbar">
            <NsButton
              kind="tertiary"
              size="field"
              :icon="Launch20"
              @click="goToRspamdWebapp()"
              class="page-toolbar-item"
              >{{ $t("filter.open_rspamd") }}
            </NsButton>
          </div>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <NsInlineNotification
            v-if="error.getFilterConfiguration"
            kind="error"
            :title="$t('action.get-filter-configuration')"
            :description="error.getFilterConfiguration"
            :showCloseButton="false"
          />
        </cv-column>
      </cv-row>
      <cv-row>
        <!-- general -->
        <cv-column :lg="8">
          <cv-tile light>
            <h4 class="mg-bottom-md">
              {{ $t("filter.general") }}
            </h4>
            <!-- skeleton -->
            <template v-if="loading.getFilterConfiguration">
              <cv-skeleton-text
                heading
                :paragraph="true"
                :line-count="4"
              ></cv-skeleton-text>
            </template>
            <template v-else>
              <!-- enable antispam -->
              <NsToggle
                value="antispamValue"
                :form-item="true"
                v-model="antispam.enabled"
                :disabled="
                  loading.getFilterConfiguration ||
                  loading.setFilterConfiguration
                "
                class="toggle-without-label mg-bottom-lg"
                ref="isAntispamEnabled"
              >
                <template slot="text-left">{{
                  $t("filter.enable_antispam")
                }}</template>
                <template slot="text-right">{{
                  $t("filter.enable_antispam")
                }}</template>
              </NsToggle>
              <!-- enable antivirus -->
              <NsToggle
                value="antivirusValue"
                :form-item="true"
                v-model="antivirus.enabled"
                :disabled="
                  loading.getFilterConfiguration ||
                  loading.setFilterConfiguration
                "
                class="toggle-without-label mg-bottom-xlg"
                ref="isAntivirusEnabled"
              >
                <template slot="text-left">{{
                  $t("filter.enable_antivirus")
                }}</template>
                <template slot="text-right">{{
                  $t("filter.enable_antivirus")
                }}</template>
              </NsToggle>
              <NsInlineNotification
                v-if="error.saveGeneralSection"
                kind="error"
                :title="$t('action.set-filter-configuration')"
                :description="error.saveGeneralSection"
                :showCloseButton="false"
              />
              <NsButton
                kind="primary"
                :icon="Save20"
                @click="saveGeneralSection"
                :disabled="
                  loading.getFilterConfiguration ||
                  loading.setFilterConfiguration
                "
                :loading="loading.saveGeneralSection"
                >{{ $t("common.save_settings") }}
              </NsButton>
            </template>
          </cv-tile>
        </cv-column>
        <!-- bypass rules -->
        <cv-column :lg="8">
          <cv-tile light>
            <h4 class="mg-bottom-md">
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
            </h4>
            <!-- skeleton -->
            <template v-if="loading.getFilterConfiguration">
              <cv-skeleton-text
                heading
                :paragraph="true"
                :line-count="4"
              ></cv-skeleton-text>
            </template>
            <template v-else>
              <div class="mg-bottom-lg">
                {{ $tc("filter.num_rules_configured_c", numBypassRules) }}
              </div>
              <NsButton
                kind="tertiary"
                :icon="ArrowRight20"
                @click="goToAppPage(instanceName, 'filterBypassRules')"
                >{{ $t("filter.go_to_bypass_rules") }}
              </NsButton>
            </template>
          </cv-tile>
        </cv-column>
      </cv-row>
      <!-- antispam -->
      <transition name="fade">
        <cv-row v-if="!loading.getFilterConfiguration && antispam.enabled">
          <cv-column>
            <cv-tile light>
              <h4 class="mg-bottom-md">
                {{ $t("filter.antispam") }}
              </h4>
              <NsSlider
                v-model="antispam.spam_flag_threshold"
                :label="$t('filter.spam_flag_threshold')"
                min="1"
                max="25"
                step="0.01"
                stepMultiplier="10"
                minLabel=""
                maxLabel=""
                :showUnlimited="false"
                :invalidMessage="error.spamFlag"
                :disabled="
                  loading.getFilterConfiguration ||
                  loading.setFilterConfiguration
                "
                unitLabel=""
                class="mg-bottom-xlg"
              />
              <NsSlider
                v-model="antispam.deny_message_threshold"
                :label="$t('filter.deny_message_spam_threshold')"
                min="1"
                max="25"
                step="0.01"
                stepMultiplier="10"
                minLabel=""
                maxLabel=""
                :showUnlimited="false"
                :invalidMessage="error.deny_message_threshold"
                :disabled="
                  loading.getFilterConfiguration ||
                  loading.setFilterConfiguration
                "
                unitLabel=""
                class="mg-bottom-xlg"
              />
              <!-- advanced options -->
              <cv-accordion ref="accordion" class="mg-bottom-xlg">
                <cv-accordion-item :open="toggleAccordion[0]">
                  <template slot="title">{{ $t("common.advanced") }}</template>
                  <template slot="content">
                    <!-- greylist threshold -->
                    <NsSlider
                      v-model="antispam.greylist.threshold"
                      :label="$t('filter.greylist_threshold')"
                      min="1"
                      max="25"
                      step="0.01"
                      stepMultiplier="10"
                      minLabel=""
                      maxLabel=""
                      showUnlimited
                      :unlimitedLabel="$t('common.disabled')"
                      :limitedLabel="$t('common.enabled')"
                      :isUnlimited="!antispam.greylist.enabled"
                      :invalidMessage="error.enabled"
                      :disabled="
                        loading.getFilterConfiguration ||
                        loading.setFilterConfiguration
                      "
                      unitLabel=""
                      @unlimited="antispam.greylist.enabled = !$event"
                      class="mg-bottom-xlg"
                    />
                    <!-- add a prefix to spam messages subject (the same component is in Settings/Mailboxes) -->
                    <NsToggle
                      value="prefixSpamValue"
                      :form-item="true"
                      v-model="antispam.prefix_email_subject.enabled"
                      :disabled="
                        loading.getFilterConfiguration ||
                        loading.setFilterConfiguration
                      "
                      :class="[
                        'toggle-without-label',
                        {
                          'mg-bottom-md': antispam.prefix_email_subject.enabled,
                        },
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
                      v-if="antispam.prefix_email_subject.enabled"
                      v-model.trim="antispam.prefix_email_subject.prefix"
                      :label="$t('filter.prefix')"
                      :invalid-message="error.prefix_email_subject"
                      :disabled="
                        loading.getFilterConfiguration ||
                        loading.setFilterConfiguration
                      "
                      class="toggle-dependent"
                      ref="prefix_email_subject"
                    />
                  </template>
                </cv-accordion-item>
              </cv-accordion>
              <NsInlineNotification
                v-if="error.saveAntispamSection"
                kind="error"
                :title="$t('action.set-filter-configuration')"
                :description="error.saveAntispamSection"
                :showCloseButton="false"
              />
              <NsButton
                kind="primary"
                :icon="Save20"
                @click="saveAntispamSection"
                :disabled="
                  loading.getFilterConfiguration ||
                  loading.setFilterConfiguration
                "
                :loading="loading.saveAntispamSection"
                >{{ $t("common.save_settings") }}
              </NsButton>
            </cv-tile>
          </cv-column>
        </cv-row>
      </transition>
      <!-- antivirus -->
      <transition name="fade">
        <cv-row v-if="!loading.getFilterConfiguration && antivirus.enabled">
          <cv-column>
            <cv-tile light>
              <h4 class="mg-bottom-md">
                {{ $t("filter.antivirus") }}
              </h4>
              <NsInlineNotification
                kind="info"
                title=""
                :description="$t('filter.antivirus_signatures_explanation')"
                :showCloseButton="false"
              />
              <!-- //// read system memory from api -->
              <NsInlineNotification
                v-if="antivirus.enabled && systemMemory < 4000"
                kind="warning"
                title=""
                :description="
                  $t('filter.signatures_memory_warning', {
                    installationNode: getInstallationNodeTitle(),
                  })
                "
                :showCloseButton="false"
              />
              <NsCheckbox
                :label="$t('filter.clamav_official_signatures')"
                v-model="antivirus.clamav_official_sigs"
                :disabled="
                  loading.getFilterConfiguration ||
                  loading.setFilterConfiguration
                "
                tooltipAlignment="start"
                tooltipDirection="right"
                value="checkAntivirusClamavOfficialEnabled"
                class="mg-bottom-lg"
              >
                <template slot="tooltip">
                  <div
                    v-html="$t('filter.clamav_official_signatures_tooltip')"
                  ></div>
                </template>
              </NsCheckbox>
              <label class="bx--label">
                {{ $t("filter.third_party_signatures_rating") }}
              </label>
              <cv-interactive-tooltip
                alignment="center"
                direction="right"
                class="tooltip info signatures-tooltip"
              >
                <template slot="trigger"></template>
                <template slot="content">
                  <div
                    v-html="$t('filter.third_party_signatures_rating_tooltip')"
                  ></div>
                </template>
              </cv-interactive-tooltip>
              <cv-content-switcher
                @selected="onSignaturesRatingSelected"
                class="signatures-switcher mg-bottom-xlg"
              >
                <cv-content-switcher-button
                  owner-id="low"
                  :selected="csbSignaturesLowSelected"
                  >{{ $t("filter.signatures_low") }}</cv-content-switcher-button
                >
                <cv-content-switcher-button
                  owner-id="medium"
                  :selected="csbSignaturesMediumSelected"
                  >{{
                    $t("filter.signatures_medium")
                  }}</cv-content-switcher-button
                >
                <cv-content-switcher-button
                  owner-id="high"
                  :selected="csbSignaturesHighSelected"
                  >{{
                    $t("filter.signatures_high")
                  }}</cv-content-switcher-button
                >
              </cv-content-switcher>
              <NsInlineNotification
                v-if="error.saveAntivirusSection"
                kind="error"
                :title="$t('action.set-filter-configuration')"
                :description="error.saveAntivirusSection"
                :showCloseButton="false"
              />
              <NsButton
                kind="primary"
                :icon="Save20"
                @click="saveAntivirusSection"
                :disabled="
                  loading.getFilterConfiguration ||
                  loading.setFilterConfiguration
                "
                :loading="loading.saveAntivirusSection"
                >{{ $t("common.save_settings") }}
              </NsButton>
            </cv-tile>
          </cv-column>
        </cv-row>
      </transition>
    </cv-grid>
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
import _merge from "lodash/merge";

//// review

export default {
  name: "MailFilter",
  components: { Information16 },
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("filter.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "filter",
      },
      urlCheckInterval: null,
      numBypassRules: 0,
      antispam: {
        enabled: false,
        spam_flag_threshold: "1",
        deny_message_threshold: "1",
        greylist: {
          enabled: false,
          threshold: "1",
        },
        prefix_email_subject: {
          enabled: false,
          prefix: "***SPAM***", //// test
        },
      },
      antivirus: {
        enabled: false,
        clamav_official_sigs: false,
        third_party_sigs_rating: "medium",
      },
      systemMemory: 0, //// remove
      status: null,
      loading: {
        getFilterConfiguration: false,
        setFilterConfiguration: false,
        getStatus: false,
        saveGeneralSection: false,
        saveAntispamSection: false,
        saveAntivirusSection: false,
      },
      error: {
        getFilterConfiguration: "",
        setFilterConfiguration: "",
        getStatus: "",
        saveGeneralSection: "",
        saveAntispamSection: "",
        saveAntivirusSection: "",
        spam_flag_threshold: "",
        deny_message_threshold: "",
        greylist: "",
        prefix_email_subject: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    csbSignaturesLowSelected() {
      return this.antivirus.third_party_sigs_rating === "low";
    },
    csbSignaturesMediumSelected() {
      return this.antivirus.third_party_sigs_rating === "medium";
    },
    csbSignaturesHighSelected() {
      return this.antivirus.third_party_sigs_rating === "high";
    },
  },
  watch: {
    "antispam.prefix_email_subject.enabled": function () {
      if (this.antispam.prefix_email_subject.enabled) {
        this.$nextTick(() => {
          this.focusElement("prefix_email_subject");
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
    this.getStatus();
    this.getFilterConfiguration();
  },
  methods: {
    saveGeneralSection() {
      const actionPayload = {
        antispam: {
          enabled: this.antispam.enabled,
        },
        antivirus: {
          enabled: this.antivirus.enabled,
        },
      };

      console.log("saveGeneralSection", actionPayload); ////

      this.loading.saveGeneralSection = true;
      this.setFilterConfiguration(actionPayload, "general");
    },
    goToRspamdWebapp() {
      console.log("goToRspamdWebapp"); ////
    },
    onSignaturesRatingSelected(value) {
      this.antivirus.third_party_sigs_rating = value;
    },
    getInstallationNodeTitle() {
      if (this.status && this.status.node) {
        if (this.status.node_ui_name) {
          return this.status.node_ui_name;
        } else {
          return this.$t("status.node") + " " + this.status.node;
        }
      } else {
        return "-";
      }
    },
    async getStatus() {
      this.loading.getStatus = true;
      this.error.getStatus = "";
      const taskAction = "get-status";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getStatusAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getStatusCompleted
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
        this.error.getStatus = this.getErrorMessage(err);
        this.loading.getStatus = false;
        return;
      }
    },
    getStatusAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getStatus = this.$t("error.generic_error");
      this.loading.getStatus = false;
    },
    getStatusCompleted(taskContext, taskResult) {
      this.status = taskResult.output;
      this.loading.getStatus = false;
    },
    async getFilterConfiguration() {
      this.loading.getFilterConfiguration = true;
      this.error.getFilterConfiguration = "";
      const taskAction = "get-filter-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getFilterConfigurationAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getFilterConfigurationCompleted
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
        this.error.getFilterConfiguration = this.getErrorMessage(err);
        this.loading.getFilterConfiguration = false;
        return;
      }
    },
    getFilterConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getFilterConfiguration = this.$t("error.generic_error");
      this.loading.getFilterConfiguration = false;
    },
    getFilterConfigurationCompleted(taskContext, taskResult) {
      console.log("!!! getFilterConfigurationCompleted", taskResult.output); ////

      this.numBypassRules = taskResult.output.bypass_rules;

      // convert values for NsSliders to strings

      if (taskResult.output.antispam.spam_flag_threshold) {
        taskResult.output.antispam.spam_flag_threshold =
          taskResult.output.antispam.spam_flag_threshold.toString();
      }

      if (taskResult.output.antispam.deny_message_threshold) {
        taskResult.output.antispam.deny_message_threshold =
          taskResult.output.antispam.deny_message_threshold.toString();
      }

      if (
        taskResult.output.antispam.greylist &&
        taskResult.output.antispam.greylist.threshold
      ) {
        taskResult.output.antispam.greylist.threshold =
          taskResult.output.antispam.greylist.threshold.toString();
      }

      _merge(this.antispam, taskResult.output.antispam);
      _merge(this.antivirus, taskResult.output.antivirus);
      this.loading.getFilterConfiguration = false;

      console.log("!! this.antispam", this.antispam); ////
      console.log("!! this.antivirus", this.antivirus); ////
    },
    async setFilterConfiguration(actionPayload, section) {
      this.loading.setFilterConfiguration = true;
      this.clearErrors();
      const taskAction = "set-filter-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setFilterConfigurationAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setFilterConfigurationCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: actionPayload,
          extra: {
            title: this.$t("filter.save_filter_settings"),
            description: this.$t("common.processing"),
            uiSection: section,
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.setFilterConfiguration = this.getErrorMessage(err);
        this.loading.setFilterConfiguration = false;

        switch (section) {
          case "general":
            this.error.saveGeneralSection = this.getErrorMessage(err);
            this.loading.saveGeneralSection = false;
            break;
          case "antispam":
            this.error.saveAntispamSection = this.getErrorMessage(err);
            this.loading.saveAntispamSection = false;
            break;
          case "antivirus":
            this.error.saveAntivirusSection = this.getErrorMessage(err);
            this.loading.saveAntivirusSection = false;
            break;
        }
        return;
      }
    },
    setFilterConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.setFilterConfiguration = false;
      this.error.setFilterConfiguration = this.$t("error.generic_error");

      switch (taskContext.extra.uiSection) {
        case "general":
          this.error.saveGeneralSection = this.$t("error.generic_error");
          this.loading.saveGeneralSection = false;
          break;
        case "antispam":
          this.error.saveAntispamSection = this.$t("error.generic_error");
          this.loading.saveAntispamSection = false;
          break;
        case "antivirus":
          this.error.saveAntivirusSection = this.$t("error.generic_error");
          this.loading.saveAntivirusSection = false;
          break;
      }
    },
    setFilterConfigurationCompleted() {
      console.log("! setFilterConfigurationCompleted"); ////

      this.loading.setFilterConfiguration = false;
      this.loading.saveGeneralSection = false;
      this.loading.saveAntispamSection = false;
      this.loading.saveAntivirusSection = false;

      // reload configuration
      this.getFilterConfiguration();
    },
    saveAntispamSection() {
      // validate spam prefix
      this.error.prefix_email_subject = "";

      if (
        this.antispam.prefix_email_subject.enabled &&
        !this.antispam.prefix_email_subject.prefix
      ) {
        this.focusElement("prefix_email_subject");
        this.error.prefix_email_subject = this.$t("common.required");
        return;
      }

      const actionPayload = {
        antispam: {
          enabled: this.antispam.enabled,
          spam_flag_threshold: Number(this.antispam.spam_flag_threshold),
          deny_message_threshold: Number(this.antispam.deny_message_threshold),
          greylist: {
            enabled: this.antispam.greylist.enabled,
            threshold: Number(this.antispam.greylist.threshold),
          },
          prefix_email_subject: {
            enabled: this.antispam.prefix_email_subject.enabled,
          },
        },
      };

      if (this.antispam.prefix_email_subject.enabled) {
        actionPayload.antispam.prefix_email_subject.prefix =
          this.antispam.prefix_email_subject.prefix;
      }

      console.log("saveAntispamSection", actionPayload); ////

      this.loading.saveAntispamSection = true;
      this.setFilterConfiguration(actionPayload, "antispam");
    },
    saveAntivirusSection() {
      const actionPayload = {
        antivirus: {
          enabled: this.antivirus.enabled,
          clamav_official_sigs: this.antivirus.clamav_official_sigs,
          third_party_sigs_rating: this.antivirus.third_party_sigs_rating,
        },
      };

      console.log("saveAntivirusSection", actionPayload); ////

      this.loading.saveAntivirusSection = true;
      this.setFilterConfiguration(actionPayload, "antivirus");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.signatures-tooltip {
  position: relative;
  top: 3px;
  margin-left: 0.3rem;
}

.signatures-switcher {
  max-width: 25rem;
}

//// move to core

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>
