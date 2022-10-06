<!--
  Copyright (C) 2022 Nethesis S.r.l.
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
      <!-- //// skeleton -->
      <!-- general -->
      <cv-row>
        <cv-column>
          <cv-tile light>
            <h4 class="mg-bottom-md">
              {{ $t("filter.general") }}
            </h4>
            <!-- enable antispam -->
            <NsToggle
              value="antispamValue"
              :form-item="true"
              v-model="isAntispamEnabled"
              :disabled="loading.getFilterConfig || loading.saveFilterConfig"
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
              v-model="isAntivirusEnabled"
              :disabled="loading.getFilterConfig || loading.saveFilterConfig"
              class="toggle-without-label mg-bottom-lg"
              ref="isAntivirusEnabled"
            >
              <template slot="text-left">{{
                $t("filter.enable_antivirus")
              }}</template>
              <template slot="text-right">{{
                $t("filter.enable_antivirus")
              }}</template>
            </NsToggle>
            <NsButton
              kind="primary"
              :icon="Save20"
              @click="save"
              :disabled="loading.getFilterConfig"
              :loading="loading.saveFilterConfig"
              >{{ $t("common.save_settings") }}
            </NsButton>
          </cv-tile>
        </cv-column>
      </cv-row>
      <!-- bypass rules -->
      <cv-row>
        <cv-column>
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
            <div class="mg-bottom-lg">
              {{ $tc("filter.num_rules_configured_c", numBypassRules) }}
            </div>
            <NsButton
              kind="tertiary"
              :icon="ArrowRight20"
              @click="goToAppPage(instanceName, 'filterBypassRules')"
              >{{ $t("filter.go_to_bypass_rules") }}
            </NsButton>
          </cv-tile>
        </cv-column>
      </cv-row>
      <!-- antispam -->
      <cv-row v-if="isAntispamEnabled">
        <cv-column>
          <cv-tile light>
            <h4 class="mg-bottom-md">
              {{ $t("filter.antispam") }}
            </h4>
            <NsSlider
              v-model="antispam.spamFlagTh"
              :label="$t('filter.spam_flag_threshold')"
              min="1"
              max="25"
              step="0.01"
              stepMultiplier="10"
              minLabel=""
              maxLabel=""
              :showUnlimited="false"
              :invalidMessage="error.spamFlag"
              :disabled="loading.getFilterConfig || loading.saveFilterConfig"
              unitLabel=""
              class="mg-bottom-xlg"
            />
            <NsSlider
              v-model="antispam.denyMessageSpamTh"
              :label="$t('filter.deny_message_spam_threshold')"
              min="1"
              max="25"
              step="0.01"
              stepMultiplier="10"
              minLabel=""
              maxLabel=""
              :showUnlimited="false"
              :invalidMessage="error.denyMessageSpamTh"
              :disabled="loading.getFilterConfig || loading.saveFilterConfig"
              unitLabel=""
              class="mg-bottom-xlg"
            />
            <!-- advanced options -->
            <cv-accordion ref="accordion">
              <cv-accordion-item :open="toggleAccordion[0]">
                <template slot="title">{{ $t("common.advanced") }}</template>
                <template slot="content">
                  <!-- greylist threshold -->
                  <NsSlider
                    v-model="greylistTh.value"
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
                    :isUnlimited="greylistTh.disabled"
                    :invalidMessage="error.greylistTh"
                    :disabled="
                      loading.getFilterConfig || loading.saveFilterConfig
                    "
                    unitLabel=""
                    @unlimited="greylistTh.disabled = $event"
                    class="mg-bottom-xlg"
                  />
                  <!-- add a prefix to spam messages subject (the same component is in Settings/Mailboxes) -->
                  <NsToggle
                    value="prefixSpamValue"
                    :form-item="true"
                    v-model="antispam.isAddPrefixToSpamSubject"
                    :disabled="
                      loading.getFilterConfig || loading.saveFilterConfig
                    "
                    :class="[
                      'toggle-without-label',
                      { 'mg-bottom-md': antispam.isAddPrefixToSpamSubject },
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
                    v-if="antispam.isAddPrefixToSpamSubject"
                    v-model.trim="antispam.spamSubjectPrefix"
                    :label="$t('filter.prefix')"
                    :invalid-message="error.spamSubjectPrefix"
                    :disabled="
                      loading.getFilterConfig || loading.saveFilterConfig
                    "
                    class="toggle-dependent"
                    ref="spamSubjectPrefix"
                  />
                </template>
              </cv-accordion-item>
            </cv-accordion>
            <NsButton
              kind="primary"
              :icon="Save20"
              @click="save"
              :disabled="loading.getFilterConfig"
              :loading="loading.saveFilterConfig"
              class="mg-top-xlg"
              >{{ $t("common.save_settings") }}
            </NsButton>
          </cv-tile>
        </cv-column>
      </cv-row>
      <!-- antivirus -->
      <cv-row v-if="isAntivirusEnabled">
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
            <NsInlineNotification
              v-if="
                antivirus.isClamavOfficialEnabled &&
                antivirus.systemMemory < 4000
              "
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
              v-model="antivirus.isClamavOfficialEnabled"
              :disabled="loading.getFilterConfig || loading.saveFilterConfig"
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
              class="signatures-switcher"
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
                >{{ $t("filter.signatures_high") }}</cv-content-switcher-button
              >
            </cv-content-switcher>
            <NsButton
              kind="primary"
              :icon="Save20"
              @click="save"
              :disabled="loading.getFilterConfig"
              :loading="loading.saveFilterConfig"
              class="mg-top-xlg"
              >{{ $t("common.save_settings") }}
            </NsButton>
          </cv-tile>
        </cv-column>
      </cv-row>
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
      isAntispamEnabled: true,
      isAntivirusEnabled: true,
      //// use antispam: {} object
      numBypassRules: 0, ////
      antispam: {
        spamFlagTh: "6", ////
        denyMessageSpamTh: "20", ////
        isAddPrefixToSpamSubject: false,
        spamSubjectPrefix: "***SPAM***",
      },
      antivirus: {
        isClamavOfficialEnabled: false,
        signaturesRating: "low",
        systemMemory: 0,
      },
      greylistTh: {
        disabled: true,
        value: "4",
      },
      status: null,
      loading: {
        getFilterConfig: false,
        saveFilterConfig: false,
        getStatus: false,
      },
      error: {
        getFilterConfig: "",
        saveFilterConfig: "",
        spamFlagTh: "",
        denyMessageSpamTh: "",
        greylistTh: "",
        spamSubjectPrefix: "",
        getStatus: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    csbSignaturesLowSelected() {
      return this.antivirus.signaturesRating === "low";
    },
    csbSignaturesMediumSelected() {
      return this.antivirus.signaturesRating === "medium";
    },
    csbSignaturesHighSelected() {
      return this.antivirus.signaturesRating === "high";
    },
  },
  watch: {
    "antispam.isAddPrefixToSpamSubject": function () {
      if (this.antispam.isAddPrefixToSpamSubject) {
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
    this.getStatus();
  },
  methods: {
    save() {
      console.log("save"); ////
    },
    goToRspamdWebapp() {
      console.log("goToRspamdWebapp"); ////
    },
    goToBypassRules() {
      console.log("goToBypassRules"); ////
    },
    onSignaturesRatingSelected(value) {
      this.signaturesRating = value;
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
</style>
