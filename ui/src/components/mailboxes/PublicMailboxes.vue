<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid class="no-padding">
      <cv-row class="toolbar">
        <cv-column>
          <NsButton
            kind="secondary"
            :icon="Add20"
            @click="showCreatePublicMailboxModal"
            >{{ $t("mailboxes.create_public_mailbox") }}
          </NsButton>
        </cv-column>
      </cv-row>
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
            :searchPlaceholder="$t('mailboxes.search_public_mailbox')"
            :searchClearLabel="core.$t('common.clear_search')"
            :noSearchResultsLabel="core.$t('common.no_search_results')"
            :noSearchResultsDescription="
              core.$t('common.no_search_results_description')
            "
            :isLoading="loading.listPublicMailboxes"
            :skeletonRows="5"
            :isErrorShown="!!error.listPublicMailboxes"
            :errorTitle="$t('action.list-public-mailboxes')"
            :errorDescription="error.listPublicMailboxes"
            :itemsPerPageLabel="core.$t('pagination.items_per_page')"
            :rangeOfTotalItemsLabel="core.$t('pagination.range_of_total_items')"
            :ofTotalPagesLabel="core.$t('pagination.of_total_pages')"
            :backwardText="core.$t('pagination.previous_page')"
            :forwardText="core.$t('pagination.next_page')"
            :pageNumberLabel="core.$t('pagination.page_number')"
            @updatePage="tablePage = $event"
          >
            <template slot="empty-state">
              <NsEmptyState :title="$t('mailboxes.no_public_mailbox')">
                <template #description>
                  <div>
                    {{ $t("mailboxes.no_public_mailbox_description") }}
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
                  <span>{{ row.mailbox }}</span>
                </cv-data-table-cell>
                <cv-data-table-cell>
                  <cv-interactive-tooltip
                    v-for="(acl, index) in row.acls"
                    :key="index"
                    alignment="center"
                    direction="top"
                    class="tooltip-with-text-trigger info"
                  >
                    <template slot="trigger">
                      <div class="icon-and-text-inline mg-right-md">
                        <span class="icon">
                          <NsSvg
                            v-if="acl.subject.dtype == 'user'"
                            :svg="User16"
                          />
                          <NsSvg
                            v-else-if="acl.subject.dtype == 'group'"
                            :svg="Events16"
                          />
                          <NsSvg
                            v-else-if="acl.subject.dtype == 'public'"
                            :svg="Box16"
                          />
                          <NsSvg
                            v-else-if="acl.subject.dtype == 'external'"
                            :svg="Email16"
                          />
                          <!-- apo or unknown type -->
                          <NsSvg v-else :svg="Unknown16" />
                        </span>
                        <span>{{
                          acl.subject.ui_name || acl.subject.name
                        }}</span>
                      </div>
                    </template>
                    <template slot="content">
                      <div>
                        <h6 class="mg-bottom-sm">
                          {{ $t(`mailboxes.rtype_${acl.rights.rtype}`) }}
                        </h6>
                        <code class="rights-values">
                          {{ acl.rights.values.join(", ") }}
                        </code>
                      </div>
                    </template>
                  </cv-interactive-tooltip>
                </cv-data-table-cell>
                <cv-data-table-cell class="table-overflow-menu-cell">
                  <cv-overflow-menu
                    flip-menu
                    class="table-overflow-menu"
                    :data-test-id="row.mailbox + '-menu'"
                  >
                    <cv-overflow-menu-item
                      @click="showEditPublicMailboxModal(row)"
                      :data-test-id="row.mailbox + '-edit'"
                    >
                      <NsMenuItem
                        :icon="Edit20"
                        :label="core.$t('common.edit')"
                      />
                    </cv-overflow-menu-item>
                    <NsMenuDivider />
                    <cv-overflow-menu-item
                      danger
                      @click="showDeleteMailboxModal(row)"
                    >
                      <NsMenuItem
                        :icon="TrashCan20"
                        :label="core.$t('common.delete')"
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
    <!-- create or edit mailbox modal -->
    <CreateOrEditPublicMailboxModal
      :isShown="isShownCreateOrEditPublicMailboxModal"
      :isEditing="isEditingMailbox"
      :mailbox="currentMailbox"
      @hide="hideCreateOrEditPublicMailboxModal"
      @mailboxAdded="listPublicMailboxes"
      @mailboxAltered="listPublicMailboxes"
    />
    <!-- delete public mailbox modal -->
    <NsDangerDeleteModal
      :isShown="isShownDeleteMailboxModal"
      :name="currentMailbox ? currentMailbox.mailbox : ''"
      :title="$t('mailboxes.delete_public_mailbox')"
      :warning="core.$t('common.please_read_carefully')"
      :description="
        $t('mailboxes.delete_public_mailbox_confirm', {
          name: currentMailbox ? currentMailbox.mailbox : '',
        })
      "
      :typeToConfirm="
        core.$t('common.type_to_confirm', {
          name: currentMailbox ? currentMailbox.mailbox : '',
        })
      "
      :isErrorShown="!!error.removePublicMailbox"
      :errorTitle="$t('action.remove-public-mailbox')"
      :errorDescription="error.removePublicMailbox"
      @hide="hideDeleteMailboxModal"
      @confirmDelete="removePublicMailbox"
    >
      <template slot="explanation">
        <p class="mg-top-sm">
          {{ $t("mailboxes.delete_public_mailbox_explanation") }}
        </p>
        <p class="mg-top-sm">
          {{ core.$t("common.this_action_is_not_reversible") }}
        </p>
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
} from "@nethserver/ns8-ui-lib";
import to from "await-to-js";
import CreateOrEditPublicMailboxModal from "./CreateOrEditPublicMailboxModal";

export default {
  name: "PublicMailboxes",
  components: { CreateOrEditPublicMailboxModal },
  mixins: [QueryParamService, UtilService, IconService, TaskService],
  data() {
    return {
      currentMailbox: null,
      isEditingMailbox: false,
      tablePage: [],
      tableColumns: ["mailbox", "acls"],
      mailboxes: [],
      isShownCreateOrEditPublicMailboxModal: false,
      isShownDeleteMailboxModal: false,
      loading: {
        listPublicMailboxes: false,
        alterPublicMailbox: false,
        removePublicMailbox: false,
      },
      error: {
        listPublicMailboxes: "",
        alterPublicMailbox: "",
        removePublicMailbox: "",
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
    this.listPublicMailboxes();
  },
  methods: {
    async listPublicMailboxes() {
      this.mailboxes = [];
      const taskAction = "list-public-mailboxes";
      const eventId = this.getUuid();
      this.loading.listPublicMailboxes = true;

      // register to task events

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listPublicMailboxesAborted
      );

      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listPublicMailboxesCompleted
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
        this.error.listPublicMailboxes = errMessage;
        this.loading.listPublicMailboxes = false;
      }
    },
    listPublicMailboxesAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listPublicMailboxes = this.$t("error.generic_error");
      this.loading.listPublicMailboxes = false;
    },
    listPublicMailboxesCompleted(taskContext, taskResult) {
      this.mailboxes = taskResult.output;
      this.loading.listPublicMailboxes = false;
    },
    showCreatePublicMailboxModal() {
      this.isEditingMailbox = false;
      this.isShownCreateOrEditPublicMailboxModal = true;
    },
    showEditPublicMailboxModal(mailbox) {
      this.isEditingMailbox = true;
      this.currentMailbox = mailbox;
      this.isShownCreateOrEditPublicMailboxModal = true;
    },
    hideCreateOrEditPublicMailboxModal() {
      this.isShownCreateOrEditPublicMailboxModal = false;
    },
    showDeleteMailboxModal(mailbox) {
      this.currentMailbox = mailbox;
      this.isShownDeleteMailboxModal = true;
    },
    hideDeleteMailboxModal() {
      this.isShownDeleteMailboxModal = false;
    },
    async removePublicMailbox() {
      this.loading.removePublicMailbox = true;
      this.error.removePublicMailbox = "";
      const taskAction = "remove-public-mailbox";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.removePublicMailboxAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.removePublicMailboxCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            mailbox: this.currentMailbox.mailbox,
          },
          extra: {
            title: this.$t("mailboxes.delete_public_mailbox_mailbox", {
              mailbox: this.currentMailbox.mailbox,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.removePublicMailbox = this.getErrorMessage(err);
        this.loading.removePublicMailbox = false;
        return;
      }
      this.hideDeleteMailboxModal();
    },
    removePublicMailboxAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.removePublicMailbox = false;
    },
    removePublicMailboxCompleted() {
      this.loading.removePublicMailbox = false;

      // reload mailboxes
      this.listPublicMailboxes();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../../styles/carbon-utils";

.rights-values {
  font-size: 13px;
}
</style>
