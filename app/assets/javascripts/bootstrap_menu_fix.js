/** 
  IPhone, IPad and some Android devices have trouble handling the bootstrap flex menu. 
  This is the hack/solution. 
*/

$(document).ready(function() {
  $('body')
    .on('touchstart.dropdown', '.dropdown-menu', function (e) { e.stopPropagation(); })
    .on('touchstart.dropdown', '.dropdown-submenu', function (e) { e.preventDefault(); });
});