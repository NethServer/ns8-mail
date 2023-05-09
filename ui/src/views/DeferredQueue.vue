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
              :disabled="loading.listDeferredQueue || loading.setDeleteQueue"
              >{{ $t("queue.reload_queue") }}
            </NsButton>
          </template>
          <template v-if="deferred_queue.length">
            <NsButton
              kind="secondary"
              :icon="Email20"
              class="mg-left"
              @click="setResendQueueAll"
              :disabled="loading.listDeferredQueue || loading.setDeleteQueue"
              >{{ $t("queue.resend_all") }}
            </NsButton>
            <NsButton
              kind="danger"
              class="mg-left"
              :icon="TrashCan20"
              @click="toggleDeleteQueueAll"
              :disabled="loading.listDeferredQueue || loading.setDeleteQueue"
              >{{ $t("queue.delete_all") }}
            </NsButton>
          </template>
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <NsDataTable
            :allRows="queue"
            :columns="i18nTableColumns"
            :rawColumns="tableColumns"
            :sortable="true"
            :pageSizes="[10, 25, 50, 100]"
            :overflow-menu="true"
            isSearchable
            :searchPlaceholder="$t('queue.search_queue')"
            :searchClearLabel="core.$t('common.clear_search')"
            :noSearchResultsLabel="core.$t('common.no_search_results')"
            :noSearchResultsDescription="
              core.$t('common.no_search_results_description')
            "
            :isLoading="loading.listDeferredQueue || loading.setDeleteQueue"
            :skeletonRows="5"
            :isErrorShown="!!error.listDeferredQueue"
            :errorTitle="$t('action.report-queue-status')"
            :errorDescription="error.listDeferredQueue"
            :itemsPerPageLabel="core.$t('pagination.items_per_page')"
            :rangeOfTotalItemsLabel="core.$t('pagination.range_of_total_items')"
            :ofTotalPagesLabel="core.$t('pagination.of_total_pages')"
            :backwardText="core.$t('pagination.previous_page')"
            :forwardText="core.$t('pagination.next_page')"
            :pageNumberLabel="core.$t('pagination.page_number')"
            @updatePage="tablePage = $event"
          >
            <template slot="empty-state">
              <NsEmptyState :title="$t('queue.no_queue')">
                <template #description>
                  <div>
                    {{ $t("queue.no_queue_description") }}
                  </div>
                </template>
              </NsEmptyState>
            </template>
            <template slot="data">
              <cv-data-table-row
                v-for="(row, rowIndex) in deferred_queue"
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
                      <NsMenuItem :icon="Email20" :label="$t('queue.resend')" />
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
        </cv-column>
      </cv-row>
    </cv-grid>
    <ShowQueueDetailModal
      :isShown="isShownQueueDetailModal"
      :queue="currentQueue"
      @hide="hideQueueDetailModal"
    />
    <ConfirmDeleteQueueModal
      :isShown="isShownConfirmDeleteQueue"
      :queue="currentQueue"
      :core="core"
      @hide="hideConfirmDeleteQueue"
      @confirm="setDeleteQueue(false)"
    />
    <ConfirmDeleteQueueAllModal
      :isShown="isShownConfirmDeleteQueueAll"
      :core="core"
      @hide="hideConfirmDeleteQueueAll"
      @confirm="setDeleteQueueAll(false)"
    />
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
import ConfirmDeleteQueueModal from "@/components/ConfirmDeleteQueueModal";
import ConfirmDeleteQueueAllModal from "@/components/ConfirmDeleteQueueAllModal";
export default {
  name: "DeferredQueue",
  components: {
    ShowQueueDetailModal,
    ConfirmDeleteQueueModal,
    ConfirmDeleteQueueAllModal,
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
      isShownConfirmDeleteQueue: false,
      isShownConfirmDeleteQueueAll: false,
      isShownQueueDetailModal: false,
      currentQueue: {
        queue_id: "",
        arrival_time: 0,
        message_size: 0,
        sender: "",
        recipients: [],
      },
      isShowQueueDetailModal: false,
      loading: {
        listDeferredQueue: false,
        setDeleteQueue: false,
        setResendQueue: false,
        setResendQueueAll: false,
        setDeleteQueueAll: false,
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
    // we do not want active queue, after timeout active become deferred
    deferred_queue() {
      return this.tablePage.filter(function (u) {
        return u.queue_name == "deferred";
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
    this.listDeferredQueue();
  },
  methods: {
    showQueueDetailModal(queue) {
      this.currentQueue = queue;
      this.isShownQueueDetailModal = true;
    },
    hideQueueDetailModal() {
      this.isShownQueueDetailModal = false;
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
      this.queue = taskResult.output.queue_status;
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
      this.currentQueue = queue;
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
            queue: this.currentQueue.queue_id,
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
