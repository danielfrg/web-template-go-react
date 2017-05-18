import 'whatwg-fetch';
import * as $ from 'jquery';
import * as rpc from './rpc';
import * as ext_rpc from './ext_rpc';

// Class example
class Student {
    fullName: string;

    constructor(public firstName : string, public middleInitial : string, public lastName : string) {
        this.fullName = firstName + " " + middleInitial + " " + lastName;
    }
}

interface Person {
    firstName: string;
    lastName: string;
}

function greeter(person : Person) {
    return "Hello, " + person.firstName + " " + person.lastName;
}

var user = new Student("C", "E", "D");
console.log(greeter(user));

// Query the `/api/version` endpoint
function setVersion () {
    fetch('/api/version')
    .then(function(response) {
        return response.text()
    }).then(function(body) {
        // Print version
        console.log('Version', body);
        
        // Set the version value on the UI
        var version = $('#version');
        version.text('version: ' + body);
    });
}

window.onload = function() {
    setVersion();
};

// Query WebGRPC
rpc.getBook();
// rpc.queryBooks();

ext_rpc.externalGRPC();
