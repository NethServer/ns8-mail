<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primary-button-disabled="loading.addDomain || loading.alterDomain"
    :isLoading="loading.addDomain"
    @modal-hidden="onModalHidden"
    @primary-click="createOrEditDomain"
  >
    <template slot="title">{{
      isEditing
        ? $t("domains.edit_domain_domain", { domain: domain.domain })
        : $t("domains.create_domain")
    }}</template>
    <template slot="content">
      <cv-form @submit.prevent="createOrEditDomain">
        <NsTextInput
          v-model.trim="name"
          :label="$t('domains.name')"
          placeholder="example.org"
          :invalid-message="error.domain"
          :disabled="isEditing || loading.addDomain"
          data-modal-primary-focus
          ref="domain"
        />
        <NsTextInput
          v-model.trim="description"
          :label="$t('domains.description')"
          :invalid-message="error.description"
          :disabled="loading.addDomain || loading.alterDomain"
          ref="description"
        />
        <NsCheckbox
          :label="
            $t('domains.add_user_addresses_from_user_domain', {
              userDomain: userDomain ? userDomain.name : '',
            })
          "
          v-model="addUserAddressesFromUserDomain"
          :disabled="loading.addDomain || loading.alterDomain"
          tooltipAlignment="center"
          tooltipDirection="right"
          value="checkAddUserAddressesFromUserDomain"
        >
          <template slot="tooltip">
            <div
              v-html="$t('domains.add_user_addresses_from_user_domain_tooltip')"
            ></div>
          </template>
        </NsCheckbox>
        <NsCheckbox
          :label="
            $t('domains.add_group_addresses_from_user_domain', {
              userDomain: userDomain ? userDomain.name : '',
            })
          "
          v-model="addGroupAddressesFromUserDomain"
          :disabled="loading.addDomain || loading.alterDomain"
          tooltipAlignment="center"
          tooltipDirection="right"
          value="checkAddGroupAddressesFromUserDomain"
        >
          <template slot="tooltip">
            <div
              v-html="
                $t('domains.add_group_addresses_from_user_domain_tooltip')
              "
            ></div>
          </template>
        </NsCheckbox>
        <!-- advanced options -->
        <cv-accordion ref="accordion" class="mg-top-lg">
          <cv-accordion-item
            :open="isAccordionOpen"
            @click="toggleAccordionStatus"
          >
            <template slot="title">{{ core.$t("common.advanced") }}</template>
            <template slot="content">
              <!-- accept unknown recipients toggle -->
              <NsToggle
                value="aurValue"
                :form-item="true"
                v-model="acceptUnknownRecipients.enabled"
                :disabled="
                  loading.addDomain ||
                  loading.alterDomain ||
                  addUserAddressesFromUserDomain
                "
                :class="[
                  'toggle-without-label',
                  'mg-top-sm',
                  { 'mg-bottom-md': acceptUnknownRecipients.enabled },
                ]"
                ref="acceptUnknownRecipients"
              >
                <template slot="tooltip">
                  <div
                    v-html="$t('domains.accept_unknown_recipients_tooltip')"
                  ></div>
                </template>
                <template slot="text-left"
                  >{{ $t("domains.accept_unknown_recipients") }}
                  <cv-interactive-tooltip
                    alignment="center"
                    direction="right"
                    class="tooltip info"
                  >
                    <template slot="trigger"></template>
                    <template slot="content">
                      <div
                        v-html="$t('domains.accept_unknown_recipients_tooltip')"
                      ></div>
                    </template>
                  </cv-interactive-tooltip>
                </template>
                <template slot="text-right"
                  >{{ $t("domains.accept_unknown_recipients") }}
                  <cv-interactive-tooltip
                    alignment="center"
                    direction="right"
                    class="tooltip info"
                  >
                    <template slot="trigger"></template>
                    <template slot="content">
                      <div
                        v-html="$t('domains.accept_unknown_recipients_tooltip')"
                      ></div>
                    </template> </cv-interactive-tooltip
                ></template>
              </NsToggle>
              <!-- accept unknown recipients destination -->
              <NsInlineNotification
                v-if="error.listDestinations"
                kind="error"
                :title="$t('action.list-destinations')"
                :description="error.listDestinations"
                :showCloseButton="false"
              />
              <NsComboBox
                v-if="acceptUnknownRecipients.enabled"
                v-model="acceptUnknownRecipients.catchall"
                :autoFilter="true"
                :autoHighlight="true"
                :title="$t('domains.deliver_to')"
                :label="
                  loading.listDestinations
                    ? core.$t('common.loading')
                    : core.$t('common.choose')
                "
                :options="allDestinationsForUi"
                :userInputLabel="core.$t('common.user_input_l')"
                :acceptUserInput="false"
                :showItemType="true"
                :invalid-message="error.catchall"
                :disabled="
                  loading.addDomain ||
                  loading.alterDomain ||
                  loading.listDestinations
                "
                light
                ref="catchall"
              />
              <!-- copy inbound messages toggle -->
              <NsToggle
                value="cimValue"
                :form-item="true"
                v-model="copyInboundMessages.enabled"
                :disabled="loading.addDomain || loading.alterDomain"
                :class="[
                  'toggle-without-label',
                  { 'mg-bottom-md': copyInboundMessages.enabled },
                ]"
                ref="copyInboundMessages"
              >
                <template slot="text-left">{{
                  $t("domains.copy_inbound_messages")
                }}</template>
                <template slot="text-right">{{
                  $t("domains.copy_inbound_messages")
                }}</template>
              </NsToggle>
              <!-- copy inbound messages destination -->
              <NsTextInput
                v-if="copyInboundMessages.enabled"
                v-model.trim="copyInboundMessages.bccaddr"
                :label="$t('domains.send_to')"
                :invalid-message="error.bccaddr"
                :disabled="loading.addDomain || loading.alterDomain"
                ref="bccaddr"
              />
            </template>
          </cv-accordion-item>
        </cv-accordion>
        <!-- need to wrap error notification inside a div: custom elements like NsInlineNotification don't have scrollIntoView() function -->
        <div ref="addDomainError">
          <NsInlineNotification
            v-if="error.addDomain"
            kind="error"
            :title="$t('action.add-domain')"
            :description="error.addDomain"
            :showCloseButton="false"
          />
        </div>
        <div ref="alterDomainError">
          <NsInlineNotification
            v-if="error.alterDomain"
            kind="error"
            :title="$t('action.alter-domain')"
            :description="error.alterDomain"
            :showCloseButton="false"
          />
        </div>
      </cv-form>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{
      isEditing ? $t("domains.edit_domain") : $t("domains.create_domain")
    }}</template>
  </NsModal>
</template>

<script>
import to from "await-to-js";
import { UtilService, TaskService } from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";

export default {
  name: "CreateOrEditDomainModal",
  mixins: [UtilService, TaskService],
  props: {
    isShown: Boolean,
    domain: { type: [Object, null] },
    isEditing: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      name: "",
      description: "",
      addUserAddressesFromUserDomain: false,
      addGroupAddressesFromUserDomain: false,
      acceptUnknownRecipients: {
        enabled: false,
        catchall: "",
      },
      copyInboundMessages: {
        enabled: false,
        bccaddr: "",
      },
      allDestinations: [],
      allDestinationsForUi: [],
      isAccordionOpen: false,
      loading: {
        addDomain: false,
        alterDomain: false,
        listDestinations: false,
      },
      error: {
        addDomain: "",
        alterDomain: "",
        domain: "",
        description: "",
        catchall: "",
        bccaddr: "",
        listDestinations: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "userDomain"]),
  },
  watch: {
    isShown: function () {
      if (this.isShown) {
        this.clearErrors();
        this.isAccordionOpen = false;

        if (this.isEditing) {
          // edit domain
          this.name = this.domain.domain;
          this.description = this.domain.description;
          this.addUserAddressesFromUserDomain = this.domain.addusers;
          this.addGroupAddressesFromUserDomain = this.domain.addgroups;
          this.acceptUnknownRecipients.enabled = !!this.domain.catchall;
          this.copyInboundMessages.enabled = !!this.domain.bccaddr;
          this.copyInboundMessages.bccaddr = this.domain.bccaddr;

          if (this.acceptUnknownRecipients.enabled) {
            this.listDestinations();
          }

          // open accordion if any advanced option is set
          if (
            this.acceptUnknownRecipients.enabled ||
            this.copyInboundMessages.enabled
          ) {
            this.$nextTick(() => {
              this.isAccordionOpen = true;
            });
          }

          this.focusElement("description");
        }
      } else {
        // closing modal
        if (this.isEditing) {
          this.clearFields();
        }
      }
    },
    "error.addDomain": function () {
      if (this.error.addDomain) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.addDomainError;
          this.scrollToElement(el);
        });
      }
    },
    "error.alterDomain": function () {
      if (this.error.alterDomain) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.alterDomainError;
          this.scrollToElement(el);
        });
      }
    },
    addUserAddressesFromUserDomain: function () {
      if (this.addUserAddressesFromUserDomain) {
        this.acceptUnknownRecipients.enabled = false;
      }
    },
    "acceptUnknownRecipients.enabled": function () {
      if (this.acceptUnknownRecipients.enabled) {
        this.listDestinations();
      }
    },
  },
  methods: {
    onModalHidden() {
      this.clearErrors();
      this.$emit("hide");
    },
    validateCreateOrEditDomain() {
      this.clearErrors();
      let isValidationOk = true;

      // domain name

      if (!this.name) {
        this.error.domain = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("domain");
          isValidationOk = false;
        }
      }

      // catchall (accept unknown recipients)

      if (
        this.acceptUnknownRecipients.enabled &&
        !this.acceptUnknownRecipients.catchall
      ) {
        this.error.catchall = this.$t(
          "domains.required_if_accept_unknown_recipients"
        );

        if (isValidationOk) {
          this.focusElement("catchall");
          isValidationOk = false;
        }
      }

      // bccaddr (copy inbound messages)

      if (
        this.copyInboundMessages.enabled &&
        !this.copyInboundMessages.bccaddr
      ) {
        this.error.bccaddr = this.$t(
          "domains.required_if_copy_inbound_messages"
        );

        if (isValidationOk) {
          this.focusElement("bccaddr");
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    createOrEditDomain() {
      if (!this.isEditing) {
        // create domain
        this.addDomain();
      } else {
        // edit domain
        this.alterDomain();
      }
    },
    async addDomain() {
      if (!this.validateCreateOrEditDomain()) {
        return;
      }

      this.loading.addDomain = true;
      this.error.addDomain = "";
      const taskAction = "add-domain";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.addDomainAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.addDomainValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.addDomainValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.addDomainCompleted
      );

      const addDomainData = {
        domain: this.name,
        description: this.description,
        addusers: this.addUserAddressesFromUserDomain,
        addgroups: this.addGroupAddressesFromUserDomain,
      };

      if (this.copyInboundMessages.enabled) {
        addDomainData.bccaddr = this.copyInboundMessages.bccaddr;
      }

      if (this.acceptUnknownRecipients.enabled) {
        const catchallFound = this.allDestinations.find(
          (catchall) =>
            this.acceptUnknownRecipients.catchall ===
            `${catchall.name}_${catchall.dtype}`
        );

        if (catchallFound) {
          addDomainData.catchall = {
            dtype: catchallFound.dtype,
            name: catchallFound.name,
          };
        }
      }

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: addDomainData,
          extra: {
            title: this.$t("domains.create_domain_domain", {
              domain: this.name,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.addDomain = this.getErrorMessage(err);
        this.loading.addDomain = false;
        return;
      }
    },
    addDomainAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.addDomain = false;

      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    addDomainValidationOk() {
      this.loading.addDomain = false;

      // hide modal after validation
      this.$emit("hide");
    },
    addDomainValidationFailed(validationErrors) {
      this.loading.addDomain = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "domains." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    addDomainCompleted() {
      this.loading.addDomain = false;
      this.clearFields();

      // reload domains
      this.$emit("reloadDomains");
    },
    async alterDomain() {
      if (!this.validateCreateOrEditDomain()) {
        return;
      }
      this.loading.alterDomain = true;
      this.error.alterDomain = "";
      const taskAction = "alter-domain";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.alterDomainAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.alterDomainValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.alterDomainValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.alterDomainCompleted
      );

      const alterDomainData = {
        domain: this.name,
        description: this.description,
        addusers: this.addUserAddressesFromUserDomain,
        addgroups: this.addGroupAddressesFromUserDomain,
      };

      if (this.copyInboundMessages.enabled) {
        alterDomainData.bccaddr = this.copyInboundMessages.bccaddr;
      }

      if (this.acceptUnknownRecipients.enabled) {
        const catchallFound = this.allDestinations.find(
          (catchall) =>
            this.acceptUnknownRecipients.catchall ===
            `${catchall.name}_${catchall.dtype}`
        );

        if (catchallFound) {
          alterDomainData.catchall = {
            dtype: catchallFound.dtype,
            name: catchallFound.name,
          };
        }
      }

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: alterDomainData,
          extra: {
            title: this.$t("domains.edit_domain_domain", {
              domain: this.name,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.alterDomain = this.getErrorMessage(err);
        this.loading.alterDomain = false;
        return;
      }
    },
    alterDomainAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.alterDomain = false;

      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    alterDomainValidationOk() {
      this.loading.alterDomain = false;

      // hide modal after validation
      this.$emit("hide");
    },
    alterDomainValidationFailed(validationErrors) {
      this.loading.alterDomain = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "domains." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    alterDomainCompleted() {
      this.loading.alterDomain = false;
      this.clearFields();

      // reload domains
      this.$emit("reloadDomains");
    },
    clearFields() {
      this.name = "";
      this.description = "";
      this.addUserAddressesFromUserDomain = false;
      this.addGroupAddressesFromUserDomain = false;
      this.acceptUnknownRecipients.enabled = false;
      this.acceptUnknownRecipients.catchall = "";
      this.copyInboundMessages.enabled = false;
      this.copyInboundMessages.bccaddr = "";
    },
    async listDestinations() {
      this.loading.listDestinations = true;
      this.error.listDestinations = "";
      const taskAction = "list-destinations";
      const eventId = this.getUuid();
      this.acceptUnknownRecipients.catchall = "";

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
          label: d.ui_name || d.name,
          type: this.$t(`common.${d.dtype}_destination`),
        };
      });

      if (this.isEditing && this.domain.catchall) {
        let selectedCatchall = "";

        const destFound = this.allDestinationsForUi.find((dui) => {
          return (
            dui.value ===
            `${this.domain.catchall.name}_${this.domain.catchall.dtype}`
          );
        });

        if (destFound) {
          selectedCatchall = destFound.value;

          this.$nextTick(() => {
            this.acceptUnknownRecipients.catchall = selectedCatchall;
          });
        }
      }
    },
    toggleAccordionStatus() {
      this.isAccordionOpen = !this.isAccordionOpen;
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
</style>
