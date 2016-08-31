<?
require_once ('../../config/init.php');
include_once ('../common/utils.php');
include_once ('../common/sidebar.php');
include_once ('../../database/exams.php');

function cleanData(&$str) {
	$str = preg_replace("/\t/", "\\t", $str);
	$str = preg_replace("/\r?\n/", "\\n", $str);
    if(strstr($str, '"')) $str = '"' . str_replace('"', '""', $str) . '"';
}

function isXLS($format) {
	return strcmp($format, "XLS") == 0;
}

function isJSON($format) {
	return strcmp($format, "JSON") == 0;
}

 if (! isLoggedIn ()) {
	header ( 'Location: ' . $BASE_URL . 'pages/auth/login.php' );
	die ();
 } else if (isAdmin()) {
  	header('Location: ' . $BASE_URL . 'pages/admin/main.php');
  	die();
 }
 
$examID = $_GET ['examid'];
$userID = $_SESSION['userID'];

if(getExamOwner($examID)[0]['id'] != $userID) {
	$_SESSION ['error_messages'] [] = 'You do not own this exam.';
	header ( "Location: " . $BASE_URL . 'pages/exams/my_exams.php' );
	die ();
}

$format = $_GET['format'];

if(!isset($format)) {
	$_SESSION ['error_messages'] [] = 'No format was specified (XLS/JSON).';
	header ( "Location: " . $_SERVER['HTTP_REFERER'] );
	die ();
}

if(!isXLS($format) && !isJSON($format)) {
	$_SESSION ['error_messages'] [] = 'Invalid format specified. Must be XLS or JSON.';
	header ( "Location: " . $_SERVER['HTTP_REFERER'] );
	die ();
}
	//header("Content-Type: text/plain");
  	///*
  	if(isXLS($format)) {
  		$filename = "exam_" . $examID . ".xls";
		header("Content-Disposition: attachment; filename=\"$filename\"");
  		header("Content-Type: application/vnd.ms-excel");
  	} else {
	  	$filename = "exam_" . $examID . ".json";
		header("Content-Disposition: attachment; filename=\"$filename\"");
  		header("Content-Type: application/json");
  	}
  	//*/
  	
$jsondata = [];

$exam = getExam($examID);
$stats = getExamStats($examID);
$approvals = getExamApprovals($examID);
$questions = getExamQuestions($examID);
$questionscores = [];

foreach($questions as $question) {
	$questionstats = getQuestionAverageScore($question['id']);
	$questiondata = [];
	if(!$questionstats) {
		$questiondata['Question ID'] = $question['id'];
		$questiondata['Statement'] = $question['statement'];
		$questiondata['Ammount of Answers'] = 0;
		$questiondata['Average Score'] = "-";
	} else {
		$questiondata['Question ID'] = $question['id'];
		$questiondata['Statement'] = $questionstats['statement'];
		$questiondata['Ammount of Answers'] = $questionstats['answers'];
		$questiondata['Average Score'] = str_replace('.', ',', "" . $questionstats['score']);
	}
	array_push($questionscores, $questiondata);
}

if($stats['attempts'] === 0)
	$stats['averagegrade'] = 0;
$stats['approved'] = sizeof($approvals);

$studentstats = getExamStudentGrades($examID);

$gradedistribution = [];
for($g = 0; $g <= 20; $g++) {
	$gradedistribution[$g] = 0;
}
foreach($studentstats as $student) {
	$grade = (int)($student['finalscore']);
	$gradedistribution[$grade]++;
}

$examOver = examStatus($examID); //1->over , 2->active, 0->



$line_break = "\r\n";
$paragraph = $line_break . $line_break;
$tab = "\t";

$gradedistexport = [];
for($g = 0; $g <= 20; $g++) {
	$temp = [];
	$temp['Grade'] = $g;
	$temp['Ammount'] = $gradedistribution[$g];
	array_push($gradedistexport, $temp);
}

if(isXLS($format)) {
	echo "Grade distribution" . $paragraph;
	echo $tab . implode("\t", array_keys($gradedistexport[0])) . "\r\n";
	foreach($gradedistexport as $row) {
		array_walk($row, __NAMESPACE__ . '\cleanData');
		echo $tab . implode("\t", array_values($row)) . "\r\n";
	}
} else {
	$jsondata['gradeDistribution'] = $gradedistexport;
}

if(isXLS($format)) {
	echo $paragraph . "Question statistics" . $paragraph;

	echo $tab . implode("\t", array_keys($questionscores[0])) . "\r\n";
	foreach($questionscores as $row) {
		array_walk($row, __NAMESPACE__ . '\cleanData');
		echo $tab . implode("\t", array_values($row)) . "\r\n";
	}
} else {
	$jsondata['questionStatistics'] = $questionscores;
}

$jsondata['attemptScores'] = [];
if(sizeof($studentstats > 0)) {
	if(isXLS($format)) {
		echo $paragraph . "Attempt scores" . $paragraph;
	}

	$scoresexport = [];
	foreach($studentstats as $student) {
		$temp = [];
		$temp['Attempt ID'] = $student['attemptid'];
		$temp['Student Name'] = $student['username'];
		$temp['Grade'] = str_replace('.', ',', "" . $student['finalscore']);
		array_push($scoresexport, $temp);
	}
	
	if(isXLS($format)) {
		echo $tab . implode("\t", array_keys($scoresexport[0])) . "\r\n";
		foreach($scoresexport as $row) {
			array_walk($row, __NAMESPACE__ . '\cleanData');
			echo $tab . implode("\t", array_values($row)) . "\r\n";
		}
	} else {
		$jsondata['attemptScores'] = $scoresexport;
	}
}

if(isXLS($format)) {
	echo $paragraph . "Approvals" . $paragraph;
	$approvals = array(
		array("Approved" => $stats['approved'], "Disapproved" => (sizeof($studentstats) - $stats['approved']))
	);

	echo $tab . implode("\t", array_keys($approvals[0])) . "\r\n";
		echo $tab . implode("\t", array_values($approvals[0])) . "\r\n";
} else {
	$jsondata['approvals'] = array(
		array("approved" => $stats['approved'], "disapproved" => (sizeof($studentstats) - $stats['approved']))
	);
}

if(isJSON($format)) {
	echo json_encode($jsondata);
}
?>
