<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primary-button-disabled="
      loading.createAddress || loading.alterAddress || loading.listDestinations
    "
    :isLoading="loading.createAddress"
    @modal-hidden="onModalHidden"
    @primary-click="createOrEditAddress"
  >
    <template slot="title">{{
      isEditing
        ? $t("addresses.edit_address_address", { address: address.address })
        : $t("addresses.create_address")
    }}</template>
    <template slot="content">
      <NsInlineNotification
        v-if="error.listDestinations"
        kind="error"
        :title="$t('action.list-destinations')"
        :description="error.listDestinations"
        :showCloseButton="false"
      />
      <cv-form @submit.prevent="createOrEditAddress">
        <div class="address">
          <NsTextInput
            v-model.trim="local"
            :label="$t('addresses.address')"
            :invalid-message="error.local"
            :disabled="isEditing || loading.createAddress"
            data-modal-primary-focus
            class="local-part"
            ref="local"
          />
          <span class="at">@</span>
          <cv-combo-box
            v-model="selectedDomainId"
            :label="
              domains.length
                ? $t('addresses.choose_domain')
                : core.$t('common.loading')
            "
            title="-"
            :auto-filter="true"
            :auto-highlight="true"
            :options="domains"
            :disabled="
              isEditing ||
              loading.createAddress ||
              loading.alterAddress ||
              !domains.length
            "
            :invalid-message="error.domain"
            light
            class="domain hide-label"
            ref="domain"
          >
          </cv-combo-box>
        </div>
        <NsMultiSelect
          v-model="selectedDestinations"
          autoFilter
          autoHighlight
          :disabled="
            loading.createAddress ||
            loading.alterAddress ||
            loading.listDestinations
          "
          filterTagKind="high-contrast"
          :invalidMessage="error.destinations"
          :title="$t('addresses.destinations')"
          :label="
            loading.listDestinations
              ? core.$t('common.loading')
              : $t('addresses.destinations_placeholder')
          "
          selectionFeedback="top-after-reopen"
          filterable
          light
          showSelectedItems
          :unselectAriaLabel="core.$t('common.unselect')"
          :clearSelectionAriaLabel="core.$t('common.clear_selection')"
          :clearFilterLabel="core.$t('common.clear_filter')"
          :selectedLabel="core.$t('common.selected_l')"
          :userInputLabel="$t('addresses.external_destination')"
          :maxDisplayOptions="100"
          acceptUserInput
          showItemType
          selectedItemsColor="high-contrast"
          :options="allDestinationsForUi"
          class="mg-bottom-12"
          ref="destinations"
        >
        </NsMultiSelect>
        <!-- advanced options -->
        <cv-accordion ref="accordion">
          <cv-accordion-item :open="toggleAccordion[0]">
            <template slot="title">{{ core.$t("common.advanced") }}</template>
            <template slot="content">
              <NsTextInput
                v-model.trim="description"
                :label="$t('addresses.description')"
                :invalid-message="error.description"
                :disabled="loading.createAddress || loading.alterAddress"
                ref="description"
              />
              <cv-checkbox
                :label="$t('addresses.internal_address')"
                v-model="isInternal"
                :disabled="loading.createAddress || loading.alterAddress"
                value="checkInternal"
              />
            </template>
          </cv-accordion-item>
        </cv-accordion>
        <!-- need to wrap error notification inside a div: custom elements like NsInlineNotification don't have scrollIntoView() function -->
        <div ref="createAddressError">
          <NsInlineNotification
            v-if="error.createAddress"
            kind="error"
            :title="$t('action.add-address')"
            :description="error.createAddress"
            :showCloseButton="false"
          />
        </div>
        <div ref="alterAddressError">
          <NsInlineNotification
            v-if="error.alterAddress"
            kind="error"
            :title="$t('action.alter-address')"
            :description="error.alterAddress"
            :showCloseButton="false"
          />
        </div>
      </cv-form>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{
      isEditing ? $t("addresses.edit_address") : $t("addresses.create_address")
    }}</template>
  </NsModal>
</template>

<script>
import to from "await-to-js";
import { UtilService, TaskService } from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";

export default {
  name: "CreateOrEditAddressModal",
  mixins: [UtilService, TaskService],
  props: {
    isShown: Boolean,
    domains: {
      type: Array,
      required: true,
    },
    defaultDomainId: {
      type: String,
      default: "",
    },
    address: { type: [Object, null] },
    isEditing: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      local: "",
      selectedDomainId: "",
      isInternal: false,
      description: "",
      allDestinations: [],
      allDestinationsForUi: [],
      selectedDestinations: [],
      loading: {
        createAddress: false,
        alterAddress: false,
        listDestinations: false,
      },
      error: {
        createAddress: "",
        alterAddress: "",
        listDestinations: "",
        local: "",
        domain: "",
        destinations: "",
        description: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
  },
  watch: {
    defaultDomainId: function () {
      this.updateSelectedDomainId();
    },
    isShown: function () {
      if (this.isShown) {
        this.clearErrors();
        this.listDestinations();

        if (this.isEditing) {
          // edit address
          this.local = this.address.local;
          this.selectedDomainId = this.address.domain;
          this.description = this.address.description;
          this.isInternal = this.address.internal;

          // domain
          if (this.address.atype == "domain") {
            this.selectedDomainId = this.address.address.split("@")[1];
          } else if (this.address.atype == "wildcard") {
            this.selectedDomainId = "wildcard";
          }
        }
      } else {
        // closing modal
        if (this.isEditing) {
          this.clearFields();
        }
      }
    },
    "error.createAddress": function () {
      if (this.error.createAddress) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.createAddressError;
          this.scrollToElement(el);
        });
      }
    },
    "error.alterAddress": function () {
      if (this.error.alterAddress) {
        // scroll to notification error

        this.$nextTick(() => {
          const el = this.$refs.alterAddressError;
          this.scrollToElement(el);
        });
      }
    },
  },
  created() {
    this.updateSelectedDomainId();
  },
  methods: {
    updateSelectedDomainId() {
      if (this.defaultDomainId != "all") {
        this.selectedDomainId = this.defaultDomainId;
      } else {
        this.selectedDomainId = "";
      }
    },
    onModalHidden() {
      this.clearErrors();
      this.$emit("hide");
    },
    validateCreateOrEditAddress() {
      this.clearErrors();
      let isValidationOk = true;

      // local part

      if (!this.local) {
        this.error.local = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("local");
          isValidationOk = false;
        }
      }

      // domain

      if (!this.selectedDomainId) {
        this.error.domain = this.$t("common.required");

        if (isValidationOk) {
          this.focusElement("domain");
          isValidationOk = false;
        }
      }

      // destinations

      if (!this.selectedDestinations.length) {
        this.error.destinations = this.$t("addresses.destinations_required");

        if (isValidationOk) {
          this.focusElement("destinations");
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    createOrEditAddress() {
      if (!this.isEditing) {
        // create address
        this.createAddress();
      } else {
        // edit address
        this.alterAddress();
      }
    },
    async createAddress() {
      if (!this.validateCreateOrEditAddress()) {
        return;
      }

      this.loading.createAddress = true;
      this.error.createAddress = "";
      const taskAction = "add-address";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.createAddressAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.createAddressValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.createAddressValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.createAddressCompleted
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
            title: this.$t("addresses.create_address_address", {
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
        this.error.createAddress = this.getErrorMessage(err);
        this.loading.createAddress = false;
        return;
      }
    },
    createAddressAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.createAddress = false;

      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    createAddressValidationOk() {
      this.loading.createAddress = false;

      // hide modal after validation
      this.$emit("hide");
    },
    createAddressValidationFailed(validationErrors) {
      this.loading.createAddress = false;
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
    createAddressCompleted() {
      this.loading.createAddress = false;
      this.clearFields();

      // reload addresses
      this.$emit("reloadAddresses");
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
          label: d.ui_name || d.name,
          type: this.$t(`addresses.${d.dtype}_destination`),
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
              type: this.$t(`addresses.external_destination`),
            });
          }
        }

        this.$nextTick(() => {
          this.selectedDestinations = selectedDestinations;
        });
      }
    },
    async alterAddress() {
      if (!this.validateCreateOrEditAddress()) {
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

.address {
  display: flex;
  align-items: center;

  .local-part {
    flex-grow: 1;
  }

  .at {
    font-weight: bold;
    margin-left: $spacing-05;
    margin-right: $spacing-05;
    color: #525252;
    font-size: 1.2rem;
  }

  .domain {
    flex-grow: 1;
  }
}

.mg-bottom-12 {
  margin-bottom: 12rem;
}
</style>
