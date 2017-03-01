import _ from 'lodash';
import 'whatwg-fetch';

function component () {
  var element = document.createElement('div');

  /* lodash is required for the next line to work */
  element.innerHTML = _.join(['Hello','world'], ' ');

  fetch('/version')
  .then(function(response) {
    return response.text()
  }).then(function(body) {
    var version = document.getElementById("version")
    version.innerText = body
  });

  return element;
}

document.body.appendChild(component());
