<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primary-button-disabled="
      loading.alterUserMailbox || loading.listDestinations
    "
    :isLoading="loading.alterUserMailbox"
    @modal-hidden="onModalHidden"
    @primary-click="alterUserMailbox"
  >
    <template slot="title">{{
      $t("mailboxes.edit_mailbox_mailbox", {
        mailbox: mailbox ? mailbox.user : "",
      })
    }}</template>
    <template slot="content">
      <cv-form @submit.prevent="alterUserMailbox">
        <!-- forward -->
        <NsToggle
          value="forwardValue"
          :form-item="true"
          v-model="forward.enabled"
          :disabled="loading.alterUserMailbox"
          class="toggle-without-label"
        >
          <template slot="text-left">
            {{ $t("mailboxes.forward_messages") }}
          </template>
          <template slot="text-right"
            >{{ $t("mailboxes.forward_messages") }}
          </template>
        </NsToggle>
        <div v-show="forward.enabled" class="toggle-dependent">
          <NsMultiSelect
            v-model="forward.selectedDestinations"
            autoFilter
            autoHighlight
            :disabled="loading.alterUserMailbox || loading.listDestinations"
            filterTagKind="high-contrast"
            :invalidMessage="error.forward"
            :title="$t('mailboxes.forward_addresses')"
            :label="
              loading.listDestinations
                ? core.$t('common.loading')
                : $t('mailboxes.destinations_placeholder')
            "
            selectionFeedback="top-after-reopen"
            filterable
            light
            showSelectedItems
            :unselectAriaLabel="core.$t('common.unselect')"
            :clearSelectionAriaLabel="core.$t('common.clear_selection')"
            :clearFilterLabel="core.$t('common.clear_filter')"
            :selectedLabel="core.$t('common.selected_l')"
            :userInputLabel="$t('common.external_destination')"
            :maxDisplayOptions="100"
            acceptUserInput
            showItemType
            selectedItemsColor="high-contrast"
            :options="forward.allDestinationsForUi"
          />
          <NsCheckbox
            :label="$t('mailboxes.keep_messages_on_server')"
            v-model="forward.keepcopy"
            :disabled="loading.alterUserMailbox"
            value="checkForwardKeepCopy"
          />
        </div>
        <!-- custom mailbox quota -->
        <NsToggle
          value="checkCustomQuota"
          :form-item="true"
          v-model="customQuota.enabled"
          :disabled="loading.alterUserMailbox"
          class="toggle-without-label"
        >
          <template slot="text-left">
            {{ $t("mailboxes.custom_mailbox_quota") }}
          </template>
          <template slot="text-right"
            >{{ $t("mailboxes.custom_mailbox_quota") }}
          </template>
        </NsToggle>
        <div v-show="customQuota.enabled" class="toggle-dependent">
          <NsByteSlider
            v-model="customQuota.limit"
            :label="$t('mailboxes.quota')"
            min="1"
            max="10240"
            step="1"
            stepMultiplier="1023"
            minLabel=""
            maxLabel=""
            showUnlimited
            :unlimitedLabel="$t('mailboxes.unlimited')"
            :isUnlimited="customQuota.unlimited"
            :byteUnit="customQuota.byteUnit"
            showHumanReadableLabel
            showMibGibToggle
            tagKind="high-contrast"
            :invalidMessage="error.limit"
            :disabled="loading.alterUserMailbox"
            light
            @unlimited="customQuota.unlimited = $event"
            @byteUnit="customQuota.byteUnit = $event"
          />
        </div>
        <NsInlineNotification
          v-if="error.alterUserMailbox"
          kind="error"
          :title="$t('action.alter-user-mailbox')"
          :description="error.alterUserMailbox"
          :showCloseButton="false"
        />
      </cv-form>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{
      $t("mailboxes.edit_mailbox")
    }}</template>
  </NsModal>
</template>

<script>
import to from "await-to-js";
import { UtilService, TaskService } from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";

export default {
  name: "EditUserMailboxModal",
  mixins: [UtilService, TaskService],
  props: {
    isShown: Boolean,
    mailbox: {
      type: [Object, null],
    },
  },
  data() {
    return {
      forward: {
        enabled: false,
        allDestinations: [],
        allDestinationsForUi: [],
        selectedDestinations: [],
        keepcopy: false,
      },
      customQuota: {
        enabled: false,
        limit: "0",
        unlimited: true,
        byteUnit: "gib",
      },
      loading: {
        alterUserMailbox: false,
        listDestinations: false,
      },
      error: {
        alterUserMailbox: "",
        listDestinations: "",
        forward: "",
        limit: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
  },
  watch: {
    isShown: function () {
      if (this.isShown) {
        // set forward addresses

        if (this.mailbox.forward) {
          this.forward.enabled = true;
          this.forward.keepcopy = this.mailbox.forward.keepcopy;
          this.listDestinations();
        } else {
          this.forward.enabled = false;
          this.forward.keepcopy = false;
          this.selectedDestinations = [];
        }

        // set mailbox quota

        if (this.mailbox.quota) {
          this.customQuota.enabled = !!this.mailbox.quota.custom;
          this.customQuota.unlimited = !this.mailbox.quota.limit;

          if (this.mailbox.quota.limit && this.mailbox.quota.limit < 1024) {
            this.customQuota.byteUnit = "mib";
            this.customQuota.limit = this.mailbox.quota.limit.toString();
          } else {
            this.customQuota.byteUnit = "gib";
            this.customQuota.limit = (
              this.mailbox.quota.limit / 1024
            ).toString();
          }
        } else {
          this.customQuota.enabled = false;
          this.customQuota.limit = "0";
          this.customQuota.unlimited = true;
          this.customQuota.byteUnit = "gib";
        }
      }
    },
    "forward.enabled": function () {
      if (this.forward.enabled) {
        this.listDestinations();
      }
    },
  },
  methods: {
    onModalHidden() {
      this.clearErrors();
      this.$emit("hide");
    },
    validateAlterUserMailbox() {
      this.clearErrors();
      let isValidationOk = true;

      // forward enabled but no forward address selected

      if (this.forward.enabled && !this.forward.selectedDestinations.length) {
        this.error.forward = this.$t(
          "mailboxes.forward_enabled_but_no_destination"
        );

        if (isValidationOk) {
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    async alterUserMailbox() {
      if (!this.validateAlterUserMailbox()) {
        return;
      }

      this.loading.alterUserMailbox = true;
      this.error.alterUserMailbox = "";
      const taskAction = "alter-user-mailbox";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.alterUserMailboxAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.alterUserMailboxValidationOk
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.alterUserMailboxValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.alterUserMailboxCompleted
      );

      const destinations = [];

      for (const selectedDestination of this.forward.selectedDestinations) {
        const destFound = this.forward.allDestinations.find(
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

      let forward = null;

      if (this.forward.enabled) {
        forward = {
          destinations: destinations,
          keepcopy: this.forward.keepcopy,
        };
      } else {
        forward = {
          destinations: [],
        };
      }

      let quota = null;

      if (this.customQuota.enabled) {
        let limit = 0;

        if (!this.customQuota.unlimited) {
          if (this.customQuota.byteUnit === "gib") {
            limit = parseInt(this.customQuota.limit) * 1024;
          } else {
            // mib
            limit = parseInt(this.customQuota.limit);
          }
        }

        quota = {
          custom: true,
          limit: limit,
        };
      } else {
        quota = {
          custom: false,
        };
      }

      const alterUserMailboxData = {
        user: this.mailbox.user,
        quota,
      };

      if (forward) {
        alterUserMailboxData.forward = forward;
      }

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: alterUserMailboxData,
          extra: {
            title: this.$t("mailboxes.edit_mailbox_mailbox", {
              mailbox: this.mailbox.user,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.alterUserMailbox = this.getErrorMessage(err);
        this.loading.alterUserMailbox = false;
        return;
      }
    },
    alterUserMailboxAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.alterUserMailbox = false;

      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    alterUserMailboxValidationOk() {
      this.loading.alterUserMailbox = false;

      // hide modal after validation
      this.$emit("hide");
    },
    alterUserMailboxValidationFailed(validationErrors) {
      this.loading.alterUserMailbox = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "mailboxes." + validationError.error,
          "error." + validationError.error
        );

        if (!focusAlreadySet) {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    alterUserMailboxCompleted() {
      this.clearFields();
      this.loading.alterUserMailbox = false;

      // reload mailboxes
      this.$emit("mailboxAltered");
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
      this.forward.allDestinations = taskResult.output;

      this.forward.allDestinationsForUi = this.forward.allDestinations.map(
        (d) => {
          return {
            name: d.name,
            value: `${d.name}_${d.dtype}`,
            label: d.ui_name || d.name,
            type: this.$t(`common.${d.dtype}_destination`),
          };
        }
      );

      const selectedDestinations = [];

      if (this.mailbox.forward) {
        for (const d of this.mailbox.forward.destinations) {
          const destFound = this.forward.allDestinationsForUi.find((dui) => {
            return dui.value === `${d.name}_${d.dtype}`;
          });

          if (destFound) {
            selectedDestinations.push(destFound.value);
          } else {
            // destination input by user
            selectedDestinations.push(d.name);

            this.forward.allDestinationsForUi.push({
              name: d.name,
              value: d.name,
              label: d.name,
              type: this.$t(`common.external_destination`),
            });
          }
        }
      }

      this.$nextTick(() => {
        this.forward.selectedDestinations = selectedDestinations;
      });
    },
    clearFields() {
      this.forward.enabled = false;
      this.forward.selectedDestinations = [];
      this.customQuota.enabled = false;
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";
</style>
