var path = require('path');
var webpack = require('webpack');
var LiveReloadPlugin = require('webpack-livereload-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var WebpackShellPlugin = require('webpack-shell-plugin');

module.exports = {
    entry: [
        './app/index.js',
        './app/watch.js',
        './app/style/app.sass',
    ],
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'public')
    },
    module: {
        rules: [
            {
                test: [/\.[s]css$/, /\.sass$/],
                use: ExtractTextPlugin.extract({
                    use: ['css-loader', 'sass-loader']
                })
            }
      ]
    },
    watch: true,
    watchOptions: {
        aggregateTimeout: 300,
        poll: 1000,
        ignored: "/node_modules/"
    },
    plugins: [
        new LiveReloadPlugin(),
        new ExtractTextPlugin('bundle.css'),
        new WebpackShellPlugin({onBuildStart:['echo "Webpack Start"'], onBuildEnd:['echo "Webpack End"']})
    ]
};
