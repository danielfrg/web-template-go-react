var path = require('path');
var webpack = require('webpack');
var LiveReloadPlugin = require('webpack-livereload-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var WebpackShellPlugin = require('webpack-shell-plugin');

console.log("NODE_ENV:", process.env.NODE_ENV)

entries = [
    './app/index.js',
    './app/style/app.sass'
]

if (process.env.NODE_ENV == "dev") {
    entries.push('./app/watch.js');
}

module.exports = {
    entry: entries,
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'resources/static')
    },

    module: {
        loaders: [
            {
                test: /.js$/,
                loader: 'babel-loader',
                exclude: /node_modules/,
                query: {
                    presets: ['es2015']
                }
            }
        ],
        rules: [
            {
                test: [/\.[s]css$/, /\.sass$/],
                use: ExtractTextPlugin.extract({
                    use: ['css-loader', 'sass-loader']
                })
            }
        ]
    },
    watch: false,
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
