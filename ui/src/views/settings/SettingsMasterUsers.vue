<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column>
        <cv-breadcrumb
          aria-label="breadcrumb"
          :no-trailing-slash="true"
          class="breadcrumb"
        >
          <cv-breadcrumb-item>
            <cv-link @click="goToSettings">{{ $t("settings.title") }}</cv-link>
          </cv-breadcrumb-item>
          <cv-breadcrumb-item>
            <span>{{ $t("settings_master_users.title") }}</span>
          </cv-breadcrumb-item>
        </cv-breadcrumb>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings_master_users.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <div class="title-description mg-bottom-lg">
          {{ $t("settings_master_users.page_description") }}
        </div>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.listUserMailboxes">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.list-user-mailboxes')"
          :description="error.listUserMailboxes"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-if="error.setMasterUsers">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.set-master-users')"
          :description="error.setMasterUsers"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getMasterUsers">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-master-users')"
          :description="error.getMasterUsers"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row v-else>
      <cv-column>
        <cv-tile light>
          <cv-grid fullWidth class="no-padding">
            <cv-row>
              <cv-column>
                <cv-skeleton-text
                  v-if="loading.listUserMailboxes || loading.getMasterUsers"
                  heading
                  paragraph
                  :line-count="5"
                  width="80%"
                ></cv-skeleton-text>
                <cv-form v-else @submit.prevent="setMasterUsers">
                  <NsMultiSelect
                    v-model="selectedMasterUsers"
                    autoFilter
                    autoHighlight
                    :disabled="
                      loading.getMasterUsers ||
                      loading.setMasterUsers ||
                      loading.listUserMailboxes
                    "
                    filterTagKind="high-contrast"
                    :invalidMessage="error.master_users"
                    :title="$t('settings_master_users.master_users')"
                    :label="
                      loading.listUserMailboxes || loading.getMasterUsers
                        ? core.$t('common.loading')
                        : $t('settings_master_users.master_users_placeholder')
                    "
                    selectionFeedback="top-after-reopen"
                    filterable
                    showSelectedItems
                    :unselectAriaLabel="core.$t('common.unselect')"
                    :clearSelectionAriaLabel="core.$t('common.clear_selection')"
                    :clearFilterLabel="core.$t('common.clear_filter')"
                    :selectedLabel="core.$t('common.selected_l')"
                    :acceptUserInput="false"
                    userInputLabel=""
                    :maxDisplayOptions="100"
                    :showItemType="false"
                    :showItemDescription="false"
                    selectedItemsColor="high-contrast"
                    :options="allMailboxesForUi"
                  />
                  <NsButton
                    kind="primary"
                    :icon="Save20"
                    :loading="loading.setMasterUsers"
                    :disabled="
                      loading.getMasterUsers ||
                      loading.setMasterUsers ||
                      loading.listUserMailboxes
                    "
                    >{{ $t("common.save_settings") }}</NsButton
                  >
                </cv-form>
              </cv-column>
            </cv-row>
          </cv-grid>
        </cv-tile>
      </cv-column>
    </cv-row>
  </cv-grid>
</template>

<script>
import to from "await-to-js";
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";
import { mapState } from "vuex";

export default {
  name: "SettingsMasterUsers",
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings_master_users.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settingsMasterUsers",
      },
      urlCheckInterval: null,
      allMailboxesForUi: [],
      selectedMasterUsers: [],
      loading: {
        getMasterUsers: false,
        setMasterUsers: false,
        listUserMailboxes: false,
      },
      error: {
        getMasterUsers: "",
        setMasterUsers: "",
        listUserMailboxes: "",
        master_users: "",
      },
    };
  },
  computed: {
    ...mapState(["core", "appName", "instanceName"]),
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
  created() {
    this.listUserMailboxes();
  },
  methods: {
    goToSettings() {
      this.goToAppPage(this.instanceName, "settings");
    },
    async getMasterUsers() {
      this.loading.getMasterUsers = true;
      this.error.getMasterUsers = "";
      const taskAction = "get-master-users";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getMasterUsersAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getMasterUsersCompleted
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
        this.error.getMasterUsers = this.getErrorMessage(err);
        this.loading.getMasterUsers = false;
        return;
      }
    },
    getMasterUsersAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getMasterUsers = this.$t("error.generic_error");
      this.loading.getMasterUsers = false;
    },
    getMasterUsersCompleted(taskContext, taskResult) {
      this.loading.getMasterUsers = false;
      this.selectedMasterUsers = taskResult.output.master_users;
    },
    async setMasterUsers() {
      this.loading.setMasterUsers = true;
      this.error.setMasterUsers = "";
      const taskAction = "set-master-users";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setMasterUsersAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.setMasterUsersValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setMasterUsersCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            master_users: this.selectedMasterUsers,
          },
          extra: {
            title: this.$t("action." + taskAction),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.setMasterUsers = this.getErrorMessage(err);
        this.loading.setMasterUsers = false;
        return;
      }
    },
    setMasterUsersAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setMasterUsers = this.$t("error.generic_error");
      this.loading.setMasterUsers = false;
    },
    setMasterUsersValidationFailed(validationErrors) {
      this.loading.setMasterUsers = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;

        // set i18n error message
        this.error[param] = this.getI18nStringWithFallback(
          "settings_master_users." + validationError.error,
          "error." + validationError.error,
          this.core
        );

        if (!focusAlreadySet && param != "(root)") {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    setMasterUsersCompleted() {
      this.loading.setMasterUsers = false;

      // reload master users
      this.getMasterUsers();
    },
    async listUserMailboxes() {
      this.mailboxes = [];
      const taskAction = "list-user-mailboxes";
      const eventId = this.getUuid();
      this.loading.listUserMailboxes = true;

      // register to task events

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listUserMailboxesAborted
      );

      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listUserMailboxesCompleted
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
        this.error.listUserMailboxes = errMessage;
        this.loading.listUserMailboxes = false;
      }
    },
    listUserMailboxesAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listUserMailboxes = this.$t("error.generic_error");
      this.loading.listUserMailboxes = false;
    },
    listUserMailboxesCompleted(taskContext, taskResult) {
      const userMailboxes = taskResult.output.user_mailboxes;
      this.allMailboxesForUi = userMailboxes.map((mailbox) => {
        return {
          name: mailbox.user,
          value: mailbox.user,
          label: mailbox.user,
        };
      });
      this.loading.listUserMailboxes = false;
      this.getMasterUsers();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.page-title {
  margin-bottom: 0;
}
</style>