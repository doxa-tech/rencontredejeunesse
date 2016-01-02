$flash = document.getElementById("flash-contact");
if(window.location.search.indexOf("state=success") === 1) {
  $flash.innerHTML = "Votre message a été transmis !";
} else if(window.location.search.indexOf("state=error") === 1) {
  $flash.innerHTML = "Impossible d'envoyer votre message. Veuillez remplir tous les champs correctement.";
}
