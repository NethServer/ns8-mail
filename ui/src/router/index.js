//
// Copyright (C) 2023 Nethesis S.r.l.
// SPDX-License-Identifier: GPL-3.0-or-later
//
import Vue from "vue";
import VueRouter from "vue-router";
import Status from "../views/Status.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Status",
    component: Status,
    alias: "/status", // important
  },
  {
    path: "/domains",
    name: "Domains",
    component: () =>
      import(/* webpackChunkName: "domains" */ "../views/Domains.vue"),
  },
  {
    path: "/filter",
    name: "MailFilter",
    component: () =>
      import(/* webpackChunkName: "filter" */ "../views/MailFilter.vue"),
  },
  {
    path: "/filterBypassRules",
    name: "FilterBypassRules",
    component: () =>
      import(
        /* webpackChunkName: "filterBypassRules" */ "../views/FilterBypassRules.vue"
      ),
  },
  {
    path: "/mailboxes",
    name: "Mailboxes",
    component: () =>
      import(/* webpackChunkName: "mailboxes" */ "../views/Mailboxes.vue"),
  },
  {
    path: "/addresses",
    name: "Addresses",
    component: () =>
      import(/* webpackChunkName: "addresses" */ "../views/Addresses.vue"),
  },
  {
    path: "/deferredQueue",
    name: "DeferredQueue",
    component: () =>
      import(/* webpackChunkName: "addresses" */ "../views/DeferredQueue.vue"),
  },
  {
    path: "/settings",
    name: "Settings",
    component: () =>
      import(
        /* webpackChunkName: "settings" */ "../views/settings/Settings.vue"
      ),
  },
  {
    path: "/settingsGeneral",
    name: "SettingsGeneral",
    component: () =>
      import(
        /* webpackChunkName: "settings-general" */ "../views/settings/SettingsGeneral.vue"
      ),
  },
  {
    path: "/settingsMailboxes",
    name: "SettingsMailboxes",
    component: () =>
      import(
        /* webpackChunkName: "settings-mailboxes" */ "../views/settings/SettingsMailboxes.vue"
      ),
  },
  {
    path: "/settingsMasterUsers",
    name: "SettingsMasterUsers",
    component: () =>
      import(
        /* webpackChunkName: "settings-master-users" */ "../views/settings/SettingsMasterUsers.vue"
      ),
  },
  {
    path: "/settingsQueue",
    name: "SettingsQueue",
    component: () =>
      import(
        /* webpackChunkName: "settings-master-users" */ "../views/settings/SettingsQueue.vue"
      ),
  },
  {
    path: "/about",
    name: "About",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/About.vue"),
  },
];

const router = new VueRouter({
  base: process.env.BASE_URL,
  routes,
});

export default router;
