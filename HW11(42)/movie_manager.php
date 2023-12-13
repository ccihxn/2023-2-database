<?php

// for correct error message outputs
//putenv("NLS_LANG=KOREAN_KOREA.AL32UTF8");
function p_error ($e_message,$stmt=null) {
    print "<font color=red>".$e_message."</font><br>";
    $e = oci_error($stmt);
    print htmlentities($e['message']);
    print htmlentities($e['sqltext']);
    print "<pre>";
    printf("%".($e['offset']+1)."s","^");
    print "</pre>";
    exit();
}

function MovieExists($conn, $title, $year) {
	$stmt2 = oci_parse($conn,"select * from movie where title = '$title' and year = $year");
	if (!$stmt2)    p_error("SQL Parsing Failed ...");
	if (!oci_execute($stmt2)) p_error ("Execution Failed ...",$stmt2);
	$cnt = oci_fetch_all($stmt2, $output);
	if($cnt > 0) {
	    return true;
	}
	return false;
}

function YearException($year) {
    return $year <= 1900 || $year > 2023;
}

function TitleYearRequired($title, $year) {
    if (empty($title) || $year == null) {
        return true;
    }
    return false;
}

function LengthException($conn, $length) {
    if ($length <= 50 && $length !== null) return true;
    return false;
}

function ProdNothing($conn, $prodno) {
    $stmt2 = oci_parse($conn,"select * from movieexec where certno = :prodno");
    oci_bind_by_name($stmt2, ":prodno", $prodno);
    if (!$stmt2)    p_error("SQL Parsing Failed ...");
    if (!oci_execute($stmt2)) p_error ("Execution Failed ...",$stmt2);
    $cnt = oci_fetch_all($stmt2, $output);
    if ($cnt == 0) return true;
    return false;
}

function StudioNothing($conn, $stdname) {
    $stmt2 = oci_parse($conn,"select * from studio where name = '$stdname'");
    if (!$stmt2)    p_error("SQL Parsing Failed ...");
    if (!oci_execute($stmt2)) p_error ("Execution Failed ...",$stmt2);
    $cnt = oci_fetch_all($stmt2, $output);
    if ($cnt == 0) return true;
    return false;
}

function SelectionNothing($conn, $title, $year, $length, $prodno, $stdname) {
	$title = htmlspecialchars($title, ENT_QUOTES, 'UTF-8');
	$query = "select * from movie where lower(title) like lower('%$title%')";
	if ($year !== null && year) $query .= " and year = $year";
	if ($length !== null) $query .= " and length = $length";
	if ($prodno !== null) $query .= " and producerno = $prodno";
	if (!empty($stdname)) $query .= " and studioname = $stdname";
	$stmt2 = oci_parse($conn,$query);
	if (!$stmt2)    p_error("SQL Parsing Failed ...");
	if (!oci_execute($stmt2)) p_error ("Execution Failed ...",$stmt2);
	$cnt = oci_fetch_all($stmt2, $output);
	if($cnt == 0) {
	    return true;
	}
	return false;
}

if (!($conn = oci_connect("db2018975058", "db85638267", "localhost/course"))) p_error("Connection Failed ..");
$titles = $_POST["titles"];
$title = $_GET["title"];
$year = (int) $_GET["year"];
if (isset($_GET["year"])) {
    $year = $_GET["year"] === '' ? null : (int)$_GET["year"];
} else {
    $year = null;
}
if (isset($_GET["length"])) {
    $length = $_GET["length"] === '' ? null : (int)$_GET["length"];
} else {
    $length = null;
}
if (isset($_GET["prodno"])) {
    $prodno = $_GET["prodno"] === '' ? null : (int)$_GET["prodno"];
} else {
    $prodno = null;
}
$stdname = $_GET["stdname"];
$action = $_GET["action"];


$isException = false;
if ($action == "삽입") {
	$title = htmlspecialchars($title, ENT_QUOTES, 'UTF-8');
	if(MovieExists($conn, $title, $year)) {
		print "<b style ='color:red';> 영화  [$title($year)] 는 이미 존재하는 데이터 입니다.</b><br>\n";
		$isException = true;
	} // 주키(primary key) 중복
	if (TitleYearRequired($title, $year)) { // 주키(primary key) is never null.
		print "<b style='color:red;'>영화 제목과 개봉연도는 필수 입력 조건입니다.</b><br>\n";
		$isException = true;
	} else if (YearException($year)) { // 개봉년도에 대한 제약 위반
		print "<b style ='color:red';> 적절하지 않은 개봉년도 범위입니다. (1901~2023) </b><br>\n";
		$isException = true;
	}
	if ($length !== null && LengthException($conn, $length)) { // 상영 시간에 대한 제약 위반
		print "<b style ='color:red';> 상영시간은 50분을 초과해야합니다. </b><br>\n";
		$isException = true;
	}
	if ($prodno !== null && ProdNothing($conn, $prodno)) { // 제작자 번호에 대한 참조무결성 제약 위반
		print "<b style ='color:red';> $prodno 번 제작자는 존재하지 않는 임원입니다. </b><br>\n";
		$isException = true;
	}
	if ($stdname != null && StudioNothing($conn, $stdname)) { // 영화사에 대한 참조무결성 제약 위반
		print "<b style ='color:red';> [$stdname] 라는 이름을 가진 STUDIO가 없습니다. </b><br>\n";
		$isException = true;
	}
	if ($isException) exit();
	$stmt = oci_parse($conn,
	 "insert into movie(title, year, length, producerno, studioname) values (:title,:year,:length,:prodno,:stdname) ");
	if (!$stmt) p_error("SQL Parsing Failed ...");
	
	oci_bind_by_name($stmt, ":title", $title);
	oci_bind_by_name($stmt, ":year", $year);
	oci_bind_by_name($stmt, ":length", $length);
	oci_bind_by_name($stmt, ":prodno", $prodno);
	oci_bind_by_name($stmt, ":stdname", $stdname);
	
	if (!oci_execute($stmt)) {
		$e = oci_error($stmt);
		print "<b> <{$e['code']}></b>";
		p_error ("Execution Failed ...",$stmt);
	}

	print "<TABLE class='styled-table'>\n";
	print "<TR class='table-header'><TH> 영화제목 <TH> 연도 <TH> 상영시간 <TH> 영화사 <TH> 제작자 <TH> 삭제 </TR>\n";

	$select_query = "select title, year, length, studioname, name from movie left join movieexec on certno = producerno ";
	$select_where = "where lower(title) like lower('%$title%') escape '\\'";
	if ($year != 0 && !empty($year)) $select_where .= " and year = $year";
	if ($length != 0 && !empty($length)) $select_where .= " and length = $length";
	if ($prodno != 0 && !empty($prodno)) $select_where .= " and producerno = $prodno";
	if (!empty($stdname)) $select_where .= " and studioname = '$stdname'";
	$stmt = oci_parse($conn, $select_query.$select_where);
	if (!$stmt) p_error("SQL Parsing Failed ...");
	if (!oci_execute($stmt)) p_error (oci_error($stmt), $stmt);
	print "<form method='post' action='movie_manager.php'>";
	while ($row = oci_fetch_array($stmt)) {
		$row[0] = htmlspecialchars($row[0], ENT_QUOTES);
			$title = str_replace("''", "&#039;", $title);
			$row[0] = preg_replace("/($title)/i", "$1", $row[0]);
		print "<TR class='table-row'> <TD width=40%> $row[0] <TD width=6%> $row[1] <TD width=12%> $row[2] <TD width=16%> $row[3] <TD width=14%> $row[4] <TD width=5% align=center> <input type='checkbox' name = 'titles[]' value='{$row[0]}__{$row[1]}'> </TR>\n";
	}
	print "<TR><TD colspan='6'> <input type='submit' name='submit' value='삭제'></TR>";
	print "</TABLE>\n";
	print "</form>";
}

if ($action == "검색") {
	if (strpos($title, "'") !== false)
		$title = str_replace("'", "''", $title);
	if (strpos($title, "%") !== false)
		$title = str_replace("%", "\\%", $title);
	if (strpos($key_title, "_") !== false)
		$title = str_replace ("_", "\\_", $title);
	if(SelectionNothing($conn, $title, $year, $length, $prodno, $stdname)) {
		print "<b style ='color:red';> 해당 검색 조건에 일치하는 데이터가 없습니다. </b><br>\n";
		exit();
	}
	print "<h2 align=center>검색된 튜플들</h2>";
	print "<TABLE class='styled-table'>\n";
	print "<TR class='table-header'><TH> 영화제목 <TH> 연도 <TH> 상영시간 <TH> 영화사 <TH> 제작자 <TH> 삭제 </TR>\n";

	$select_query = "select title, year, length, studioname, name from movie left join movieexec on certno = producerno ";
	$select_where = "where lower(title) like lower('%$title%') escape '\\'";
	if ($year != 0 && !empty($year)) $select_where .= " and year = $year";
	if ($length != 0 && !empty($length)) $select_where .= " and length = $length";
	if ($prodno != 0 && !empty($prodno)) $select_where .= " and producerno = $prodno";
	if (!empty($stdname)) $select_where .= " and studioname = '$stdname'";
	$stmt = oci_parse($conn, $select_query.$select_where);
	if (!$stmt) p_error("SQL Parsing Failed ...");
	if (!oci_execute($stmt)) p_error (oci_error($stmt), $stmt);
	print "<form method='post' action='movie_manager.php'>";
	while ($row = oci_fetch_array($stmt)) {
		$row[0] = htmlspecialchars($row[0], ENT_QUOTES);
		$title = str_replace("''", "&#039;", $title);
		$row[0] = preg_replace("/($title)/i", "$1", $row[0]);
		$lengthValue = $row[2] !== null ? $row[2] : '';
		$stdnameValue = $row[3] !== null ? $row[3] : '';
		$prodnoValue = $row[4] !== null ? $row[4] : '';
		print "<TR class='table-row'> <TD width=40%> $row[0] <TD width=6%> $row[1] <TD width=12%> $lengthValue <TD width=16%> $stdnameValue <TD width=14%> $prodnoValue <TD width=5% align=center> <input type='checkbox' class='delete-checkbox' name='titles[]' value='{$row[0]}__{$row[1]}'> </TR>\n";
	}
	print "<TR><TD colspan='6'> <input type='submit' name='submit' value='삭제'></TR>";
	print "</TABLE>\n";
	print "</form>";
}
if ($action == "갱신") {
	$title = htmlspecialchars($title, ENT_QUOTES, 'UTF-8');
	if (TitleYearRequired($title, $year)) {
		print "<b style='color:red;'>영화 제목과 개봉연도는 필수 입력 조건입니다.</b><br>\n";
		$isException = true;
	} else if (YearException($year)) {
		print "<b style ='color:red';> 적절하지 않은 개봉년도 범위입니다. (1901~2023) </b><br>\n";
		$isException = true;
	}
	if ($length !== null && LengthException($conn, $length)) {
		print "<b style ='color:red';> 상영시간은 50분을 초과해야합니다. </b><br>\n";
		$isException = true;
	}
	if ($prodno !== null && ProdNothing($conn, $prodno)) {
		print "<b style ='color:red';> $prodno 번 제작자는 존재하지 않는 임원입니다. </b><br>\n";
		$isException = true;
	}
	if ($stdname != null && StudioNothing($conn, $stdname)) {
		print "<b style ='color:red';> [$stdname] 라는 이름을 가진 STUDIO가 없습니다. </b><br>\n";
		$isException = true;
	}
	if ($isException) exit();
	if ($length == 0) $length = null;
	if ($prodno == 0) $prodno = null;
	$update_parts = array();
	if ($length != 0 && !empty($length)) $update_parts[] = "length = $length";
	if ($prodno != 0 && !empty($prodno)) $update_parts[] = "producerno = $prodno";
	if (!empty($stdname)) $update_parts[] = "studioname = '$stdname'";
	if (!empty($update_parts)) {
		$update_query = "update movie set " . implode(", ", $update_parts) . " where lower(title) = lower('$title') and year = $year";
		print "<br>".$update_query;
		$stmt = oci_parse($conn, $update_query);
		if (!$stmt) p_error("SQL Parsing Failed ...");
		if (!oci_execute($stmt)) {
			$e = oci_error($stmt);
			print "<b> <{$e['code']}></b>";
			p_error ("Execution Failed ...",$stmt);
		}
		print "<form method='post' action='movie_manager.php'>";
		
		if ($length == 0) {
			$length_stmt = oci_parse($conn, "select length from movie where lower(title) = lower('$title') and year = $year");
			if (!$length_stmt) p_error("Studio1 SQL Parsing Faild...");
			if (!oci_execute($length_stmt)) p_error ("Studio Execution Failed..."); 
			$length = oci_fetch_array($length_stmt)[0];
		}
		$prodname_stmt = oci_parse($conn, "select name from movie left join movieexec on certno = producerno where lower(title) = lower('$title') and year = $year");
		if (!$prodname_stmt) p_error("Studio SQL Parsing Faild...");
		if (!oci_execute($prodname_stmt)) p_error ("Studio Execution Failed...");
		$prodname = oci_fetch_array($prodname_stmt)[0];
		if (empty($stdname)) {
			$stdname_stmt = oci_parse($conn, "select studioname from movie where lower(title) = lower('$title') and year = $year");
			if (!$stdname_stmt) p_error("Studio3 SQL Parsing Faild...");
			if (!oci_execute($stdname_stmt)) p_error (oci_error($stmt), $stmt);
			$stdname = oci_fetch_array($stdname_stmt)[0];
		}
		if (!oci_execute($stmt)) {
			$e = oci_error($stmt);
			print "<b> <{$e['code']}></b>";
			p_error ("Execution Failed ...",$stmt);
		}
		$lengthValue = $length !== null ? $length : '';
		$stdnameValue = $stdname !== null ? $stdname : '';
		$prodnoValue = $prodname !== null ? $prodname : '';
	} else print "<b style='color:red;'>[변경된 내역이 없습니다.] </b><br>\n";
	print "<TABLE class='styled-table'>\n";
	print "<TR class='table-header'><TH> 영화제목 <TH> 연도 <TH> 상영시간 <TH> 영화사 <TH> 제작자 <TH> 삭제 </TR>\n";
	print "<TR class='table-row'> <TD width=40%> $title <TD width=6%> $year <TD width=12%> $lengthValue <TD width=16%> $stdnameValue <TD width=14%> $prodnoValue <TD width=5% align=center> <input type='checkbox' class='delete-checkbox' name='titles[]' value='{$title}__{$year}'> </TR>\n";
	print "<TR><TD colspan='6'> <input type='submit' name='submit' value='삭제'></TR>";
	print "</TABLE>\n";
	print "</form>";
}
if (!empty($titles)) {
	print "<TABLE class='styled-table'>\n";
	print "<TR class='table-header'><TH> 영화제목 <TH> 연도 </TR>\n";
	for ($i = 0; $i<count($titles); $i++) {
		$tmp = explode("__", $titles[$i]);
		$delete = oci_parse($conn, "delete from movie where title = '$tmp[0]' and year =$tmp[1]");
		if (!oci_execute($delete)) p_error (oci_error($stmt), $delete);
		print "<TR class='table-row'> <TD> $tmp[0] <TD> $tmp[1] </TR>\n";
	}
	print "</TABLE>\n";
}
oci_free_statement($stmt);
oci_close($conn);
?> 
<style>
    .styled-table {
	margin-left: auto;
	margin-right: auto;
        border-collapse: collapse;
        font-size: 0.9em;
        font-family: sans-serif;
        min-width: 400px;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
    }
    .styled-table thead tr {
        background-color: #009879;
        color: #ffffff;
        text-align: left;
    }
    .styled-table th,
    .styled-table td {
        padding: 12px 15px;
    }
    .styled-table tbody tr {
        border-bottom: 1px solid #dddddd;
    }
    .styled-table tbody tr:nth-of-type(even) {
        background-color: #f3f3f3;
    }
    .styled-table tbody tr:last-of-type {
        border-bottom: 2px solid #009879;
    }
    .styled-table tbody tr.active-row {
        font-weight: bold;
        color: #009879;
    }
    .delete-checkbox {
        cursor: pointer;
    }
</style>