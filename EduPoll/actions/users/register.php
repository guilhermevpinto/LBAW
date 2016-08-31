<?php
include_once ('../../config/init.php');
include_once ($BASE_DIR . 'database/users.php');
require_once ($BASE_DIR . 'pages/common/utils.php');

if (!$_POST['userName'] || !$_POST['userEmail'] || !$_POST['confirmUserEmail']) {
  $_SESSION['error_messages'][] = 'All fields are mandatory';
  $_SESSION['form_values'] = $_POST;
  header("Location: " . $_SERVER['HTTP_REFERER']);
  exit;
}

if (! validateCSRFToken ( $_POST ['csrf_token'] )) {
	$_SESSION ['error_messages'] [] = 'CSRF token missing.';
	header ( "Location: " . $_SERVER ['HTTP_REFERER'] );
	die ();
}

$name = strip_tags($_POST['userName']);
$email = strip_tags($_POST['userEmail']);
$confirmEmail = strip_tags($_POST['confirmUserEmail']);

if ($email != $confirmEmail) {
  $_SESSION['error_messages'][] = 'The introduced email addresses don\'t match';
  $_SESSION['form_values'] = $_POST;
  header("Location: " . $_SERVER['HTTP_REFERER']);
  exit;
}

  // gender checking
$gender = isset($_POST['genderType']) ? '0' : '1' ;

$password = generatePassword();

  // user type checking  
$type = isset($_POST['userType']) ? '2' : '1' ;

try {
	registerUser($name, $email, $gender, $password, $type);
} catch ( PDOException $e ) {

	if (strpos ( $e->getMessage (), 'users_pkey' ) !== false) {
		$_SESSION ['error_messages'] [] = 'Duplicate username';
		$_SESSION ['field_errors'] ['username'] = 'Username already exists';
	} else
	$_SESSION ['error_messages'] [] = 'Error on user registration';

	$_SESSION ['form_values'] = $_POST;
	header ( "Location: " . $_SERVER ['HTTP_REFERER'] );
	exit ();
}

emailSender($name,$password,$email);

$_SESSION ['success_messages'] [] = 'User was registered successfully';
header ( "Location: " . $_SERVER ['HTTP_REFERER'] );

?>
