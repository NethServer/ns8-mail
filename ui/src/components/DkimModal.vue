<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primary-button-disabled="loading.setDkimConfig"
    :isLoading="loading.setDkimConfig"
    @modal-hidden="onModalHidden"
    @primary-click="setDkimConfig"
  >
    <template slot="title">
      <span>{{ $t("domains.configure_dkim") }}</span>
      <cv-interactive-tooltip
        alignment="start"
        direction="right"
        class="tooltip info mg-left-sm"
      >
        <template slot="trigger"></template>
        <template slot="content">
          <div v-html="$t('domains.dkim_tooltip')"></div>
        </template>
      </cv-interactive-tooltip>
    </template>
    <template slot="content">
      <cv-form @submit.prevent="setDkimConfig">
        <NsToggle
          value="dkimValue"
          :form-item="true"
          v-model="isDkimEnabled"
          :disabled="loading.getDkimConfig || loading.setDkimConfig"
          hideLabel
          class="mg-bottom-lg"
        >
          <template slot="text-left">
            <span
              v-html="
                $t('domains.enable_dkim_on_domain_domain', {
                  domain: domain.domain,
                })
              "
            ></span>
          </template>
          <template slot="text-right"
            ><span
              v-html="
                $t('domains.enable_dkim_on_domain_domain', {
                  domain: domain.domain,
                })
              "
            >
            </span>
          </template>
        </NsToggle>
        <template v-if="isDkimEnabled">
          <NsInlineNotification
            kind="warning"
            title=""
            :description="
              $t('domains.dkim_txt_record_description', {
                domain: domain.domain,
              })
            "
            :showCloseButton="false"
          />
          <cv-accordion ref="accordion">
            <cv-accordion-item :open="toggleAccordion[0]">
              <template slot="title"
                ><span
                  v-html="$t('domains.dkim_txt_record_key_procedure')"
                ></span
              ></template>
              <template slot="content">
                <!-- //// remove mock -->
                <NsCodeSnippet
                  light
                  copyTipPosition="left"
                  copyTipAlignment="center"
                  :copyTooltip="core.$t('common.copy_to_clipboard')"
                  :copy-feedback="core.$t('common.copied_to_clipboard')"
                  :feedback-aria-label="core.$t('common.copied_to_clipboard')"
                  :wrap-text="true"
                  :moreText="core.$t('common.show_more')"
                  :lessText="core.$t('common.show_less')"
                  expanded
                  hideExpandButton
                  class="mg-top-sm"
                  >v=DKIM1; k=rsa;
                  p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtWOpvYp1N+tmUhoqv45FdD85keVwGfYwltP1i1wV+3GtdbIC/NuDVVhDphoedf0Yitpsf3b+CQWS7PQ15xUY4KCN5xBZmVJ3UhJvoA0YTp2OvM8QPaYJGuWwrhyWS0hXN3k/lez+CdycIwllJmhQinpvgDbcY3IGnCCIgHNqyjJDxcltWJvyT9GNzVfTByfBMtPw5RXI3GN3tx7avE7yb4mQ6mUBtj8Zbg2tCzQZT6L7MgpMhVzR+qAzVKQwqjP9aChFOkGNj05lloc6yV4X04boBjVRFA14kyiAvpMaKR1SeXN5gOwKXOFeOYO7lPdJxMWiQjIG+y8xjnn+lUN7SQIDAQAB
                  ////</NsCodeSnippet
                >
              </template>
            </cv-accordion-item>
          </cv-accordion>
          <cv-accordion ref="accordion">
            <cv-accordion-item :open="toggleAccordion[0]">
              <template slot="title">{{
                $t("domains.dkim_txt_record_raw_procedure")
              }}</template>
              <template slot="content">
                <!-- //// remove mock -->
                <NsCodeSnippet
                  light
                  copyTipPosition="left"
                  copyTipAlignment="center"
                  :copyTooltip="core.$t('common.copy_to_clipboard')"
                  :copy-feedback="core.$t('common.copied_to_clipboard')"
                  :feedback-aria-label="core.$t('common.copied_to_clipboard')"
                  :wrap-text="true"
                  :moreText="core.$t('common.show_more')"
                  :lessText="core.$t('common.show_less')"
                  expanded
                  hideExpandButton
                  class="mg-top-sm"
                  >default._domainkey IN TXT ( "v=DKIM1; k=rsa; "
                  "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtWOpvYp1N+tmUhoqv45FdD85keVwGfYwltP1i1wV+3GtdbIC/NuDVVhDphoedf0Yitpsf3b+CQWS7PQ15xUY4KCN5xBZmVJ3UhJvoA0YTp2OvM8QPaYJGuWwrhyWS0hXN3k/lez+CdycIwllJmhQinpvgDbcY3IGnCCIgHNqyjJDxcltWJvyT9GNzVfTByfBMtPw5RXI3GN3tx"
                  "7avE7yb4mQ6mUBtj8Zbg2tCzQZT6L7MgpMhVzR+qAzVKQwqjP9aChFOkGNj05lloc6yV4X04boBjVRFA14kyiAvpMaKR1SeXN5gOwKXOFeOYO7lPdJxMWiQjIG+y8xjnn+lUN7SQIDAQAB"
                  ) ; ----- DKIM key default for ent.andre.org
                  ////</NsCodeSnippet
                >
              </template>
            </cv-accordion-item>
          </cv-accordion>
        </template>
        <!-- need to wrap error notification inside a div: custom elements like NsInlineNotification don't have scrollIntoView() function -->
        <div ref="setDkimConfigError">
          <!-- //// check action.create-bypass-rule -->
          <NsInlineNotification
            v-if="error.setDkimConfig"
            kind="error"
            :title="$t('action.set-dkim-config')"
            :description="error.setDkimConfig"
            :showCloseButton="false"
          />
        </div>
      </cv-form>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{ $t("common.save_settings") }}</template>
  </NsModal>
</template>

<script>
import to from "await-to-js";
import { UtilService, TaskService, IconService } from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";

export default {
  name: "DkimModal",
  mixins: [UtilService, TaskService, IconService],
  props: {
    isShown: Boolean,
    domain: { type: [Object, null] },
  },
  data() {
    return {
      isDkimEnabled: false,
      loading: {
        setDkimConfig: false,
        getDkimConfig: false,
      },
      error: {
        setDkimConfig: "",
        getDkimConfig: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
  },
  watch: {
    isShown: function () {
      if (this.isShown) {
        this.clearErrors();
      }
    },
    "error.setDkimConfig": function () {
      if (this.error.setDkimConfig) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.setDkimConfigError;
          this.scrollToElement(el);
        });
      }
    },
  },
  methods: {
    onModalHidden() {
      this.clearErrors();
      this.$emit("hide");
    },
    async setDkimConfig() {
      this.loading.setDkimConfig = true;
      this.error.setDkimConfig = "";
      const taskAction = "set-dkim-config";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setDkimConfigAborted
      );
      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setDkimConfigCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            dkim: this.isDkimEnabled,
          },
          extra: {
            title: this.$t("domains.configure_dkim_for_domain", {
              domain: this.domain.domain,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.setDkimConfig = this.getErrorMessage(err);
        this.loading.setDkimConfig = false;
        return;
      }
    },
    setDkimConfigAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.setDkimConfig = false;

      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    setDkimConfigCompleted() {
      this.loading.setDkimConfig = false;
      this.isDkimEnabled = false;
      this.$emit("hide");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
