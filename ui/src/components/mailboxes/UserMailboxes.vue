<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid class="no-padding">
      <cv-row>
        <cv-column>
          <NsDataTable
            :allRows="mailboxes"
            :columns="i18nTableColumns"
            :rawColumns="tableColumns"
            :sortable="true"
            :pageSizes="[10, 25, 50, 100]"
            :overflow-menu="true"
            isSearchable
            :searchPlaceholder="$t('mailboxes.search_user_mailbox')"
            :searchClearLabel="core.$t('common.clear_search')"
            :noSearchResultsLabel="core.$t('common.no_search_results')"
            :noSearchResultsDescription="
              core.$t('common.no_search_results_description')
            "
            :isLoading="loading.listUserMailboxes || loading.setMailboxEnabled"
            :skeletonRows="5"
            :isErrorShown="!!error.listUserMailboxes"
            :errorTitle="$t('action.list-user-mailboxes')"
            :errorDescription="error.listUserMailboxes"
            :itemsPerPageLabel="core.$t('pagination.items_per_page')"
            :rangeOfTotalItemsLabel="core.$t('pagination.range_of_total_items')"
            :ofTotalPagesLabel="core.$t('pagination.of_total_pages')"
            :backwardText="core.$t('pagination.previous_page')"
            :forwardText="core.$t('pagination.next_page')"
            :pageNumberLabel="core.$t('pagination.page_number')"
            @updatePage="tablePage = $event"
          >
            <template slot="empty-state">
              <NsEmptyState :title="$t('mailboxes.no_user_mailbox')">
                <template #description>
                  <div>
                    {{ $t("mailboxes.no_user_mailbox_description") }}
                  </div>
                </template>
              </NsEmptyState>
            </template>
            <template slot="data">
              <cv-data-table-row
                v-for="(row, rowIndex) in tablePage"
                :key="`${rowIndex}`"
                :value="`${rowIndex}`"
              >
                <cv-data-table-cell>
                  {{ row.user }}
                  <NsTag
                    v-if="row.enabled == false"
                    kind="high-contrast"
                    :label="core.$t('common.disabled')"
                    size="sm"
                  ></NsTag>
                </cv-data-table-cell>
                <cv-data-table-cell>
                  <template v-if="row.quota">
                    <template v-if="row.quota.limit > 0">
                      <div class="quota-stats">
                        <div>{{ row.quota.percent }}%</div>
                        <div>
                          {{
                            $t("mailboxes.value_of_total", {
                              value: $options.filters.mibFormat(
                                row.quota.value
                              ),
                              total: $options.filters.mibFormat(
                                row.quota.limit
                              ),
                            })
                          }}
                        </div>
                      </div>
                      <NsProgressBar
                        :value="row.quota.percent"
                        useStatusColors
                        :useHealthyColor="false"
                      />
                    </template>
                    <template v-else>
                      {{
                        $t("mailboxes.unlimited_quota_using_usage", {
                          usage: $options.filters.mibFormat(row.quota.value),
                        })
                      }}
                    </template>
                  </template>
                </cv-data-table-cell>
                <cv-data-table-cell>
                  <template
                    v-if="
                      row.forward &&
                      row.forward.destinations &&
                      row.forward.destinations.length
                    "
                  >
                    <span
                      v-for="dest in row.forward.destinations"
                      :key="dest.name"
                      class="destination"
                    >
                      <cv-interactive-tooltip
                        alignment="center"
                        direction="top"
                        class="tooltip-with-text-trigger info"
                      >
                        <template slot="trigger">
                          <div class="icon-and-text-inline mg-right-md">
                            <span class="icon">
                              <NsSvg
                                v-if="dest.dtype == 'user'"
                                :svg="User16"
                              />
                              <NsSvg
                                v-else-if="dest.dtype == 'group'"
                                :svg="Events16"
                              />
                              <NsSvg
                                v-else-if="dest.dtype == 'public'"
                                :svg="Box16"
                              />
                              <NsSvg
                                v-else-if="dest.dtype == 'external'"
                                :svg="Email16"
                              />
                              <!-- apo or unknown type -->
                              <NsSvg v-else :svg="Unknown16" />
                            </span>
                            <span>{{ dest.ui_name || dest.name }}</span>
                          </div>
                        </template>
                        <template slot="content">
                          <div>
                            {{ $t(`common.${dest.dtype}_destination`) }}
                          </div>
                        </template>
                      </cv-interactive-tooltip>
                    </span>
                  </template>
                  <template v-else>
                    {{ $t("mailboxes.none") }}
                  </template>
                </cv-data-table-cell>
                <cv-data-table-cell class="table-overflow-menu-cell">
                  <cv-overflow-menu
                    flip-menu
                    class="table-overflow-menu"
                    :data-test-id="row.mailbox + '-menu'"
                  >
                    <cv-overflow-menu-item
                      @click="showEditUserMailboxModal(row)"
                      :data-test-id="row.user + '-edit'"
                    >
                      <NsMenuItem
                        :icon="Edit20"
                        :label="core.$t('common.edit')"
                      />
                    </cv-overflow-menu-item>
                    <cv-overflow-menu-item
                      @click="toggleMailboxEnabled(row)"
                      :data-test-id="row.user + '-set-enabled'"
                    >
                      <NsMenuItem
                        :icon="Power20"
                        :label="
                          row.enabled == false
                            ? core.$t('common.enable')
                            : core.$t('common.disable')
                        "
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
    <!-- edit mailbox modal -->
    <EditUserMailboxModal
      :isShown="isShownEditUserMailboxModal"
      :mailbox="currentMailbox"
      :defaultSpamRetention="defaultSpamRetention"
      @hide="hideEditUserMailboxModal"
      @mailboxAltered="listUserMailboxes"
    />
    <!-- confirm disable mailbox modal -->
    <ConfirmDisableMailboxModal
      :isShown="isShownConfirmDisableMailbox"
      :mailbox="currentMailbox"
      :core="core"
      @hide="hideConfirmDisableMailbox"
      @confirm="setMailboxEnabled(false)"
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
} from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import EditUserMailboxModal from "./EditUserMailboxModal";
import ConfirmDisableMailboxModal from "./ConfirmDisableMailboxModal";

export default {
  name: "UserMailboxes",
  components: { EditUserMailboxModal, ConfirmDisableMailboxModal },
  mixins: [QueryParamService, UtilService, IconService, TaskService],
  data() {
    return {
      currentMailbox: null,
      tablePage: [],
      tableColumns: ["user", "quota", "forward"],
      mailboxes: [],
      isShownEditUserMailboxModal: false,
      defaultSpamRetention: 0,
      isShownConfirmDisableMailbox: false,
      loading: {
        listUserMailboxes: false,
        alterUserMailbox: false,
        setMailboxEnabled: false,
      },
      error: {
        listUserMailboxes: "",
        alterUserMailbox: "",
        setMailboxEnabled: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("mailboxes.col_" + column);
      });
    },
  },
  created() {
    this.listUserMailboxes();
  },
  methods: {
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
      this.defaultSpamRetention =
        taskResult.output.default_spam_retention.value;
      this.mailboxes = taskResult.output.user_mailboxes;
      this.loading.listUserMailboxes = false;
    },
    showEditUserMailboxModal(mailbox) {
      this.currentMailbox = mailbox;
      this.isShownEditUserMailboxModal = true;
    },
    hideEditUserMailboxModal() {
      this.isShownEditUserMailboxModal = false;
    },
    toggleMailboxEnabled(mailbox) {
      this.currentMailbox = mailbox;

      if (mailbox.enabled == false) {
        // enable mailbox
        this.setMailboxEnabled(true);
      } else {
        // disable mailbox
        this.showConfirmDisableMailbox();
      }
    },
    showConfirmDisableMailbox() {
      this.isShownConfirmDisableMailbox = true;
    },
    hideConfirmDisableMailbox() {
      this.isShownConfirmDisableMailbox = false;
    },
    async setMailboxEnabled(isEnabled) {
      this.loading.setMailboxEnabled = true;
      this.error.setMailboxEnabled = "";
      const taskAction = "set-mailbox-enabled";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.setMailboxEnabledAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.setMailboxEnabledCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            user: this.currentMailbox.user,
            enabled: isEnabled,
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
        this.error.setMailboxEnabled = this.getErrorMessage(err);
        this.loading.setMailboxEnabled = false;
        return;
      }
      this.hideConfirmDisableMailbox();
    },
    setMailboxEnabledAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.setMailboxEnabled = this.$t("error.generic_error");
      this.loading.setMailboxEnabled = false;
    },
    setMailboxEnabledCompleted() {
      this.loading.setMailboxEnabled = false;
      this.listUserMailboxes();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.quota-stats {
  font-size: 90%;
  display: flex;
  justify-content: space-between;
}
</style>
