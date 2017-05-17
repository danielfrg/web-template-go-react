var path = require('path');
var webpack = require('webpack');
var LiveReloadPlugin = require('webpack-livereload-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var WebpackShellPlugin = require('webpack-shell-plugin');

console.log("NODE_ENV:", process.env.NODE_ENV)

entries = [
    './app/index.ts',
    './app/style/app.sass'
]

if (process.env.NODE_ENV == "dev") {
    // entries.push('./app/watch.ts');
}

module.exports = {
    entry: entries,
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'resources/static')
    },

    // Enable sourcemaps for debugging webpack's output.
    devtool: "source-map",

    resolve: {
        // Add '.ts' and '.tsx' as resolvable extensions.
        extensions: [".ts", ".tsx", ".js", ".json"]
    },

    module: {
        rules: [
            // All files with a '.ts' or '.tsx' extension will be handled by 'awesome-typescript-loader'.
            {
                test: /\.tsx?$/,
                loader: 'ts-loader',
                exclude: /node_modules/,
            },
            // All output '.js' files will have any sourcemaps re-processed by 'source-map-loader'.
            {
                enforce: "pre",
                test: /\.js$/,
                loader: "source-map-loader",
                exclude: /node_modules/
            },
            // All output '.saas' will be handled by 'sass-loader'.
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
