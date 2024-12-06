<!--
  Copyright (C) 2024 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <NsWizard
    size="default"
    :visible="isShown"
    :cancelLabel="$t('common.cancel')"
    :previousLabel="$t('common.previous')"
    :nextLabel="isLastStep ? $t('mailboxes.restore') : $t('common.next')"
    :isPreviousDisabled="isFirstStep || loading.restoreBackupContent"
    :isNextDisabled="isNextButtonDisabled"
    :isNextLoading="loading.restoreBackupContent"
    @modal-shown="onModalShown"
    @modal-hidden="$emit('hide')"
    @cancel="$emit('hide')"
    @previousStep="previousStep"
    @nextStep="nextStep"
  >
    <template slot="title">{{
      mailboxKind === "user"
        ? $t("mailboxes.restore_folder_for_user_name", {
            name: mailboxName,
          })
        : $t("mailboxes.restore_public_mailbox_name", {
            name: mailboxName,
          })
    }}</template>
    <template slot="content">
      <cv-form @submit.prevent="nextStep">
        <template v-if="step == 'repository'">
          <div class="mg-bottom-md">
            {{ $t("mailboxes.select_backup_destination") }}
          </div>
          <!-- listBackupRepositories error -->
          <NsInlineNotification
            v-if="error.listBackupRepositories"
            kind="error"
            :title="$t('action.list-backup-repositories')"
            :description="error.listBackupRepositories"
            :showCloseButton="false"
          />
          <cv-grid class="mg-top-lg mg-bottom-md no-padding">
            <cv-row>
              <cv-column>
                <BackupRepositorySelector
                  v-model="selectedRepositoryId"
                  :repositories="backupRepositories"
                  :instanceName="instanceName"
                  :loading="loading.listBackupRepositories"
                  :light="true"
                />
              </cv-column>
            </cv-row>
          </cv-grid>
        </template>
        <template v-if="step == 'snapshot'">
          <div>
            {{ $t("mailboxes.select_backup_snapshot") }}
          </div>
          <!-- readBackupSnapshots error -->
          <NsInlineNotification
            v-if="error.readBackupSnapshots"
            kind="error"
            :title="$t('action.read-backup-snapshots')"
            :description="error.readBackupSnapshots"
            :showCloseButton="false"
          />
          <cv-grid class="mg-top-lg mg-bottom-md no-padding">
            <cv-row>
              <cv-column>
                <BackupSnapshotSelector
                  v-model="selectedSnapshotId"
                  :snapshots="backupSnapshots"
                  :loading="loading.readBackupSnapshots"
                  :light="true"
                />
              </cv-column>
            </cv-row>
          </cv-grid>
        </template>
        <template v-if="step == 'folder'">
          <div>
            {{ $t("mailboxes.select_folder_to_restore") }}
          </div>
          <NsComboBox
            v-model="selectedFolder"
            :label="
              loading.seekSnapshotContents
                ? core.$t('common.loading')
                : $t('mailboxes.search_folder')
            "
            :auto-filter="true"
            :auto-highlight="true"
            :options="folderOptions"
            :disabled="loading.seekSnapshotContents"
            light
            ref="folder"
            class="mg-top-lg"
          />
          <!-- seekSnapshotContents error -->
          <NsInlineNotification
            v-if="error.seekSnapshotContents"
            kind="error"
            :title="$t('action.seek-snapshot-contents')"
            :description="error.seekSnapshotContents"
            :showCloseButton="false"
          />
          <NsInlineNotification
            kind="info"
            :description="
              $t('mailboxes.restore_folder_info', {
                restoredFolder: 'Restored folder',
              })
            "
            :showCloseButton="false"
            class="mb-9"
          />
          <!-- restoreBackupContent error -->
          <NsInlineNotification
            v-if="error.restoreBackupContent"
            kind="error"
            :title="$t('action.restore-backup-content')"
            :description="error.restoreBackupContent"
            :showCloseButton="false"
          />
        </template>
      </cv-form>
    </template>
  </NsWizard>
</template>

<script>
import { UtilService, TaskService, IconService } from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import { mapState } from "vuex";
import BackupRepositorySelector from "./BackupRepositorySelector.vue";
import BackupSnapshotSelector from "./BackupSnapshotSelector.vue";

export default {
  name: "RestoreFolderModal",
  components: {
    BackupRepositorySelector,
    BackupSnapshotSelector,
  },
  mixins: [UtilService, TaskService, IconService],
  props: {
    isShown: {
      type: Boolean,
      default: true,
    },
    mailbox: Object,
    mailboxKind: {
      type: String,
      required: true,
      validator: (val) => ["user", "public"].includes(val),
    },
  },
  data() {
    return {
      step: "",
      backupRepositories: [],
      backupSnapshots: [],
      selectedRepositoryId: "",
      selectedSnapshotId: "",
      selectedFolder: "",
      folderOptions: [],
      loading: {
        listBackupRepositories: true,
        restoreBackupContent: false,
        readBackupSnapshots: false,
        seekSnapshotContents: false,
      },
      error: {
        listBackupRepositories: "",
        restoreBackupContent: "",
        readBackupSnapshots: "",
        seekSnapshotContents: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
    steps() {
      return this.mailboxKind === "user"
        ? ["repository", "snapshot", "folder"]
        : ["repository", "snapshot"];
    },
    stepIndex() {
      return this.steps.indexOf(this.step);
    },
    isFirstStep() {
      return this.stepIndex == 0;
    },
    isLastStep() {
      return this.stepIndex == this.steps.length - 1;
    },
    isNextButtonDisabled() {
      return (
        this.loading.restoreBackupContent ||
        (this.step == "repository" && !this.selectedRepositoryId) ||
        (this.step == "snapshot" && !this.selectedSnapshotId) ||
        (this.step == "folder" && !this.selectedFolder)
      );
    },
    selectedRepository() {
      return this.backupRepositories.find(
        (repo) => repo.repository_id === this.selectedRepositoryId
      );
    },
    mailboxName() {
      if (!this.mailbox) {
        return "";
      }
      return this.mailboxKind === "user"
        ? this.mailbox.user
        : this.mailbox.mailbox;
    },
  },
  watch: {
    step: function () {
      if (this.step == "repository") {
        this.selectedRepositoryId = "";
      } else if (this.step == "snapshot") {
        this.selectedSnapshotId = "";
        this.readBackupSnapshots();
      } else if (this.step == "folder") {
        this.selectedFolder = "";
        this.seekSnapshotContents();
      }
    },
  },
  methods: {
    nextStep() {
      if (this.isNextButtonDisabled) {
        return;
      }

      if (this.isLastStep) {
        this.restoreBackupContent();
      } else {
        this.step = this.steps[this.stepIndex + 1];
      }
    },
    previousStep() {
      if (!this.isFirstStep) {
        this.step = this.steps[this.stepIndex - 1];
      }
    },
    onModalShown() {
      // show first step
      this.step = this.steps[0];
      this.selectedRepositoryId = "";
      this.listBackupRepositories();
    },
    async listBackupRepositories() {
      this.loading.listBackupRepositories = true;
      this.error.listBackupRepositories = "";
      const taskAction = "list-backup-repositories";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listBackupRepositoriesAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listBackupRepositoriesCompleted
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
        this.error.listBackupRepositories = this.getErrorMessage(err);
        this.loading.listBackupRepositories = false;
        return;
      }
    },
    listBackupRepositoriesAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listBackupRepositories = this.$t("error.generic_error");
      this.loading.listBackupRepositories = false;
    },
    listBackupRepositoriesCompleted(taskContext, taskResult) {
      let backupRepositories = taskResult.output;

      // sort repositories by name
      backupRepositories.sort(this.sortByProperty("repository_name"));
      this.backupRepositories = backupRepositories;

      // select the first repository if there is only one
      if (this.backupRepositories.length == 1) {
        this.selectedRepositoryId = this.backupRepositories[0].repository_id;
      }
      this.loading.listBackupRepositories = false;
    },
    async readBackupSnapshots() {
      this.error.readBackupSnapshots = "";
      this.loading.readBackupSnapshots = true;
      const taskAction = "read-backup-snapshots";

      // register to task error
      this.core.$root.$off(taskAction + "-aborted");
      this.core.$root.$once(
        taskAction + "-aborted",
        this.readBackupSnapshotsAborted
      );

      // register to task completion
      this.core.$root.$off(taskAction + "-completed");
      this.core.$root.$once(
        taskAction + "-completed",
        this.readBackupSnapshotsCompleted
      );

      const res = await to(
        this.createClusterTaskForApp({
          action: taskAction,
          data: {
            repository: this.selectedRepositoryId,
            path: this.selectedRepository.path,
          },
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.readBackupSnapshots = this.getErrorMessage(err);
        this.loading.readBackupSnapshots = false;
        return;
      }
    },
    readBackupSnapshotsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.readBackupSnapshots = this.$t("error.generic_error");
      this.loading.readBackupSnapshots = false;
    },
    readBackupSnapshotsCompleted(taskContext, taskResult) {
      let snapshots = taskResult.output;

      // sort snapshots by timestamp descending (most recent first)
      snapshots.sort(this.sortByProperty("timestamp")).reverse();
      this.backupSnapshots = snapshots;

      // select the first snapshot if there is only one
      if (this.backupSnapshots.length == 1) {
        this.selectedSnapshotId = this.backupSnapshots[0].id;
      }
      this.loading.readBackupSnapshots = false;
    },
    async restoreBackupContent() {
      this.loading.restoreBackupContent = true;
      this.error.restoreBackupContent = "";
      const taskAction = "restore-backup-content";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.restoreBackupContentAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.restoreBackupContentCompleted
      );

      const payload = {
        destination: this.selectedRepositoryId,
        repopath: this.selectedRepository.path,
        snapshot: this.selectedSnapshotId,
      };

      if (this.mailboxKind === "user") {
        payload.user = this.mailbox.user;
        payload.folder = this.selectedFolder;
      } else {
        payload.user = "vmail";
        payload.folder = this.mailbox.mailbox;
      }

      const taskDescription =
        this.mailboxKind === "user"
          ? this.$t("mailboxes.restoring_mail_folder_for_user", {
              name: this.mailboxName,
            })
          : this.$t("mailboxes.restoring_public_mailbox_name", {
              name: this.mailboxName,
            });

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,

          data: payload,
          extra: {
            title: this.$t("action." + taskAction),
            description: taskDescription,
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.restoreBackupContent = this.getErrorMessage(err);
        this.loading.restoreBackupContent = false;
        return;
      }

      // close modal immediately, no validation needed
      this.$emit("hide");
      this.loading.restoreBackupContent = false;
      this.searchQuery = "";
    },
    restoreBackupContentAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.restoreBackupContent = this.$t("error.generic_error");
      this.loading.restoreBackupContent = false;
    },
    restoreBackupContentCompleted(taskContext, taskResult) {
      if (taskResult.output.quota_disabled) {
        // show a warning notification
        const notification = {
          id: this.getUuid(),
          title: this.$t("mailboxes.mailbox_quota_changed"),
          description: this.$t("mailboxes.mailbox_quota_changed_description", {
            user: this.mailboxName,
          }),
          type: "warning",
          toastTimeout: 0,
          actionLabel: this.$t("mailboxes.go_to_mailboxes"),
          action: {
            type: "callback",
            callback: () => {
              this.goToAppPage(this.instanceName, "mailboxes", {
                view: "user-mailboxes",
              });
            },
          },
        };

        setTimeout(() => {
          this.createNotificationForApp(notification);
        }, 3000);
      }

      this.loading.restoreBackupContent = false;
    },
    async seekSnapshotContents() {
      this.loading.seekSnapshotContents = true;
      this.error.seekSnapshotContents = "";
      const taskAction = "seek-snapshot-contents";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.seekSnapshotContentsAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.seekSnapshotContentsCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            destination: this.selectedRepositoryId,
            user: this.mailbox.user,
            repopath: this.selectedRepository.path,
            snapshot: this.selectedSnapshotId,
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
        this.error.seekSnapshotContents = this.getErrorMessage(err);
        this.loading.seekSnapshotContents = false;
        return;
      }
    },
    seekSnapshotContentsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.seekSnapshotContents = this.$t("error.generic_error");
      this.loading.seekSnapshotContents = false;
    },
    seekSnapshotContentsCompleted(taskContext, taskResult) {
      this.folderOptions = taskResult.output.folders.map((folder) => ({
        name: folder,
        label: folder,
        value: folder,
      }));
      this.loading.seekSnapshotContents = false;
    },
  },
};
</script>

<style scoped lang="scss">
.mb-9 {
  margin-bottom: 9rem;
}
</style>
