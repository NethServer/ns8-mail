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
              :icon="Wikis20"
              @click="goToRspamdWebapp()"
              class="page-toolbar-item"
              >{{ $t("filter.rspamd_webapp") }}
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
            <!-- enable filter -->
            <NsToggle
              value="filterValue"
              :form-item="true"
              v-model="isFilterEnabled"
              :disabled="loading.getFilterConfig || loading.saveFilterConfig"
              class="toggle-without-label mg-bottom-lg"
              ref="isFilterEnabled"
            >
              <template slot="text-left">{{
                $t("filter.enable_filter")
              }}</template>
              <template slot="text-right">{{
                $t("filter.enable_filter")
              }}</template>
            </NsToggle>
            <!-- enable antispam -->
            <NsToggle
              v-if="isFilterEnabled"
              value="antispamValue"
              :form-item="true"
              v-model="isAntispamEnabled"
              :disabled="loading.getFilterConfig || loading.saveFilterConfig"
              class="toggle-without-label mg-bottom-lg toggle-dependent"
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
              v-if="isFilterEnabled"
              value="antivirusValue"
              :form-item="true"
              v-model="isAntivirusEnabled"
              :disabled="loading.getFilterConfig || loading.saveFilterConfig"
              class="toggle-without-label mg-bottom-lg toggle-dependent"
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
      <cv-row v-if="isFilterEnabled">
        <cv-column>
          <cv-tile light>
            <h4 class="mg-bottom-md">
              {{ $t("filter_bypass_rules.title") }}
            </h4>
            <div class="mg-bottom-lg">
              {{ $tc("filter.num_rules_configured_c", numBypassRules) }}
            </div>
            <NsButton
              kind="tertiary"
              :icon="ArrowRight20"
              @click="goToAppPage(instanceName, 'filterBypassRules')"
              >{{ $t("filter.bypass_rules") }}
            </NsButton>
          </cv-tile>
        </cv-column>
      </cv-row>
      <!-- antispam -->
      <cv-row v-if="isFilterEnabled && isAntispamEnabled">
        <cv-column>
          <cv-tile light>
            <h4 class="mg-bottom-md">
              {{ $t("filter.antispam") }}
            </h4>
            <NsSlider
              v-model="spamFlagTh"
              :label="$t('filter.spam_flag_threshold')"
              min="1"
              max="25"
              step="1"
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
              v-model="denyMessageSpamTh"
              :label="$t('filter.deny_message_spam_threshold')"
              min="1"
              max="25"
              step="1"
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
                    step="1"
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
                  <!-- add a prefix to spam messages subject -->
                  <NsToggle
                    value="prefixSpamValue"
                    :form-item="true"
                    v-model="isAddPrefixToSpamSubject"
                    :disabled="
                      loading.getFilterConfig || loading.saveFilterConfig
                    "
                    class="toggle-without-label mg-bottom-lg"
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
                    v-if="isAddPrefixToSpamSubject"
                    v-model.trim="spamSubjectPrefix"
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
    </cv-grid>
  </div>
</template>

<script>
// import to from "await-to-js"; ////
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";
// import _cloneDeep from "lodash/cloneDeep"; ////
// import CreateOrEditAddressModal from "@/components/CreateOrEditAddressModal"; ////
// import Information16 from "@carbon/icons-vue/es/information/16"; ////

//// review

export default {
  name: "MailFilter",
  components: {},
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
      isFilterEnabled: true,
      isAntispamEnabled: true,
      isAntivirusEnabled: true,
      numBypassRules: 0, ////
      spamFlagTh: "6", ////
      denyMessageSpamTh: "20", ////
      isAddPrefixToSpamSubject: false,
      spamSubjectPrefix: "***SPAM***",
      greylistTh: {
        disabled: true,
        value: "4",
      },
      loading: {
        getFilterConfig: false,
        saveFilterConfig: false,
      },
      error: {
        getFilterConfig: "",
        saveFilterConfig: "",
        spamFlagTh: "",
        denyMessageSpamTh: "",
        greylistTh: "",
        spamSubjectPrefix: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
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
  created() {},
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
    // async listAddresses() { ////
    //   this.addresses = [];
    //   const taskAction = "list-addresses";
    //   const eventId = this.getUuid();
    //   this.loading.listAddresses = true;
    //   // register to task events
    //   this.core.$root.$once(
    //     `${taskAction}-aborted-${eventId}`,
    //     this.listAddressesAborted
    //   );
    //   this.core.$root.$once(
    //     `${taskAction}-completed-${eventId}`,
    //     this.listAddressesCompleted
    //   );
    //   const res = await to(
    //     this.createModuleTaskForApp(this.instanceName, {
    //       action: taskAction,
    //       extra: {
    //         title: this.$t("action." + taskAction),
    //         isNotificationHidden: true,
    //         eventId,
    //       },
    //     })
    //   );
    //   const err = res[0];
    //   if (err) {
    //     console.error(`error creating task ${taskAction}`, err);
    //     const errMessage = this.getErrorMessage(err);
    //     this.error.listAddresses = errMessage;
    //     this.loading.listAddresses = false;
    //   }
    // },
    // listAddressesAborted(taskResult, taskContext) {
    //   console.error(`${taskContext.action} aborted`, taskResult);
    //   this.error.listAddresses = this.$t("error.generic_error");
    //   this.loading.listAddresses = false;
    // },
    // listAddressesCompleted(taskContext, taskResult) {
    //   this.addUserDomains = taskResult.output.adduser_domains;
    //   this.addGroupDomains = taskResult.output.addgroup_domains;
    //   const addresses = taskResult.output.filter.map((address) => {
    //     const domain = address.domain ? address.domain : "";
    //     const visibility = address.internal
    //       ? this.$t("filter.internal")
    //       : this.$t("filter.public");
    //     return {
    //       domain: address.domain,
    //       address: `${address.local}@${domain}`,
    //       local: address.local,
    //       destinations: address.destinations,
    //       internal: !!address.internal,
    //       visibility: visibility,
    //       atype: address.atype,
    //       type: this.$t(`filter.type_${address.atype}`),
    //       delete_forbidden: address.delete_forbidden,
    //       description: address.description,
    //     };
    //   });
    //   this.addresses = filter.sort(this.sortByProperty("address"));
    //   this.loading.listAddresses = false;
    // },
    // async removeAddress(address) { ////
    //   this.loading.removeAddress = true;
    //   this.error.removeAddress = "";
    //   const taskAction = "remove-address";
    //   const eventId = this.getUuid();
    //   // register to task error
    //   this.core.$root.$once(
    //     `${taskAction}-aborted-${eventId}`,
    //     this.removeAddressAborted
    //   );
    //   // register to task completion
    //   this.core.$root.$once(
    //     `${taskAction}-completed-${eventId}`,
    //     this.removeAddressCompleted
    //   );
    //   const res = await to(
    //     this.createModuleTaskForApp(this.instanceName, {
    //       action: taskAction,
    //       data: {
    //         local: address.local,
    //         atype: address.atype,
    //         domain: address.domain,
    //       },
    //       extra: {
    //         title: this.$t("filter.delete_address_address", {
    //           address: address.address,
    //         }),
    //         description: this.core.$t("common.processing"),
    //         eventId,
    //       },
    //     })
    //   );
    //   const err = res[0];
    //   if (err) {
    //     console.error(`error creating task ${taskAction}`, err);
    //     this.error.removeAddress = this.getErrorMessage(err);
    //     this.loading.removeAddress = false;
    //     return;
    //   }
    // },
    // removeAddressAborted(taskResult, taskContext) {
    //   console.error(`${taskContext.action} aborted`, taskResult);
    //   this.loading.removeAddress = false;
    // },
    // removeAddressCompleted() {
    //   this.loading.removeAddress = false;
    //   // reload addresses
    //   this.listAddresses();
    // },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
