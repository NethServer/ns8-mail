<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primary-button-disabled="loading.addBypassRule"
    :isLoading="loading.addBypassRule"
    @modal-hidden="onModalHidden"
    @primary-click="addBypassRule"
  >
    <template slot="title">{{
      $t("filter_bypass_rules.create_bypass_rule")
    }}</template>
    <template slot="content">
      <cv-form @submit.prevent="addBypassRule">
        <cv-content-switcher
          @selected="onDirectionSelected"
          class="direction-switcher mg-bottom-lg"
        >
          <cv-content-switcher-button
            owner-id="from"
            :selected="csbFromSelected"
            >{{
              $t("filter_bypass_rules.allow_from")
            }}</cv-content-switcher-button
          >
          <cv-content-switcher-button owner-id="to" :selected="csbToSelected">{{
            $t("filter_bypass_rules.allow_to")
          }}</cv-content-switcher-button>
        </cv-content-switcher>
        <cv-content-switcher @selected="onTypeSelected" class="mg-bottom-lg">
          <cv-content-switcher-button
            owner-id="email"
            :selected="csbEmailSelected"
            >{{
              $t("filter_bypass_rules.type_email")
            }}</cv-content-switcher-button
          >
          <cv-content-switcher-button
            owner-id="domain"
            :selected="csbDomainSelected"
            >{{
              $t("filter_bypass_rules.type_domain")
            }}</cv-content-switcher-button
          >
          <cv-content-switcher-button
            v-if="direction === 'from'"
            owner-id="ip"
            :selected="csbIpSelected"
            >{{ $t("filter_bypass_rules.type_ip") }}</cv-content-switcher-button
          >
          <cv-content-switcher-button
            v-if="direction === 'from'"
            owner-id="cidr"
            :selected="csbcidrSelected"
            >{{
              $t("filter_bypass_rules.type_cidr")
            }}</cv-content-switcher-button
          >
        </cv-content-switcher>
        <NsTextInput
          v-model.trim="value"
          :label="valueLabel"
          :placeholder="valuePlaceholder"
          :invalid-message="error.value"
          :disabled="loading.addBypassRule"
          ref="value"
        />
        <!-- need to wrap error notification inside a div: custom elements like NsInlineNotification don't have scrollIntoView() function -->
        <div ref="addBypassRuleError">
          <NsInlineNotification
            v-if="error.addBypassRule"
            kind="error"
            :title="$t('action.add-bypass-rule')"
            :description="error.addBypassRule"
            :showCloseButton="false"
          />
        </div>
      </cv-form>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{
      $t("filter_bypass_rules.create_bypass_rule")
    }}</template>
  </NsModal>
</template>

<script>
import to from "await-to-js";
import { UtilService, TaskService, IconService } from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";

export default {
  name: "CreateBypassRuleModal",
  mixins: [UtilService, TaskService, IconService],
  props: {
    isShown: Boolean,
  },
  data() {
    return {
      direction: "from",
      type: "email",
      value: "",
      loading: {
        addBypassRule: false,
      },
      error: {
        addBypassRule: "",
        value: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
    csbFromSelected() {
      return this.direction === "from";
    },
    csbToSelected() {
      return this.direction === "to";
    },
    csbEmailSelected() {
      return this.type === "email";
    },
    csbDomainSelected() {
      return this.type === "domain";
    },
    csbIpSelected() {
      return this.type === "ip";
    },
    csbcidrSelected() {
      return this.type === "cidr";
    },
    valueLabel() {
      return this.$t(`filter_bypass_rules.type_${this.type}`);
    },
    valuePlaceholder() {
      switch (this.type) {
        case "email":
          return this.$t("filter_bypass_rules.placeholder_bypass_rule", {
            value: "john.doe@example.org",
          });
        case "domain":
          return this.$t("filter_bypass_rules.placeholder_bypass_rule", {
            value: "example.org",
          });
        case "ip":
          return this.$t("filter_bypass_rules.placeholder_bypass_rule", {
            value: "192.168.5.123",
          });
        case "cidr":
          return this.$t("filter_bypass_rules.placeholder_bypass_rule", {
            value: "192.168.5.0/24",
          });
        default:
          return "";
      }
    },
  },
  watch: {
    isShown: function () {
      if (this.isShown) {
        this.clearErrors();
      }
    },
    "error.addBypassRule": function () {
      if (this.error.addBypassRule) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.addBypassRuleError;
          this.scrollToElement(el);
        });
      }
    },
    direction: function () {
      if (this.direction === "to") {
        if (this.type === "ip" || this.type === "cidr") {
          this.type === "email";
        }
      }
    },
  },
  methods: {
    onModalHidden() {
      this.clearErrors();
      this.$emit("hide");
    },
    onDirectionSelected(value) {
      this.direction = value;
    },
    onTypeSelected(value) {
      this.type = value;
    },
    validateAddBypassRule() {
      this.clearErrors();
      let isValidationOk = true;

      // value

      if (!this.value) {
        this.error.value = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("value");
          isValidationOk = false;
        }
      } else if (
        (this.type === "email" && !this.value.includes("@")) ||
        (this.type === "ip" && !this.ipAddressPattern.test(this.value)) ||
        (this.type === "cidr" && !this.cidrPattern.test(this.value))
      ) {
        this.error.value = this.$t("error.invalid_pattern");

        if (isValidationOk) {
          this.focusElement("value");
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    async addBypassRule() {
      if (!this.validateAddBypassRule()) {
        return;
      }
      this.loading.addBypassRule = true;
      this.error.addBypassRule = "";
      const taskAction = "add-bypass-rule";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.addBypassRuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.addBypassRuleValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.addBypassRuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.addBypassRuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            direction: this.direction,
            type: this.type,
            value: this.value,
          },
          extra: {
            title: this.$t("filter_bypass_rules.create_bypass_rule_for", {
              value: this.value,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.addBypassRule = this.getErrorMessage(err);
        this.loading.addBypassRule = false;
        return;
      }
    },
    addBypassRuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.addBypassRule = false;

      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    addBypassRuleValidationOk() {
      this.loading.addBypassRule = false;

      // hide modal after validation
      this.$emit("hide");
    },
    addBypassRuleValidationFailed(validationErrors) {
      this.loading.addBypassRule = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "filter_bypass_rules." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    addBypassRuleCompleted() {
      this.loading.addBypassRule = false;
      this.clearFields();

      // reload addresses
      this.$emit("reloadBypassRules");
    },
    clearFields() {
      this.direction = "from";
      this.type = "email";
      this.value = "";
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.direction-switcher {
  max-width: 20rem;
}
</style>
