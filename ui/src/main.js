//
// Copyright (C) 2022 Nethesis S.r.l.
// SPDX-License-Identifier: GPL-3.0-or-later
//
import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import { loadLanguage } from "./i18n";

import CarbonComponentsVue from "@carbon/vue";
Vue.use(CarbonComponentsVue);

import axios from "axios";
axios.defaults.timeout = 10000;
import VueAxios from "vue-axios";
Vue.use(VueAxios, axios);

import ns8Lib from "@nethserver/ns8-ui-lib";
Vue.use(ns8Lib);

// global mixin to set page title
import { PageTitleService } from "@nethserver/ns8-ui-lib";
Vue.mixin(PageTitleService);

// i18n
import VueI18n from "vue-i18n";

import VueDateFns from "vue-date-fns";
Vue.use(VueDateFns);

import LottieAnimation from "lottie-web-vue";
Vue.use(LottieAnimation);

import vueDebounce from "vue-debounce";
Vue.use(vueDebounce);

// filters
import { Filters } from "@nethserver/ns8-ui-lib";
for (const f in Filters) {
  Vue.filter(f, Filters[f]);
}

Vue.use(VueI18n);
const i18n = new VueI18n();
const navigatorLang = navigator.language.substring(0, 2);
loadLanguage(navigatorLang, i18n);

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  i18n,
  render: (h) => h(App),
}).$mount("#ns8-app");
