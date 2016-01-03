<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if (!empty($_POST["firstname"])
    AND !empty($_POST["lastname"])
    AND !empty($_POST["email"])
    AND !empty($_POST["object"])
    AND !empty($_POST["content"])
  ) {
    $firstname = clean($_POST["firstname"]);
    $lastname = clean($_POST["lastname"]);
    $email = clean($_POST["email"]);
    $object = clean($_POST["object"]);
    $content = clean($_POST["content"]);
    if (is_valid($firstname) AND is_valid($lastname) AND is_email($email) AND strlen($object) < 100) {
      $headers = "From: {$firstname} {$lastname} <{$email}>";
      mail("info@rencontredejeunesse.ch", $object, $content, $headers);
      $success = true;
    } else {
      $success = false;
    }
  } else {
    $success = false;
  }
}

if($success) {
  header("Location: /?state=success#contact");
} else {
  header("Location: /?state=error#contact");
}

function clean($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}
function is_email($email) {
  return filter_var($email, FILTER_VALIDATE_EMAIL);
}
function is_valid($str) {
  return strlen($str) < 150 AND preg_match("/^[a-zA-Z- ]*$/", $str);
}
?>
