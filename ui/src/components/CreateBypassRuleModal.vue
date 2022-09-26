<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primary-button-disabled="loading.createBypassRule"
    :isLoading="loading.createBypassRule"
    @modal-hidden="onModalHidden"
    @primary-click="createBypassRule"
  >
    <template slot="title">{{
      $t("filter_bypass_rules.create_bypass_rule")
    }}</template>
    <template slot="content">
      <cv-form @submit.prevent="createBypassRule">
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
          :disabled="loading.createBypassRule"
          ref="value"
        />
        <!-- <div class="icon-and-text"> ////
          <NsSvg :svg="InformationFilled16" class="icon ns-info" />
          <div
            v-html="
              $t('filter_bypass_rules.rule_description', {
                $t('filter_bypass_rules.direction,
                type,
                value,
              })
            "
          ></div>
        </div> -->

        <!-- need to wrap error notification inside a div: custom elements like NsInlineNotification don't have scrollIntoView() function -->
        <div ref="createBypassRuleError">
          <!-- //// check action.create-bypass-rule -->
          <NsInlineNotification
            v-if="error.createBypassRule"
            kind="error"
            :title="$t('action.create-bypass-rule')"
            :description="error.createBypassRule"
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

//// review

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
        createBypassRule: false,
      },
      error: {
        createBypassRule: "",
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
          return "john.doe@example.org";
        case "domain":
          return "example.org";
        case "ip":
          return "192.168.5.123";
        case "cidr":
          return "192.168.5.0/24";
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
    "error.createBypassRule": function () {
      if (this.error.createBypassRule) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.createBypassRuleError;
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
    validateCreateBypassRule() {
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
    async createBypassRule() {
      if (!this.validateCreateBypassRule()) {
        return;
      }
      this.loading.createBypassRule = true;
      this.error.createBypassRule = "";
      const taskAction = "create-bypass-rule";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.createBypassRuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.createBypassRuleValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.createBypassRuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.createBypassRuleCompleted
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
        this.error.createBypassRule = this.getErrorMessage(err);
        this.loading.createBypassRule = false;
        return;
      }
    },
    createBypassRuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.createBypassRule = false;

      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    createBypassRuleValidationOk() {
      this.loading.createBypassRule = false;

      // hide modal after validation
      this.$emit("hide");
    },
    createBypassRuleValidationFailed(validationErrors) {
      this.loading.createBypassRule = false;
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
    createBypassRuleCompleted() {
      this.loading.createBypassRule = false;
      this.clearFields();

      // reload addresses
      this.$emit("reloadBypassRules");
    },
    clearFields() {
      this.local = "";
      this.isInternal = false;
      this.description = "";
      this.selectedDestinations = [];
    },
    async listDestinations() {
      this.loading.listDestinations = true;
      this.error.listDestinations = "";
      const taskAction = "list-destinations";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listDestinationsAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listDestinationsCompleted
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
        this.error.listDestinations = this.getErrorMessage(err);
        this.loading.listDestinations = false;
        return;
      }
    },
    listDestinationsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listDestinations = this.$t("error.generic_error");
      this.loading.listDestinations = false;
    },
    listDestinationsCompleted(taskContext, taskResult) {
      this.loading.listDestinations = false;
      this.allDestinations = taskResult.output;

      this.allDestinationsForUi = this.allDestinations.map((d) => {
        return {
          name: d.name,
          value: `${d.name}_${d.dtype}`,
          label: d.name,
          type: this.$t(`common.${d.dtype}_destination`),
          description: d.ui_name,
        };
      });

      if (this.isEditing) {
        const selectedDestinations = [];

        for (const d of this.address.destinations) {
          const destFound = this.allDestinationsForUi.find((dui) => {
            return dui.value === `${d.name}_${d.dtype}`;
          });

          if (destFound) {
            selectedDestinations.push(destFound.value);
          } else {
            // destination input by user
            selectedDestinations.push(d.name);

            this.allDestinationsForUi.push({
              name: d.name,
              value: d.name,
              label: d.name,
              type: this.$t(`common.external_destination`),
            });
          }
        }

        this.$nextTick(() => {
          this.selectedDestinations = selectedDestinations;
        });
      }
    },
    async alterAddress() {
      if (!this.validateCreateBypassRule()) {
        return;
      }

      this.loading.alterAddress = true;
      this.error.alterAddress = "";
      const taskAction = "alter-address";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.alterAddressAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.alterAddressValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.alterAddressValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.alterAddressCompleted
      );

      const destinations = [];

      for (const selectedDestination of this.selectedDestinations) {
        const destFound = this.allDestinations.find(
          (d) => selectedDestination === `${d.name}_${d.dtype}`
        );

        if (destFound) {
          destinations.push(destFound);
        } else {
          // destination input by user
          destinations.push({
            dtype: "external",
            name: selectedDestination,
          });
        }
      }

      const alterAddressData = {
        local: this.local,
        internal: this.isInternal,
        destinations: destinations,
        description: this.description,
      };

      let domainForNotification = "";

      if (this.selectedDomainId == "wildcard") {
        alterAddressData.atype = "wildcard";
      } else {
        alterAddressData.atype = "domain";
        alterAddressData.domain = this.selectedDomainId;
        domainForNotification = this.selectedDomainId;
      }

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: alterAddressData,
          extra: {
            title: this.$t("addresses.edit_address_address", {
              address: `${this.local}@${domainForNotification}`,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.alterAddress = this.getErrorMessage(err);
        this.loading.alterAddress = false;
        return;
      }
    },
    alterAddressAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.alterAddress = false;

      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    alterAddressValidationOk() {
      this.loading.alterAddress = false;

      // hide modal after validation
      this.$emit("hide");
    },
    alterAddressValidationFailed(validationErrors) {
      this.loading.alterAddress = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "addresses." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    alterAddressCompleted() {
      this.loading.alterAddress = false;
      this.clearFields();

      // reload addresses
      this.$emit("reloadAddresses");
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

// .icon-and-text { ////
//   justify-content: flex-start;
//}

.direction-switcher {
  max-width: 20rem;
}
</style>