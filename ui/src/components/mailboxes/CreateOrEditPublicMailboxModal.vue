<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsModal
    size="default"
    :visible="isShown"
    :primary-button-disabled="
      loading.addPublicMailbox ||
      loading.alterPublicMailbox ||
      loading.listAclSubjects
    "
    :isLoading="loading.addPublicMailbox"
    @modal-hidden="onModalHidden"
    @primary-click="createOrEditMailbox"
  >
    <template slot="title">{{
      isEditing
        ? $t("mailboxes.edit_mailbox_mailbox", { mailbox: mailbox.mailbox })
        : $t("mailboxes.create_public_mailbox")
    }}</template>
    <template slot="content">
      <NsInlineNotification
        v-if="error.apoMember"
        kind="warning"
        :title="core.$t('common.warning')"
        :description="error.apoMember"
        :showCloseButton="false"
      />
      <NsInlineNotification
        v-if="!isEditing"
        kind="info"
        :title="$t('mailboxes.wildcard_address_info_title')"
        :description="$t('mailboxes.wildcard_address_info_description')"
        :showCloseButton="false"
      />
      <NsInlineNotification
        v-if="error.listAclSubjects"
        kind="error"
        :title="$t('action.list-acl-subjects')"
        :description="error.listAclSubjects"
        :showCloseButton="false"
      />
      <cv-form
        @submit.prevent="createOrEditMailbox"
        :class="{ 'mg-bottom-14': !selectedAclSubjects.length }"
      >
        <NsTextInput
          v-model.trim="mailboxName"
          :label="$t('mailboxes.public_mailbox_name')"
          :invalid-message="error.mailbox"
          :disabled="isEditing || loading.addPublicMailbox"
          data-modal-primary-focus
          ref="mailbox"
        />
        <NsMultiSelect
          v-model="selectedAclSubjects"
          autoFilter
          autoHighlight
          :disabled="loading.alterPublicMailbox || loading.listAclSubjects"
          filterTagKind="high-contrast"
          :invalidMessage="error.acl"
          :title="$t('mailboxes.members')"
          :label="
            loading.listAclSubjects
              ? core.$t('common.loading')
              : $t('mailboxes.acl_members_placeholder')
          "
          selectionFeedback="top-after-reopen"
          filterable
          light
          showSelectedItems
          :unselectAriaLabel="core.$t('common.unselect')"
          :clearSelectionAriaLabel="core.$t('common.clear_selection')"
          :clearFilterLabel="core.$t('common.clear_filter')"
          :selectedLabel="core.$t('common.selected_l')"
          :acceptUserInput="false"
          userInputLabel=""
          :maxDisplayOptions="100"
          showItemType
          showItemDescription
          selectedItemsColor="high-contrast"
          :options="allAclSubjectsForUi"
          ref="acl"
        />
        <PublicMailboxAcl v-if="acls.length" :acls="acls" />
        <!-- need to wrap error notification inside a div: custom elements like NsInlineNotification don't have scrollIntoView() function -->
        <div ref="addPublicMailboxError">
          <NsInlineNotification
            v-if="error.addPublicMailbox"
            kind="error"
            :title="$t('action.add-public-mailbox')"
            :description="error.addPublicMailbox"
            :showCloseButton="false"
          />
        </div>
        <div ref="alterPublicMailboxError">
          <NsInlineNotification
            v-if="error.alterPublicMailbox"
            kind="error"
            :title="$t('action.alter-public-mailbox')"
            :description="error.alterPublicMailbox"
            :showCloseButton="false"
          />
        </div>
      </cv-form>
    </template>
    <template slot="secondary-button">{{ core.$t("common.cancel") }}</template>
    <template slot="primary-button">{{
      isEditing ? $t("mailboxes.edit_mailbox") : $t("mailboxes.create_mailbox")
    }}</template>
  </NsModal>
</template>

<script>
import to from "await-to-js";
import { UtilService, TaskService } from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";
import PublicMailboxAcl from "./PublicMailboxAcl.vue";

export default {
  name: "CreateOrEditPublicMailboxModal",
  components: { PublicMailboxAcl },
  mixins: [UtilService, TaskService],
  props: {
    isShown: Boolean,
    mailbox: { type: [Object, null] },
    isEditing: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      mailboxName: "",
      allAclSubjects: [],
      allAclSubjectsForUi: [],
      selectedAclSubjects: [],
      acls: [],
      apoMembers: [],
      loading: {
        addPublicMailbox: false,
        alterPublicMailbox: false,
        listAclSubjects: false,
      },
      error: {
        addPublicMailbox: "",
        alterPublicMailbox: "",
        listAclSubjects: "",
        mailbox: "",
        acl: "",
        apoMember: "",
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
        this.listAclSubjects();

        if (this.isEditing) {
          // edit mailbox

          this.mailboxName = this.mailbox.mailbox;
        } else {
          // create mailbox

          this.clearFields();
        }
      }
    },
    "error.addPublicMailbox": function () {
      if (this.error.addPublicMailbox) {
        // scroll to notification error
        this.$nextTick(() => {
          const el = this.$refs.addPublicMailboxError;
          this.scrollToElement(el);
        });
      }
    },
    "error.alterPublicMailbox": function () {
      if (this.error.alterPublicMailbox) {
        // scroll to notification error
        this.$nextTick(() => {
          const el = this.$refs.alterPublicMailboxError;
          this.scrollToElement(el);
        });
      }
    },
    selectedAclSubjects: function () {
      const acls = [];
      this.apoMembers = [];
      this.error.apoMember = "";

      for (const selectedAclSubject of this.selectedAclSubjects) {
        const subjectFound = this.allAclSubjects.find(
          (d) => selectedAclSubject.toLowerCase() === `${d.name}_${d.dtype}`.toLowerCase()
        );

        if (subjectFound) {
          let rtype = "ro";

          if (this.isEditing) {
            const aclFound = this.mailbox.acls.find(
              (a) =>
                selectedAclSubject.toLowerCase() === `${a.subject.name}_${a.subject.dtype}`.toLowerCase()
            );

            if (aclFound) {
              rtype = aclFound.rights.rtype;
            }
          }

          const acl = {
            stype: subjectFound.dtype,
            subject: subjectFound,
            rights: {
              rtype: rtype,
              values: [],
            },
          };
          acls.push(acl);
        } else {
          // apo

          this.apoMembers.push(selectedAclSubject);

          if (this.apoMembers.length == 1) {
            this.error.apoMember = this.$t("mailboxes.member_not_found", {
              member: this.apoMembers[0],
            });
          } else {
            this.error.apoMember = this.$t(
              "mailboxes.multiple_members_not_found",
              {
                members: this.apoMembers.join(", "),
              }
            );
          }
        }
      }
      this.acls = acls;
    },
  },
  methods: {
    onModalHidden() {
      this.clearErrors();
      this.$emit("hide");
    },
    validateCreateOrEditMailbox() {
      this.clearErrors();
      let isValidationOk = true;

      // mailbox name

      if (!this.mailboxName) {
        this.error.mailbox = this.$t("common.required");
        if (isValidationOk) {
          this.focusElement("mailbox");
          isValidationOk = false;
        }
      }

      // acl subjects

      if (!this.selectedAclSubjects.length) {
        this.error.acl = this.$t("mailboxes.at_least_one_member");
        if (isValidationOk) {
          this.focusElement("acl");
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    createOrEditMailbox() {
      if (!this.isEditing) {
        // create mailbox
        this.addPublicMailbox();
      } else {
        // edit mailbox
        this.alterPublicMailbox();
      }
    },
    async addPublicMailbox() {
      if (!this.validateCreateOrEditMailbox()) {
        return;
      }

      this.loading.addPublicMailbox = true;
      this.error.addPublicMailbox = "";
      const taskAction = "add-public-mailbox";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.addPublicMailboxAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.addPublicMailboxValidationOk
      );

      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.addPublicMailboxValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.addPublicMailboxCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            mailbox: this.mailboxName,
            acls: this.acls,
          },
          extra: {
            title: this.$t("mailboxes.create_public_mailbox_mailbox", {
              mailbox: this.mailboxName,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );

      const err = res[0];
      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.addPublicMailbox = this.getErrorMessage(err);
        this.loading.addPublicMailbox = false;
        return;
      }
    },
    addPublicMailboxAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.addPublicMailbox = false;
      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    addPublicMailboxValidationOk() {
      this.loading.addPublicMailbox = false;
      // hide modal after validation
      this.$emit("hide");
    },
    addPublicMailboxValidationFailed(validationErrors) {
      this.loading.addPublicMailbox = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;
        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "mailboxes." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    addPublicMailboxCompleted() {
      this.loading.addPublicMailbox = false;
      this.clearFields();

      // reload mailboxes
      this.$emit("mailboxAdded");
    },
    clearFields() {
      this.mailboxName = "";
      this.allAclSubjects = [];
      this.allAclSubjectsForUi = [];
      this.selectedAclSubjects = [];
      this.acls = [];
    },
    async alterPublicMailbox() {
      if (!this.validateCreateOrEditMailbox()) {
        return;
      }
      this.loading.alterPublicMailbox = true;
      this.error.alterPublicMailbox = "";
      const taskAction = "alter-public-mailbox";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.alterPublicMailboxAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-ok-${eventId}`,
        this.alterPublicMailboxValidationOk
      );

      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.alterPublicMailboxValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.alterPublicMailboxCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            mailbox: this.mailboxName,
            acls: this.acls,
          },
          extra: {
            title: this.$t("mailboxes.edit_public_mailbox_mailbox", {
              mailbox: this.mailboxName,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );

      const err = res[0];
      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.alterPublicMailbox = this.getErrorMessage(err);
        this.loading.alterPublicMailbox = false;
        return;
      }
    },
    alterPublicMailboxAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.alterPublicMailbox = false;
      // hide modal so that user can see error notification
      this.$emit("hide");
    },
    alterPublicMailboxValidationOk() {
      this.loading.alterPublicMailbox = false;
      // hide modal after validation
      this.$emit("hide");
    },
    alterPublicMailboxValidationFailed(validationErrors) {
      this.loading.alterPublicMailbox = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;
        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "mailboxes." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    alterPublicMailboxCompleted() {
      this.loading.alterPublicMailbox = false;
      this.clearFields();

      // reload mailboxes
      this.$emit("mailboxAltered");
    },
    async listAclSubjects() {
      this.mailboxes = [];
      const taskAction = "list-acl-subjects";
      const eventId = this.getUuid();
      this.loading.listAclSubjects = true;

      // register to task events
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listAclSubjectsAborted
      );

      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listAclSubjectsCompleted
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
        const errMessage = this.getErrorMessage(err);
        this.error.listAclSubjects = errMessage;
        this.loading.listAclSubjects = false;
      }
    },
    listAclSubjectsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listAclSubjects = this.$t("error.generic_error");
      this.loading.listAclSubjects = false;
    },
    listAclSubjectsCompleted(taskContext, taskResult) {
      this.allAclSubjects = taskResult.output;
      this.allAclSubjectsForUi = this.allAclSubjects.map((d) => {
        return {
          name: d.name,
          value: `${d.name}_${d.dtype}`,
          label: d.name,
          type: this.$t(`common.${d.dtype}_destination`),
          description: d.ui_name,
        };
      });

      if (this.isEditing) {
        const selectedSubjects = [];

        for (const a of this.mailbox.acls) {
          const aclSubject = a.subject;

          const subjectFound = this.allAclSubjectsForUi.find((aui) => {
            return aui.value.toLowerCase() === `${aclSubject.name}_${aclSubject.dtype}`.toLowerCase();
          });

          if (subjectFound) {
            selectedSubjects.push(subjectFound.value);
          } else {
            // apo (account provider object, e.g. a deleted user)

            selectedSubjects.push(aclSubject.name);
            this.allAclSubjectsForUi.push({
              name: aclSubject.name,
              value: aclSubject.name,
              label: aclSubject.name,
              type: this.$t(`common.missing_object`),
            });
          }
        }
        this.$nextTick(() => {
          this.selectedAclSubjects = selectedSubjects;
        });
      }
      this.loading.listAclSubjects = false;
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.mg-bottom-14 {
  margin-bottom: 14rem;
}
</style>
