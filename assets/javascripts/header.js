var $burger = document.getElementById("burger-menu"),
    $topbar = document.getElementById("topbar");

$burger.onclick = function(e) {
  if(!$topbar.classList.contains("open")) {
    $topbar.classList.add("open");
    if(typeof player !== 'undefined') { player.getIframe().style.display = "none"; } // iOS 7 fix
    e.stopPropagation();
  }
};
$topbar.onclick = function(e) {
  if($topbar.classList.contains("open")) {
    if(typeof player !== 'undefined') { player.getIframe().style.display = "block"; } // iOS 7 fix
    $topbar.classList.remove("open");
  }
};
