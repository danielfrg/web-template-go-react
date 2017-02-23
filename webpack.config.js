var path = require('path');
var webpack = require('webpack');
var LiveReloadPlugin = require('webpack-livereload-plugin');
var WebpackShellPlugin = require('webpack-shell-plugin');

module.exports = {
  entry: [
    './app/index.js',
    './app/watch.js',
  ],
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'public/dist')
  },
  watch: true,
  watchOptions: {
    aggregateTimeout: 300,
    poll: 1000,
    ignored: "/node_modules/"
  },
  plugins: [
    new LiveReloadPlugin(),
    new WebpackShellPlugin({onBuildStart:['echo "Webpack Start"'], onBuildEnd:['echo "Webpack End"']})
  ]
};
