<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column class="page-title">
          <h2>
            {{ $t("queue.title") }}
            <cv-interactive-tooltip
              alignment="start"
              direction="right"
              class="tooltip info mg-left-sm"
            >
              <template slot="trigger"></template>
              <template slot="content">
                <div v-html="$t('queue.queue_tooltip')"></div>
              </template>
            </cv-interactive-tooltip>
          </h2>
        </cv-column>
        <cv-column :md="4" :xlg="6">
          <div class="page-toolbar">
            <NsButton
              kind="tertiary"
              size="field"
              :icon="Settings20"
              @click="goToQueueSettings()"
              class="page-toolbar-item"
              >{{ $t("mailboxes.settings") }}</NsButton
            >
          </div>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <NsInlineNotification
            kind="warning"
            :title="core.$t('common.use_landscape_mode')"
            :description="core.$t('common.use_landscape_mode_description')"
            class="landscape-warning"
          />
        </cv-column>
      </cv-row>
      <cv-row class="toolbar">
        <cv-column>
          <template>
            <NsButton
              kind="secondary"
              :icon="Restart20"
              @click="listDeferredQueue"
              :disabled="
                loading.listDeferredQueue ||
                loading.setDeleteQueue ||
                loading.getQueueSettings
              "
              >{{ $t("queue.reload_queue") }}
            </NsButton>
          </template>
          <template v-if="queue.length">
            <NsButton
              kind="secondary"
              :icon="Email20"
              class="mg-left"
              @click="setResendQueueAll"
              :disabled="
                loading.listDeferredQueue ||
                loading.setDeleteQueue ||
                loading.getQueueSettings
              "
              >{{ $t("queue.resend_all") }}
            </NsButton>
            <NsButton
              kind="danger"
              class="mg-left"
              :icon="TrashCan20"
              @click="toggleDeleteQueueAll"
              :disabled="
                loading.listDeferredQueue ||
                loading.setDeleteQueue ||
                loading.getQueueSettings
              "
              >{{ $t("queue.delete_all") }}
            </NsButton>
          </template>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <div
            v-if="!loading.getQueueSettings && !loading.listDeferredQueue"
            class="mg-top-sm mg-bottom-lg"
          >
            <NsSvg :svg="InformationFilled16" class="icon ns-info" />
            <span>
              {{
                $t("queue.maximal_queue_lifetime_info", {
                  maximal_queue_lifetime: maximal_queue_lifetime,
                })
              }}
            </span>
          </div>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <NsDataTable
              :allRows="queue"
              :columns="i18nTableColumns"
              :rawColumns="tableColumns"
              :sortable="true"
              :pageSizes="[10, 25, 50, 100]"
              :overflow-menu="true"
              :isSearchable="check_queue"
              :searchPlaceholder="$t('queue.search_queue')"
              :searchClearLabel="core.$t('common.clear_search')"
              :noSearchResultsLabel="core.$t('common.no_search_results')"
              :noSearchResultsDescription="
                core.$t('common.no_search_results_description')
              "
              :isLoading="
                loading.listDeferredQueue ||
                loading.setDeleteQueue ||
                loading.getQueueSettings
              "
              :skeletonRows="5"
              :isErrorShown="!!error.listDeferredQueue"
              :errorTitle="$t('action.report-queue-status')"
              :errorDescription="error.listDeferredQueue"
              :itemsPerPageLabel="core.$t('pagination.items_per_page')"
              :rangeOfTotalItemsLabel="
                core.$t('pagination.range_of_total_items')
              "
              :ofTotalPagesLabel="core.$t('pagination.of_total_pages')"
              :backwardText="core.$t('pagination.previous_page')"
              :forwardText="core.$t('pagination.next_page')"
              :pageNumberLabel="core.$t('pagination.page_number')"
              @updatePage="tablePage = $event"
            >
              <template slot="empty-state">
                <NsEmptyState :title="$t('queue.no_queue')">
                  <template #pictogram>
                    <FaceSatisfiedPictogram />
                  </template>
                </NsEmptyState>
              </template>
              <template slot="data">
                <cv-data-table-row
                  v-for="(row, rowIndex) in queue"
                  :key="`${rowIndex}`"
                  :value="`${rowIndex}`"
                >
                  <cv-data-table-cell>
                    {{ row.queue_id }}
                  </cv-data-table-cell>
                  <cv-data-table-row>
                    <div class="mg-top mg-left gray">
                      {{
                        formatDate(
                          new Date(row.arrival_time * 1000),
                          "yyyy-MM-dd HH.mm"
                        )
                      }}
                    </div>
                  </cv-data-table-row>
                  <cv-data-table-cell>
                    {{ row.sender }}
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    <template v-if="row.recipients.length == 1">
                      {{ row.recipients[0].address }}
                    </template>
                    <template v-else>
                      {{ row.recipients.length + " " + $t("queue.recipients") }}
                    </template>
                  </cv-data-table-cell>
                  <cv-data-table-cell>
                    {{ row.message_size | byteFormat }}
                  </cv-data-table-cell>
                  <cv-data-table-cell class="table-overflow-menu-cell">
                    <cv-overflow-menu
                      flip-menu
                      class="table-overflow-menu"
                      :data-test-id="row.queue_id + '-menu'"
                    >
                      <cv-overflow-menu-item
                        @click="showQueueDetailModal(row)"
                        :data-test-id="row.queue_id + '-details'"
                      >
                        <NsMenuItem
                          :icon="Information20"
                          :label="$t('queue.see_details')"
                        />
                      </cv-overflow-menu-item>
                      <cv-overflow-menu-item
                        @click="setResendQueue(row)"
                        :data-test-id="row.queue_id + '-resend-queue'"
                      >
                        <NsMenuItem
                          :icon="Email20"
                          :label="$t('queue.resend')"
                        />
                      </cv-overflow-menu-item>
                      <cv-overflow-menu-item
                        @click="toggleDeleteQueue(row)"
                        :data-test-id="row.queue_id + '-delete-queue'"
                      >
                        <NsMenuItem
                          :icon="TrashCan20"
                          :label="$t('queue.delete')"
                        />
                      </cv-overflow-menu-item>
                    </cv-overflow-menu>
                  </cv-data-table-cell>
                </cv-data-table-row>
              </template>
            </NsDataTable>
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
    <ShowQueueDetailModal
      :isShown="isShownQueueDetailModal"
      :queue="currentMessage"
      @hide="hideQueueDetailModal"
    />
    <NsDangerDeleteModal
      :isShown="isShownConfirmDeleteQueue"
      :name="currentMessage ? currentMessage.queue_id : ''"
      :title="$t('queue.delete_email')"
      :warning="core.$t('common.please_read_carefully')"
      :description="
        $t('queue.delete_email_confirm', {
          name: currentMessage ? currentMessage.queue_id : '',
        })
      "
      :typeToConfirm="
        core.$t('common.type_to_confirm', {
          name: currentMessage ? currentMessage.queue_id : '',
        })
      "
      :isErrorShown="!!error.setDeleteQueue"
      :errorTitle="$t('action.flush-postfix-queue')"
      :errorDescription="error.setDeleteQueue"
      @hide="hideConfirmDeleteQueue"
      @confirmDelete="setDeleteQueue(false)"
    >
      <template slot="explanation">
        <p
          class="mg-top-sm"
          v-html="$t('queue.confirm_delete_queued_message')"
        ></p>
        <p
          class="mg-top-sm"
          v-html="core.$t('common.this_action_is_not_reversible')"
        ></p>
      </template>
    </NsDangerDeleteModal>
    <NsDangerDeleteModal
      :isShown="isShownConfirmDeleteQueueAll"
      :name="delete_all"
      :title="$t('queue.delete_queue')"
      :warning="core.$t('common.please_read_carefully')"
      :description="$t('queue.confirm_delete_all_queued_message')"
      :typeToConfirm="core.$t('common.type_to_confirm', { name: delete_all })"
      :isErrorShown="!!error.setDeleteQueueAll"
      :errorTitle="$t('action.flush-postfix-queue')"
      :errorDescription="error.setDeleteQueueAll"
      @hide="hideConfirmDeleteQueueAll"
      @confirmDelete="setDeleteQueueAll(false)"
    >
      <template slot="explanation">
        <p
          class="mg-top-sm"
          v-html="core.$t('common.this_action_is_not_reversible')"
        ></p>
      </template>
    </NsDangerDeleteModal>
  </div>
</template>

<script>
import { mapState } from "vuex";
import {
  QueryParamService,
  UtilService,
  IconService,
  TaskService,
  DateTimeService,
} from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import ShowQueueDetailModal from "@/components/ShowQueueDetailModal";
export default {
  name: "DeferredQueue",
  components: {
    ShowQueueDetailModal,
  },
  mixins: [
    QueryParamService,
    UtilService,
    IconService,
    TaskService,
    DateTimeService,
  ],
  pageTitle() {
    return this.$t("queue.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "deferredQueue",
      },
      urlCheckInterval: null,
      tablePage: [],
      tableColumns: [
        "queue_id",
        "arrival_time",
        "sender",
        "recipients",
        "message_size",
      ],
      queue: [],
      check_queue: false,
      maximal_queue_lifetime: "120",
      isShownConfirmDeleteQueue: false,
      isShownConfirmDeleteQueueAll: false,
      isShownQueueDetailModal: false,
      currentMessage: {
        queue_id: "",
        arrival_time: 0,
        message_size: 0,
        sender: "",
        recipients: [],
      },
      delete_all: "delete",
      isShowQueueDetailModal: false,
      loading: {
        listDeferredQueue: false,
        setDeleteQueue: false,
        setResendQueue: false,
        setResendQueueAll: false,
        setDeleteQueueAll: false,
        getQueueSettings: false,
      },
      error: {
        listDeferredQueue: "",
        setDeleteQueue: "",
        setResendQueue: "",
        setResendQueueAll: "",
        setDeleteQueueAll: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("queue.col_" + column);
      });
    },
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
    this.getQueueSettings();
    this.listDeferredQueue();
  },
  methods: {
    goToQueueSettings() {
      this.goToAppPage(this.instanceName, "settingsQueue");
    },
    showQueueDetailModal(queue) {
      this.currentMessage = queue;
      this.isShownQueueDetailModal = true;
    },
    hideQueueDetailModal() {
      this.isShownQueueDetailModal = false;
    },
    async getQueueSettings() {
      this.loading.getQueueSettings = true;
      this.error.getQueueSettings = "";
      const taskAction = "get-queue-settings";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getQueueSettingsAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getQueueSettingsCompleted
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
        this.error.getQueueSettings = this.getErrorMessage(err);
        this.loading.getQueueSettings = false;
        return;
      }
    },
    getQueueSettingsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getQueueSettings = this.$t("error.generic_error");
      this.loading.getQueueSettings = false;
    },
    getQueueSettingsCompleted(taskContext, taskResult) {
      this.loading.getQueueSettings = false;
      this.maximal_queue_lifetime = taskResult.output.maximal_queue_lifetime;
    },
    async listDeferredQueue() {
      this.queue = [];
      const taskAction = "report-queue-status";
      const eventId = this.getUuid();
      this.loading.listDeferredQueue = true;

      // register to task events

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listDeferredQueueAborted
      );

      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listDeferredQueueCompleted
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
        this.error.listDeferredQueue = errMessage;
        this.loading.listDeferredQueue = false;
      }
    },
    listDeferredQueueAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listDeferredQueue = this.$t("error.generic_error");
      this.loading.listDeferredQueue = false;
    },
    listDeferredQueueCompleted(taskContext, taskResult) {
      // We want only deferred status in queue
      this.queue = taskResult.output.queue_status.filter(function (u) {
        return u.queue_name == "deferred";
      });
      this.check_queue = this.queue.length ? true : false;
      this.loading.listDeferredQueue = false;
    },
    toggleDeleteQueueAll() {
      this.showConfirmDeleteQueueAll();
    },
    showConfirmDeleteQueueAll() {
      this.isShownConfirmDeleteQueueAll = true;
    },
    hideConfirmDeleteQueueAll() {
      this.isShownConfirmDeleteQueueAll = false;
    },
    toggleDeleteQueue(queue) {
      this.currentMessage = queue;
      this.showConfirmDeleteQueue();
    },
    showConfirmDeleteQueue() {
      this.isShownConfirmDeleteQueue = true;
    },
    hideConfirmDeleteQueue() {
      this.isShownConfirmDeleteQueue = false;
    },
    async setDeleteQueue() {
      this.loading.setDeleteQueue = true;
      this.error.setDeleteQueue = "";
      const taskAction = "flush-postfix-queue";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setDeleteQueueAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setDeleteQueueCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            queue: this.currentMessage.queue_id,
            action: "delete",
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
        this.error.setDeleteQueue = this.getErrorMessage(err);
        this.loading.setDeleteQueue = false;
        return;
      }
      this.hideConfirmDeleteQueue();
    },
    setDeleteQueueAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setDeleteQueue = this.$t("error.generic_error");
      this.loading.setDeleteQueue = false;
    },
    setDeleteQueueCompleted() {
      this.loading.setDeleteQueue = false;
      this.listDeferredQueue();
    },
    async setResendQueue(row) {
      this.loading.setResendQueue = true;
      this.error.setResendQueue = "";
      const taskAction = "flush-postfix-queue";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setResendQueueAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setResendQueueCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            queue: row.queue_id,
            action: "resend",
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
        this.error.setResendQueue = this.getErrorMessage(err);
        this.loading.setResendQueue = false;
        return;
      }
    },
    setResendQueueAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setResendQueue = this.$t("error.generic_error");
      this.loading.setResendQueue = false;
    },
    setResendQueueCompleted() {
      this.loading.setResendQueue = false;
      this.listDeferredQueue();
    },
    async setResendQueueAll() {
      this.loading.setResendQueue = true;
      this.error.setResendQueue = "";
      const taskAction = "flush-postfix-queue";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setResendQueueAllAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setResendQueueAllCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            queue: "resend_all",
            action: "resend_all",
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
        this.error.setResendQueueAll = this.getErrorMessage(err);
        this.loading.setResendQueueAll = false;
        return;
      }
    },
    setResendQueueAllAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setResendQueueAll = this.$t("error.generic_error");
      this.loading.setResendQueueAll = false;
    },
    setResendQueueAllCompleted() {
      this.loading.setResendQueueAll = false;
      this.listDeferredQueue();
    },
    async setDeleteQueueAll() {
      this.loading.setDeleteQueueAll = true;
      this.error.setDeleteQueueAll = "";
      const taskAction = "flush-postfix-queue";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setDeleteQueueAllAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setDeleteQueueAllCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            queue: "delete_all",
            action: "delete_all",
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
        this.error.setDeleteQueueAll = this.getErrorMessage(err);
        this.loading.setDeleteQueueAll = false;
        return;
      }
    },
    setDeleteQueueAllAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setDeleteQueueAll = this.$t("error.generic_error");
      this.loading.setDeleteQueueAll = false;
    },
    setDeleteQueueAllCompleted() {
      this.loading.setDeleteQueueAll = false;
      this.hideConfirmDeleteQueueAll();
      this.listDeferredQueue();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.quota-stats {
  font-size: 90%;
  display: flex;
  justify-content: space-between;
}
.mg-top {
  margin-top: 1em;
}
.mg-left {
  margin-left: 1em;
}
.gray {
  color: #525252;
}
</style>
