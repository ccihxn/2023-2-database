<?php

function p_error($e_message) {
	print "<font color=red>" . $e_message . "</font>";
	$e = oci_error();
	print htmlentities($e['message']);
}

if (!($conn = oci_connect("db2018975058", "db85638267", "localhost/course")))
	p_error("Connection Failed ...");

$key_title = isset($_POST['title']) ? $_POST['title'] : '';
$start_length = isset($_POST['start_length']) ? (int) $_POST['start_length'] : 0;
$end_length = !empty($_POST['end_length']) ? (int) $_POST['end_length'] : PHP_INT_MAX;
$birthyear = isset($_POST['birthyear']) ? (int) $_POST['birthyear'] : 0;
$gender = isset($_POST['gender']) ? $_POST['gender'] : '';
$like = isset($_POST['like']) ? $_POST['like'] : '';

$query = "select title, year, movieexec.name prodname, studioname stdname, studio.address stdaddress from movie, movieexec, studio where producerno = certno and studioname = studio.name and length >= $start_length and length <= $end_length";

if (strpos($key_title, "'") !== false)
	$key_title = str_replace("'", "''", $key_title);
if (strpos($key_title, "%") !== false)
	$key_title = str_replace("%", "\\%", $key_title);
if (strpos($key_title, "_") !== false)
	$key_title = str_replace ("_", "\\_", $key_title);
if ($like == "like") {
	$query .= " and lower(title) like lower('%$key_title%') escape '\\'";
} else {
	$query .= " and lower(title) = lower('$key_title')";
}

//if ($gender !== '')
//	$query .= " and trim(gender) = '$gender'";
if ($birthyear !== 0 and $gender !== '')
	$query .= " and (title,year) in (select movietitle,movieyear from moviestar,starsin where starname = name and birthdate >= to_date('$birthyear-01-01') and gender = '$gender' ) ";
if ($birthyear == 0 and $gender !== '')
	$query .= " and (title,year) in (select movietitle,movieyear from moviestar,starsin "
		. "where starname = name and gender = '$gender' ) ";
if ($birthyear !== 0 and $gender == '')
	$query .= " and (title,year) in (select movietitle,movieyear from moviestar,starsin "
		. "where starname = name and birthdate >= to_date('$birthyear-01-01')) ";

//if ($birthyear !== 0)
//	$query .= " and birthdate >= to_date('$birthyear-01-01')";

$stmt = oci_parse($conn, $query);
if (!$stmt)
	p_error("SQL Parsing Faild...");

oci_define_by_name($stmt, "TITLE", $title);
oci_define_by_name($stmt, "YEAR", $year);
oci_define_by_name($stmt, "PRODNAME", $prodname);
oci_define_by_name($stmt, "STDNAME", $stdname);
oci_define_by_name($stmt, "STDADDRESS", $address);

if (!oci_execute($stmt))
	p_error("Execution Failed...");

print "<style> a { color: #eee8d5; } </style>";
print "<TABLE border=1 cellspacing=2>\n";
print "<TR align=center><TH> 영화제목 <TH> 개봉년도 <TH> 제작자 이름 <TH> 영화사 이름 <TH> 영화사 주소\n";

while (oci_fetch($stmt)) {
	if ($like == "like") {
		$title = htmlspecialchars($title, ENT_QUOTES);
		$key_title = str_replace("''", "&#039;", $key_title);
		$title = preg_replace("/($key_title)/i", "<span class = 'highlight'>$1</span>", $title);
	}

	print "<TR> <TD> $title <TD> $year <TD> $prodname <TD> $stdname <TD> $address </TR>\n";
}

print "</TABLE>\n";

oci_free_statement($stmt);
oci_close($conn);
?>

<style>
	body {
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	    background-color: skyblue;
	    color: #333;
	    margin: 0;
	    padding: 0;
	}

	table {
	    margin: 20px auto;
	    border-collapse: collapse;
	    width: 90%;
	    max-width: 1000px;
	}

	th {
	    background-color: #4CAF50;
	    color: white;
	    padding: 10px;
	    text-align: center;
	}

	td {
	    background-color: #002b36;
	    color: #eee8d5;
	    padding: 10px;
	    text-align: center;
	}

	tr:hover {
	    background-color: #30414f;
	}

	a {
	    color: #eee8d5;
	    text-decoration: none;
	}

	a:hover {
	    color: #4CAF50;
	}
	.highlight {
	    background-color: yellow;
	    color: #002b36;
	}
</style>
