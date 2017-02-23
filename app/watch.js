// Watch the Go binary so it livereloads when its re-built
// var binary = require("file-loader!../bin/binder");
var fresh_binary = require("file-loader!../tmp/runner-build");
var t1 = require("file-loader!../templates/index.tmpl");
