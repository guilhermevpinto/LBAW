<?
require_once ('../../config/init.php');
include_once ('../../pages/common/utils.php');
include_once ('../../database/exams.php');

header('Content-Type: application/json');

if (! isLoggedIn ()) {
	http_response_code(401);
	echo 'You are not logged in.';
	exit ();
}

if (! validateCSRFToken ( $_POST ['csrf_token'] )) {
	$_SESSION ['error_messages'] [] = 'CSRF token missing.';
	header ( "Location: " . $_SERVER ['HTTP_REFERER'] );
	die ();
}

$exam = getExamFromExamElement($_POST['id']);
if (!$exam) {
	http_response_code(400);
	echo 'Error fetching exam to edit.';
	exit;
}

if ($exam ['ownerid'] !== $userInfo ['id']) {
	if (!isExamManager($userInfo['id'], $exam['id'])) {
		http_response_code(401);
		echo 'Only the owner/manager of an exam may edit a category\'s name.';
		exit;
	}
}

$reply;

try {
	$reply = editCategoryName($_POST['id'], $_POST['name']);
} catch (PDOException $e) {
	http_response_code(400);
	echo 'Error editing category name: ' . $e->getMessage();
	exit;
}

http_response_code(200);
echo $_POST['name'];
?>