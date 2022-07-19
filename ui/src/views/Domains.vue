<template>
  <div>
    <cv-grid fullWidth>
      <cv-row>
        <cv-column class="page-title">
          <h2>{{ $t("domains.title") }}</h2>
        </cv-column>
      </cv-row>
      <cv-row class="toolbar">
        <cv-column>
          <NsButton
            kind="secondary"
            :icon="Add20"
            @click="showCreateDomainModal"
            :disabled="loading.listDomains"
            >{{ $t("domains.create_domain") }}
          </NsButton>
        </cv-column>
      </cv-row>
      <cv-row v-if="error.listDomains">
        <cv-column>
          <NsInlineNotification
            kind="error"
            :title="$t('action.list-domains')"
            :description="error.listDomains"
            :showCloseButton="false"
          />
        </cv-column>
      </cv-row>
      <cv-row>
        <!-- loading domains -->
        <template v-if="loading.listDomains">
          <cv-column v-for="index in 2" :key="index" :md="4" :max="4">
            <cv-tile kind="standard" light>
              <cv-skeleton-text
                :paragraph="true"
                :line-count="6"
              ></cv-skeleton-text>
            </cv-tile>
          </cv-column>
        </template>
        <!-- no domain -->
        <cv-column v-else-if="!domains.length">
          <cv-tile light>
            <NsEmptyState :title="$t('domains.no_domain')"></NsEmptyState>
          </cv-tile>
        </cv-column>
        <!-- domains -->
        <template v-else>
          <cv-column
            v-for="domain in domains"
            :key="domain.domain"
            :md="4"
            :max="4"
          >
            <NsInfoCard
              light
              :title="domain.domain"
              :icon="Wikis32"
              :errorDescription="error.listDomains"
            >
              <template slot="menu">
                <cv-overflow-menu
                  :flip-menu="true"
                  tip-position="top"
                  tip-alignment="end"
                  class="top-right-overflow-menu"
                >
                  <cv-overflow-menu-item @click="showEditDomainModal(domain)">
                    <NsMenuItem
                      :icon="Edit20"
                      :label="core.$t('common.edit')"
                    />
                  </cv-overflow-menu-item>
                  <NsMenuDivider />
                  <cv-overflow-menu-item
                    danger
                    @click="showDeleteDomainModal(domain)"
                  >
                    <NsMenuItem
                      :icon="TrashCan20"
                      :label="core.$t('common.delete')"
                    />
                  </cv-overflow-menu-item>
                </cv-overflow-menu>
              </template>
              <template slot="content">
                <div class="card-content">
                  <div v-if="domain.description" class="row description">
                    {{ domain.description }}
                  </div>
                  <NsButton
                    kind="ghost"
                    :icon="ArrowRight20"
                    @click="goToAddresses(domain)"
                    class="row"
                  >
                    {{ $t("addresses.title") }}
                  </NsButton>
                </div>
              </template>
            </NsInfoCard>
          </cv-column>
        </template>
      </cv-row>
    </cv-grid>
    <CreateOrEditDomainModal
      :isShown="isShownCreateOrEditDomainModal"
      :domain="currentDomain"
      :isEditing="isEditingDomain"
      @hide="hideCreateDomainModal"
      @reloadDomains="listDomains"
    />
    <!-- delete domain modal -->
    <NsDangerDeleteModal
      :isShown="isShownDeleteDomainModal"
      :name="currentDomain.domain"
      :title="$t('domains.delete_domain')"
      :warning="core.$t('common.please_read_carefully')"
      :description="
        $t('domains.delete_domain_confirm', {
          name: currentDomain.domain,
        })
      "
      :typeToConfirm="
        core.$t('common.type_to_confirm', { name: currentDomain.domain })
      "
      @hide="hideDeleteDomainModal"
      @confirmDelete="removeDomain"
    >
      <template slot="explanation">
        <p
          class="mg-top-sm"
          v-html="$t('domains.delete_domain_explanation')"
        ></p>
        <p
          class="mg-top-sm"
          v-html="core.$t('common.this_action_is_not_reversible')"
        ></p>
      </template>
    </NsDangerDeleteModal>
  </div>
</template>

<script>
import to from "await-to-js";
import { mapState } from "vuex";
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
} from "@nethserver/ns8-ui-lib";
import CreateOrEditDomainModal from "@/components/CreateOrEditDomainModal";

export default {
  name: "Domains",
  components: { CreateOrEditDomainModal },
  mixins: [TaskService, IconService, UtilService, QueryParamService],
  pageTitle() {
    return this.$t("domains.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "domains",
      },
      urlCheckInterval: null,
      domains: [],
      isEditingDomain: false,
      isShownCreateOrEditDomainModal: false,
      currentDomain: {
        domain: "",
      },
      isShownDeleteDomainModal: false,
      loading: {
        listDomains: false,
        removeDomain: false,
      },
      error: {
        listDomains: "",
        removeDomain: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName", "isAppConfigured"]),
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
    this.$root.$on("reloadDomains", this.listDomains);
    this.listDomains();
  },
  beforeDestroy() {
    // remove event listener
    this.$root.$off("reloadDomains");
  },
  methods: {
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
    },
    goToAddresses(domain) {
      const query = { selectedDomainId: domain.domain };
      this.goToAppPage(this.instanceName, "addresses", query);
    },
    showCreateDomainModal() {
      this.isEditingDomain = false;
      this.isShownCreateOrEditDomainModal = true;
    },
    showEditDomainModal(domain) {
      this.isEditingDomain = true;
      this.currentDomain = domain;
      this.isShownCreateOrEditDomainModal = true;
    },
    hideCreateDomainModal() {
      this.isShownCreateOrEditDomainModal = false;
    },
    showDeleteDomainModal(domain) {
      this.currentDomain = domain;
      this.isShownDeleteDomainModal = true;
    },
    hideDeleteDomainModal() {
      this.isShownDeleteDomainModal = false;
    },
    async removeDomain() {
      this.loading.removeDomain = true;
      this.error.removeDomain = "";
      const taskAction = "remove-domain";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.removeDomainAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.removeDomainCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            domain: this.currentDomain.domain,
          },
          extra: {
            title: this.$t("domains.delete_domain_domain", {
              domain: this.currentDomain.domain,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.removeDomain = this.getErrorMessage(err);
        this.loading.removeDomain = false;
        return;
      }
      this.hideDeleteDomainModal();
    },
    removeDomainAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.loading.removeDomain = false;
    },
    removeDomainCompleted() {
      this.loading.removeDomain = false;

      // reload domains
      this.listDomains();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";

.card-content {
  flex-direction: column;
  text-align: center;

  .row {
    margin-bottom: $spacing-05;
  }

  .description {
    color: $ui-04;
  }
}
</style>
