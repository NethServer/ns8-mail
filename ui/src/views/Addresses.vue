<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column class="page-title">
          <h2>{{ $t("addresses.title") }}</h2>
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
      <cv-row>
        <cv-column>
          <NsInlineNotification
            v-if="
              q.selectedDomainId &&
              q.selectedDomainId !== 'all' &&
              selectedDomainLabel
            "
            kind="info"
            :title="$t('addresses.addresses_filtered')"
            :description="
              $t('addresses.addresses_filtered_description', {
                domain: selectedDomainLabel,
              })
            "
            :actionLabel="$t('addresses.show_all')"
            @action="showAllDomains"
            :showCloseButton="false"
          />
        </cv-column>
      </cv-row>
      <cv-row>
        <cv-column>
          <cv-tile light>
            <cv-grid class="no-padding">
              <cv-row>
                <cv-column :md="4">
                  <cv-combo-box
                    v-model="q.selectedDomainId"
                    :label="core.$t('common.choose')"
                    :title="core.$t('common.show')"
                    :auto-filter="true"
                    :auto-highlight="true"
                    :options="addressesForFilter"
                    :disabled="loading.listInstalledModules"
                    class="mg-bottom-xlg"
                  >
                  </cv-combo-box>
                </cv-column>
              </cv-row>
              <cv-row class="toolbar">
                <cv-column>
                  <NsButton
                    kind="secondary"
                    :icon="Add20"
                    @click="showCreateAddressModal"
                    >{{ $t("addresses.create_address") }}
                  </NsButton>
                </cv-column>
              </cv-row>
              <cv-row>
                <cv-column>
                  <NsInlineNotification
                    v-if="error.toggleVisibility"
                    kind="error"
                    :title="$t('action.alter-address')"
                    :description="error.toggleVisibility"
                    :showCloseButton="false"
                  />
                </cv-column>
              </cv-row>
              <cv-row>
                <cv-column>
                  <NsDataTable
                    :allRows="filteredAddresses"
                    :columns="i18nTableColumns"
                    :rawColumns="tableColumns"
                    :sortable="true"
                    :pageSizes="[10, 25, 50, 100]"
                    :overflow-menu="true"
                    isSearchable
                    :searchPlaceholder="$t('addresses.search_address')"
                    :searchClearLabel="core.$t('common.clear_search')"
                    :noSearchResultsLabel="core.$t('common.no_search_results')"
                    :noSearchResultsDescription="
                      core.$t('common.no_search_results_description')
                    "
                    :isLoading="loading.listAddresses"
                    :skeletonRows="5"
                    :isErrorShown="!!error.listAddresses"
                    :errorTitle="$t('action.list-addresses')"
                    :errorDescription="error.listAddresses"
                    :itemsPerPageLabel="core.$t('pagination.items_per_page')"
                    :rangeOfTotalItemsLabel="
                      core.$t('pagination.range_of_total_items')
                    "
                    :ofTotalPagesLabel="core.$t('pagination.of_total_pages')"
                    :backwardText="core.$t('pagination.previous_page')"
                    :forwardText="core.$t('pagination.next_page')"
                    :pageNumberLabel="core.$t('pagination.page_number')"
                    :filterRowsCallback="filterTableRows"
                    @updatePage="tablePage = $event"
                  >
                    <template slot="empty-state">
                      <NsEmptyState :title="$t('addresses.no_address')">
                        <template #description>
                          <div>
                            {{ $t("addresses.no_address_description") }}
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
                          <span>{{
                            getFullAddressList(row).length == 1
                              ? getFullAddressList(row)[0]
                              : row.address
                          }}</span>
                          <cv-interactive-tooltip
                            v-if="row.description"
                            alignment="center"
                            direction="top"
                            class="tooltip-icon info"
                          >
                            <template slot="trigger">
                              <Information16 />
                            </template>
                            <template slot="content">
                              <div>
                                {{ row.description }}
                              </div>
                            </template>
                          </cv-interactive-tooltip>
                        </cv-data-table-cell>
                        <template
                          v-if="getFullAddressList(row).length > 1"
                          slot="expandedContent"
                        >
                          <div
                            v-for="(fullAddress, index) in getFullAddressList(
                              row
                            )"
                            :key="index"
                            class="mg-bottom-sm"
                          >
                            {{ fullAddress }}
                          </div>
                        </template>
                        <cv-data-table-cell>
                          <span class="atype icon-and-text-inline">
                            <span class="icon">
                              <NsSvg
                                v-if="row.atype == 'wildcard'"
                                :svg="Asterisk16"
                              />
                              <NsSvg
                                v-else-if="row.atype == 'domain'"
                                :svg="Email16"
                              />
                              <NsSvg
                                v-else-if="row.atype == 'adduser'"
                                :svg="User16"
                              />
                              <NsSvg
                                v-else-if="row.atype == 'addgroup'"
                                :svg="Events16"
                              />
                            </span>
                            <span>{{ row.type }}</span>
                          </span>
                        </cv-data-table-cell>
                        <cv-data-table-cell>
                          <div
                            v-if="row.destinations && row.destinations.length"
                          >
                            <span
                              v-for="dest in row.destinations"
                              :key="dest.name"
                              class="destination"
                            >
                              <cv-interactive-tooltip
                                alignment="center"
                                direction="top"
                                class="tooltip-with-text-trigger info"
                              >
                                <template slot="trigger">
                                  <span
                                    class="icon-and-text-inline mg-right-md"
                                  >
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
                                        v-else-if="dest.dtype == 'apo'"
                                        :svg="Unknown16"
                                      />
                                      <NsSvg
                                        v-else-if="dest.dtype == 'public'"
                                        :svg="Box16"
                                      />
                                      <NsSvg
                                        v-else-if="dest.dtype == 'external'"
                                        :svg="Email16"
                                      />
                                    </span>
                                    <span>{{ dest.ui_name || dest.name }}</span>
                                  </span>
                                </template>
                                <template slot="content">
                                  <div>
                                    {{ $t(`common.${dest.dtype}_destination`) }}
                                  </div>
                                </template>
                              </cv-interactive-tooltip>
                            </span>
                          </div>
                          <div v-else>
                            <!-- adduser or addgroup address -->
                            <span class="destination">
                              <cv-interactive-tooltip
                                alignment="center"
                                direction="top"
                                class="tooltip-with-text-trigger info"
                              >
                                <template slot="trigger">
                                  <span class="icon-and-text-inline">
                                    <span class="icon">
                                      <NsSvg
                                        v-if="row.atype === 'adduser'"
                                        :svg="User16"
                                      />
                                      <NsSvg
                                        v-else-if="row.atype === 'addgroup'"
                                        :svg="Events16"
                                      />
                                    </span>
                                    <span>{{
                                      row.description || row.local
                                    }}</span>
                                  </span>
                                </template>
                                <template slot="content">
                                  <div v-if="row.atype === 'adduser'">
                                    {{ $t(`common.user_destination`) }}
                                  </div>
                                  <div v-else-if="row.atype === 'addgroup'">
                                    {{ $t(`common.group_destination`) }}
                                  </div>
                                </template>
                              </cv-interactive-tooltip>
                            </span>
                          </div>
                        </cv-data-table-cell>
                        <cv-data-table-cell>
                          <span class="icon-and-text-inline">
                            <span class="icon">
                              <NsSvg v-if="row.internal" :svg="Locked16" />
                              <NsSvg v-else :svg="Wikis16" />
                            </span>
                            <span>{{ row.visibility }}</span>
                          </span>
                        </cv-data-table-cell>
                        <cv-data-table-cell class="table-overflow-menu-cell">
                          <cv-overflow-menu
                            v-if="
                              row.atype !== 'adduser' &&
                              row.atype !== 'addgroup'
                            "
                            flip-menu
                            class="table-overflow-menu"
                            :data-test-id="row.address + '-menu'"
                          >
                            <cv-overflow-menu-item
                              @click="showEditAddressModal(row)"
                              :data-test-id="row.address + '-edit'"
                            >
                              <NsMenuItem
                                :icon="Edit20"
                                :label="core.$t('common.edit')"
                              />
                            </cv-overflow-menu-item>
                            <cv-overflow-menu-item
                              danger
                              @click="willDeleteAddress(row)"
                              :disabled="row.delete_forbidden"
                              :data-test-id="row.address + '-delete'"
                            >
                              <NsMenuItem
                                :icon="TrashCan20"
                                :label="core.$t('common.delete')"
                              />
                            </cv-overflow-menu-item>
                          </cv-overflow-menu>
                          <!-- overflow menu for adduser addresses -->
                          <cv-overflow-menu
                            v-else
                            flip-menu
                            class="table-overflow-menu"
                            :data-test-id="row.address + '-menu'"
                          >
                            <cv-overflow-menu-item
                              @click="toggleVisibility(row)"
                              :data-test-id="row.address + '-toggle-visibility'"
                            >
                              <NsMenuItem
                                v-if="!row.internal"
                                :icon="Locked20"
                                :label="$t('addresses.set_as_internal')"
                              />
                              <NsMenuItem
                                v-else
                                :icon="Wikis20"
                                :label="$t('addresses.set_as_public')"
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
          </cv-tile>
        </cv-column>
      </cv-row>
    </cv-grid>
    <CreateOrEditAddressModal
      :isShown="isShownCreateOrEditAddressModal"
      :domains="internalDomains"
      :defaultDomainId="q.selectedDomainId"
      :address="currentAddress"
      :isEditing="isEditingAddress"
      @hide="hideCreateAddressModal"
      @reloadAddresses="onReloadAddresses"
    />
  </div>
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
import _cloneDeep from "lodash/cloneDeep";
import CreateOrEditAddressModal from "@/components/CreateOrEditAddressModal";
import Information16 from "@carbon/icons-vue/es/information/16";

export default {
  name: "Addresses",
  components: { CreateOrEditAddressModal, Information16 },
  mixins: [
    TaskService,
    UtilService,
    IconService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("addresses.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "addresses",
        selectedDomainId: "",
      },
      urlCheckInterval: null,
      tablePage: [],
      tableColumns: ["address", "type", "destinations", "visibility"],
      addresses: [],
      internalDomains: [],
      isShownCreateOrEditAddressModal: false,
      currentAddress: null,
      isEditingAddress: false,
      deleteAddressTimeout: [],
      addUserDomains: [],
      addGroupDomains: [],
      loading: {
        listAddresses: false,
        removeAddress: false,
        listDomains: false,
        toggleVisibility: false,
      },
      error: {
        listAddresses: "",
        removeAddress: "",
        listDomains: "",
        toggleVisibility: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    i18nTableColumns() {
      return this.tableColumns.map((column) => {
        return this.$t("addresses." + column);
      });
    },
    filteredAddresses() {
      if (this.q.selectedDomainId === "all" || !this.q.selectedDomainId) {
        return this.addresses;
      }

      if (this.q.selectedDomainId === "wildcard") {
        return this.addresses.filter((address) => {
          return address.atype === "wildcard";
        });
      }

      const filteredAddresses = this.addresses.filter((address) => {
        return (
          address.domain === this.q.selectedDomainId ||
          (this.addUserDomains.includes(this.q.selectedDomainId) &&
            address.atype === "adduser") ||
          (this.addGroupDomains.includes(this.q.selectedDomainId) &&
            address.atype === "addgroup")
        );
      });
      return filteredAddresses;
    },
    selectedDomainLabel() {
      if (this.q.selectedDomainId === "all" || !this.q.selectedDomainId) {
        return "";
      }

      const domain = this.internalDomains.find(
        (d) => d.value === this.q.selectedDomainId
      );

      if (domain) {
        return domain.label;
      }
      return "";
    },
    addressesForFilter() {
      if (!this.internalDomains.length) {
        return [];
      }

      // add "All domains" at the beginning of internalDomains array
      const domains = _cloneDeep(this.internalDomains);

      domains.unshift({
        name: "all",
        label: this.$t("addresses.all_domains"),
        value: "all",
      });
      return domains;
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
    this.listDomains();
    this.listAddresses();
  },
  methods: {
    showCreateAddressModal() {
      this.isEditingAddress = false;
      this.isShownCreateOrEditAddressModal = true;
    },
    showEditAddressModal(address) {
      this.isEditingAddress = true;
      this.currentAddress = address;
      this.isShownCreateOrEditAddressModal = true;
    },
    hideCreateAddressModal() {
      this.isShownCreateOrEditAddressModal = false;
    },
    async listAddresses() {
      this.addresses = [];

      const taskAction = "list-addresses";
      const eventId = this.getUuid();
      this.loading.listAddresses = true;

      // register to task events

      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listAddressesAborted
      );

      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listAddressesCompleted
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
        this.error.listAddresses = errMessage;
        this.loading.listAddresses = false;
      }
    },
    listAddressesAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listAddresses = this.$t("error.generic_error");
      this.loading.listAddresses = false;
    },
    listAddressesCompleted(taskContext, taskResult) {
      this.addUserDomains = taskResult.output.adduser_domains;
      this.addGroupDomains = taskResult.output.addgroup_domains;
      const addresses = taskResult.output.addresses.map((address) => {
        const domain = address.domain ? address.domain : "";
        const visibility = address.internal
          ? this.$t("addresses.internal")
          : this.$t("addresses.public");

        return {
          domain: address.domain,
          address: `${address.local}@${domain}`,
          local: address.local,
          destinations: address.destinations,
          internal: !!address.internal,
          visibility: visibility,
          atype: address.atype,
          type: this.$t(`addresses.type_${address.atype}`),
          delete_forbidden: address.delete_forbidden,
          description: address.description,
        };
      });

      this.addresses = addresses.sort(this.sortByProperty("address"));
      this.loading.listAddresses = false;
    },
    showAllDomains() {
      this.q.selectedDomainId = "all";
    },
    onReloadAddresses() {
      this.listAddresses();
    },
    async removeAddress(address) {
      this.loading.removeAddress = true;
      this.error.removeAddress = "";
      const taskAction = "remove-address";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.removeAddressAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.removeAddressCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            local: address.local,
            atype: address.atype,
            domain: address.domain,
          },
          extra: {
            title: this.$t("addresses.delete_address_address", {
              address: address.address,
            }),
            description: this.core.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.removeAddress = this.getErrorMessage(err);
        this.loading.removeAddress = false;
        return;
      }
    },
    removeAddressAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.removeAddress = false;
    },
    removeAddressCompleted() {
      this.loading.removeAddress = false;

      // reload addresses
      this.listAddresses();
    },
    async listDomains() {
      this.loading.listDomains = true;
      this.error.listDomains = "";
      const taskAction = "list-domains";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.listDomainsAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.listDomainsCompleted
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
        this.error.listDomains = this.getErrorMessage(err);
        this.loading.listDomains = false;
        return;
      }
    },
    listDomainsAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.listDomains = this.$t("error.generic_error");
      this.loading.listDomains = false;
    },
    listDomainsCompleted(taskContext, taskResult) {
      this.loading.listDomains = false;
      this.domains = taskResult.output;

      this.internalDomains = this.domains.map((d) => {
        return {
          name: d.domain,
          label: d.domain,
          value: d.domain,
        };
      });

      // add wildcard domain
      this.internalDomains.push({
        name: "wildcard",
        label: this.$t("addresses.wildcard_label"),
        value: "wildcard",
      });

      this.$nextTick(() => {
        if (!this.q.selectedDomainId) {
          // initially show all domains
          this.q.selectedDomainId = "all";
        } else {
          const domainId = this.q.selectedDomainId;

          // workaround to update combo box
          this.q.selectedDomainId = "";
          this.$nextTick(() => {
            this.q.selectedDomainId = domainId;
          });
        }
      });
    },
    filterTableRows(searchFilter) {
      // remove domain part from search filter
      searchFilter = searchFilter.split("@")[0];

      if (!searchFilter) {
        return this.filteredAddresses;
      } else {
        // clean query
        const cleanRegex = /[^a-zA-Z0-9]/g;
        const queryText = searchFilter.replace(cleanRegex, "");

        const searchResults = this.filteredAddresses.filter((option) => {
          // compare query text with attributes option
          return this.tableColumns.some((searchField) => {
            const searchValue = option[searchField];

            if (searchValue) {
              if (Array.isArray(searchValue)) {
                // search field is an array (e.g. destinations)
                return searchValue.some((elem) => {
                  let el = elem;

                  if (typeof elem == "object") {
                    el = elem.ui_name || elem.name;
                  }

                  return new RegExp(queryText, "i").test(
                    el.replace(cleanRegex, "")
                  );
                });
              } else {
                // search field is a simple string
                return new RegExp(queryText, "i").test(
                  searchValue.replace(cleanRegex, "")
                );
              }
            } else {
              return false;
            }
          });
        }, this);
        return searchResults;
      }
    },
    async toggleVisibility(address) {
      this.loading.toggleVisibility = true;
      this.error.toggleVisibility = "";
      const taskAction = "alter-address";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.toggleVisibilityAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.toggleVisibilityCompleted
      );

      const addAddressData = {
        local: address.local,
        internal: !address.internal,
        description: address.description,
        destinations: address.destinations,
        atype: address.atype,
        domain: address.domain,
      };

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: addAddressData,
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
        this.error.toggleVisibility = this.getErrorMessage(err);
        this.loading.toggleVisibility = false;
        return;
      }
    },
    toggleVisibilityAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.toggleVisibility = this.$t("error.generic_error");
      this.loading.toggleVisibility = false;
    },
    toggleVisibilityCompleted() {
      this.loading.toggleVisibility = false;
      this.listAddresses();
    },
    willDeleteAddress(address) {
      const notification = {
        id: this.getUuid(),
        title: this.$t("addresses.address_address_is_going_to_be_deleted", {
          address: address.address,
        }),
        type: "info",
        toastTimeout: this.DELETE_DELAY - 1000,
        actionLabel: this.core.$t("common.cancel"),
        action: {
          type: "callback",
          callback: this.cancelDeleteAddress.bind(null, address),
        },
      };
      this.createNotificationForApp(notification);

      const timeout = setTimeout(() => {
        // remove notification from drawer
        this.deleteNotificationForApp(notification.id);

        // delete timeout
        this.deleteAddressTimeout = this.deleteAddressTimeout.filter(
          (el) => el.name !== address.address
        );

        // call api to remove address
        this.removeAddress(address);
      }, this.DELETE_DELAY);

      this.deleteAddressTimeout.push({
        name: address.address,
        timeout,
        notification,
      });

      // remove address from table
      this.addresses = this.addresses.filter(
        (a) => a.address !== address.address
      );
    },
    cancelDeleteAddress(address) {
      const timeoutFound = this.deleteAddressTimeout.find(
        (el) => el.name === address.address
      );

      if (timeoutFound) {
        clearTimeout(timeoutFound.timeout);

        // remove notification from drawer
        this.deleteNotificationForApp(timeoutFound.notification.id);

        // delete timeout
        this.deleteAddressTimeout = this.deleteAddressTimeout.filter(
          (el) => el.name !== address.address
        );
      }

      // reload addresses
      this.listAddresses();
    },
    getFullAddressList(address) {
      switch (address.atype) {
        case "domain":
          return [address.address];
        case "wildcard": {
          if (this.internalDomains.length && this.internalDomains.length <= 2) {
            // only one domain (plus "Wildcard")
            return [`${address.address}${this.internalDomains[0].value}`];
          } else {
            const fullAddressList = [];

            for (const domain of this.internalDomains) {
              if (domain.value !== "wildcard") {
                fullAddressList.push(`${address.address}${domain.value}`);
              }
            }
            return fullAddressList;
          }
        }
        case "adduser": {
          const fullAddressList = [];

          for (const domain of this.addUserDomains) {
            fullAddressList.push(`${address.address}${domain}`);
          }
          return fullAddressList;
        }
        case "addgroup": {
          const fullAddressList = [];

          for (const domain of this.addGroupDomains) {
            fullAddressList.push(`${address.address}${domain}`);
          }
          return fullAddressList;
        }
      }
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.tooltip-icon {
  margin-left: $spacing-02;
}
</style>