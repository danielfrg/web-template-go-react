// Watch the Go binary so it livereloads when its re-built
var fresh_binary = require("file-loader!../tmp/runner-build");
// Watch templates
var t1 = require("file-loader!../resources/index.html");
