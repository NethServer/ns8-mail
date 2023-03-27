<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primary-button-disabled="loading.setDomainDkim"
    :isLoading="loading.setDomainDkim"
    @modal-hidden="onModalHidden"
    @primary-click="setDomainDkim"
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
      <!-- skeleton -->
      <template v-if="loading.getDomainDkim">
        <cv-skeleton-text
          width="90%"
          :paragraph="true"
          :line-count="3"
        ></cv-skeleton-text>
      </template>
      <template v-else>
        <cv-form @submit.prevent="setDomainDkim">
          <NsToggle
            value="dkimValue"
            :form-item="true"
            v-model="isDkimEnabled"
            :disabled="loading.getDomainDkim || loading.setDomainDkim"
            hideLabel
            class="mg-bottom-lg"
          >
            <template slot="text-left">
              <span
                v-html="
                  $t('domains.dkim_on_domain_domain', {
                    domain: domain.domain,
                  })
                "
              ></span>
            </template>
            <template slot="text-right"
              ><span
                v-html="
                  $t('domains.dkim_on_domain_domain', {
                    domain: domain.domain,
                  })
                "
              >
              </span>
            </template>
          </NsToggle>
          <transition name="fade">
            <template v-if="isDkimEnabled">
              <div>
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
                        :feedback-aria-label="
                          core.$t('common.copied_to_clipboard')
                        "
                        :wrap-text="true"
                        :moreText="core.$t('common.show_more')"
                        :lessText="core.$t('common.show_less')"
                        expanded
                        hideExpandButton
                        class="mg-top-sm"
                        >{{ dkimRecordData }}</NsCodeSnippet
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
                      <NsCodeSnippet
                        light
                        copyTipPosition="left"
                        copyTipAlignment="center"
                        :copyTooltip="core.$t('common.copy_to_clipboard')"
                        :copy-feedback="core.$t('common.copied_to_clipboard')"
                        :feedback-aria-label="
                          core.$t('common.copied_to_clipboard')
                        "
                        :wrap-text="true"
                        :moreText="core.$t('common.show_more')"
                        :lessText="core.$t('common.show_less')"
                        expanded
                        hideExpandButton
                        class="mg-top-sm"
                        >{{ dkimFullRawRecord }}</NsCodeSnippet
                      >
                    </template>
                  </cv-accordion-item>
                </cv-accordion>
              </div>
            </template>
          </transition>
          <!-- need to wrap error notification inside a div: custom elements like NsInlineNotification don't have scrollIntoView() function -->
          <div ref="getDomainDkimError">
            <NsInlineNotification
              v-if="error.getDomainDkim"
              kind="error"
              :title="$t('action.get-domain-dkim')"
              :description="error.getDomainDkim"
              :showCloseButton="false"
            />
          </div>
          <!-- need to wrap error notification inside a div: custom elements like NsInlineNotification don't have scrollIntoView() function -->
          <div ref="setDomainDkimError">
            <NsInlineNotification
              v-if="error.setDomainDkim"
              kind="error"
              :title="$t('action.set-domain-dkim')"
              :description="error.setDomainDkim"
              :showCloseButton="false"
            />
          </div>
        </cv-form>
      </template>
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
      dkimFullRawRecord: "",
      dkimRecordData: "",
      loading: {
        setDomainDkim: false,
        getDomainDkim: false,
      },
      error: {
        setDomainDkim: "",
        getDomainDkim: "",
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
        this.getDomainDkim();
      }
    },
    "error.getDomainDkim": function () {
      if (this.error.getDomainDkim) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.getDomainDkimError;
          this.scrollToElement(el);
        });
      }
    },
    "error.setDomainDkim": function () {
      if (this.error.setDomainDkim) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.setDomainDkimError;
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
    async getDomainDkim() {
      this.loading.getDomainDkim = true;
      this.error.getDomainDkim = "";
      const taskAction = "get-domain-dkim";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getDomainDkimAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getDomainDkimCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            domain: this.domain.domain,
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
        this.error.getDomainDkim = this.getErrorMessage(err);
        this.loading.getDomainDkim = false;
        return;
      }
    },
    getDomainDkimAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getDomainDkim = this.$t("error.generic_error");
      this.loading.getDomainDkim = false;
    },
    getDomainDkimCompleted(taskContext, taskResult) {
      console.log("getDomainDkimCompleted", taskResult.output); ////

      this.isDkimEnabled = taskResult.output.enabled;
      this.dkimFullRawRecord = taskResult.output.dkimFullRawRecord;
      this.dkimRecordData = taskResult.output.dkimRecordData;
      this.loading.getDomainDkim = false;
    },
    async setDomainDkim() {
      this.loading.setDomainDkim = true;
      this.error.setDomainDkim = "";
      const taskAction = "set-domain-dkim";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setDomainDkimAborted
      );
      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setDomainDkimCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            domain: this.domain.domain,
            enabled: this.isDkimEnabled,
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
        this.error.setDomainDkim = this.getErrorMessage(err);
        this.loading.setDomainDkim = false;
        return;
      }
    },
    setDomainDkimAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.setDomainDkim = false;
    },
    setDomainDkimCompleted() {
      this.loading.setDomainDkim = false;
      this.isDkimEnabled = false;
      this.$emit("hide");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

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
