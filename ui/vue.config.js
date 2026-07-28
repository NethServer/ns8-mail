module.exports = {
  css: {
    loaderOptions: {
      sass: {
        sassOptions: {
          silenceDeprecations: ["import", "global-builtin", "color-functions", "if-function", "legacy-js-api"],
        },
      },
    },
  },
  publicPath: "./",
  configureWebpack: {
    optimization: {
      splitChunks: {
        maxSize: 500000,
      },
    },
  },
};
