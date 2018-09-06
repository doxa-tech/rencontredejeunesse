// Open the Modal
function openModal() {
  document.getElementById('myModal').style.visibility = "visible";
  document.getElementById('myModal').style.opacity = "1";
}

// Close the Modal
function closeModal() {
  document.getElementById('myModal').style.visibility = "hidden";
  document.getElementById('myModal').style.opacity = "0";
}

var slideIndex = 0;

// Next/previous controls
function plusSlides(n) {
  showSlides(slideIndex += n);
}

// Thumbnail image controls
function currentSlide(n) {
  showSlides(slideIndex = n);
}

function showSlides(n) {
  var i;
  var slides = document.getElementsByClassName("mySlides");
  if (n > slides.length-1) { slideIndex = 0 }
  if (n < 0) { slideIndex = slides.length - 1 }
  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";
  }
  slides[slideIndex].style.display = "block";
}