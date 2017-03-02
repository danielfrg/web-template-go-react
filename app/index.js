import _ from 'lodash';
import 'whatwg-fetch';

import Point from './point.js';

function component () {
  var element = document.createElement('div');

  element.innerHTML = _.join(['Hello', 'world'], ' ') + ': ' + new Point(1, 23);

  fetch('/version')
  .then(function(response) {
    return response.text()
  }).then(function(body) {
    console.log("Version", body);
    var version = document.getElementById("version");
    version.innerText = body;
  });

  console.log("Point: ", new Point(1, 23));

  return element;
}

window.onload = function(){
  document.body.appendChild(component());
};
