import _ from 'lodash';
import 'whatwg-fetch';

import Point from './point.js';

function component () {
  var element = $("#hello")
  element.text(_.join(['Hello', 'world'], ' ') + ': ' + new Point(1, 25));

  fetch('/api/version')
  .then(function(response) {
    return response.text()
  }).then(function(body) {
    console.log('Version', body);
    // var version = document.getElementById("version");
    // version.innerText = body;
    var version = $('#version');
    version.text('ver: ' + body);
  });

  console.log('Point: ', new Point(1, 23));

  return element;
}

window.onload = function(){
  document.body.appendChild(component());
};
