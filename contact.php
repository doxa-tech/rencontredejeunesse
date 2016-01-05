<?php
$success = false;
if (isset($_POST["contact"])) {
	if (!empty($_POST["firstname"]) and !empty($_POST["lastname"]) and !empty($_POST["email"]) and !empty($_POST["object"]) and !empty($_POST["content"])) {
		$firstname = clean($_POST["firstname"]);
		$lastname = clean($_POST["lastname"]);
		$email = clean($_POST["email"]);
		$object = clean($_POST["object"]);
		$content = clean($_POST["content"]);
		if (is_valid($firstname) AND is_valid($lastname) AND is_email($email) AND is_valid($object)) {
	      $headers	= "From: ".$firstname." ".$lastname." <".$email.">\r\n".
	      			      "Reply-To: ".$email."\r\n".
				  		      "MIME-Version: 1.0\r\n".
				  		      "Content-type: text/html; charset=UTF-8\r\n";
   	   mail("alex@megaphone.ch", $object, $content, $headers);
   	   mail("info@rencontredejeunesse.ch", $object, $content, $headers);
      	$success = true;
    	}
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
  return strlen($str) < 150;
}
?>
