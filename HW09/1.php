<?php
function p_error ($e_message) {
	print "<font color=red>".$e_message."</font>";
        $e = oci_error();
        print htmlentities($e['message']);
}
echo '<style>body { background-color: #002b36; }</style>';
if(!($conn = oci_connect("db2018975058","db85638267", "localhost/course"))) p_error("Connection Failed ...");
$stmt = oci_parse($conn,
	"select title, year, length, studioname, name from movie,movieexec where producerno = certno order by year asc, length asc");
if (!$stmt) p_error("SQL Parsing Faild...");

oci_define_by_name($stmt,"TITLE",$title);
oci_define_by_name($stmt,"YEAR",$year);
oci_define_by_name($stmt,"LENGTH",$length);
oci_define_by_name($stmt,"NAME",$prodname);
oci_define_by_name($stmt,"STUDIONAME",$studioname);

if (!oci_execute($stmt)) p_error ("Execution Failed...");

print "<style> a { color: #eee8d5; } </style>";
print "<TABLE bgcolor=#002b36 border=1 cellspacing=2>\n";
print "<TR bgcolor=#eee8d5 align=center><TH style='color: #002b36;'> 제목 <TH style='color: #002b36;'> 연도 <TH style='color: #002b36;'> 상영시간 <TH style='color: #002b36;'> 제작자 <TH style='color: #002b36;'> 영화사 사장<TH style='color: #002b36;'>출연 배우 수<TH style='color: #002b36;'>출연 배우진\n";

while (oci_fetch($stmt)) {
	$pres_stmt = oci_parse($conn, "select movieexec.name presname from movieexec, studio where certno = presno and studio.name = '$studioname'");
	if (!$pres_stmt) p_error("Studio SQL Parsing Faild...");
	if (!oci_execute($pres_stmt)) p_error ("Studio Execution Failed...");
	$presname = oci_fetch_array($pres_stmt)[0];
	
	
	if (strpos($title, "'") != false) $select_title = str_replace("'", "''", $title);
	else $select_title = $title;
	$star_count_stmt = oci_parse($conn, "select count(*) from starsin where movietitle = '$select_title' and movieyear = $year");
	if (!$star_count_stmt) p_error("Star Count SQL Parsing Faild...");
	if (!oci_execute($star_count_stmt)) p_error ("Star Count Execution Failed...");
	$star_count = oci_fetch_array($star_count_stmt)[0];
	
	$stars = '';
	if ($star_count != 0) {
		$stars_stmt = oci_parse($conn, "select starname from starsin where movietitle = '$select_title' and movieyear = $year");
		if (!$stars_stmt) p_error("Stars SQL Parsing Faild...");
		if (!oci_execute($stars_stmt)) p_error ("Stars Execution Failed...");
//		if (!oci_execute($stars_stmt)) {
//			$error = oci_error($stars_stmt);
//			echo $error['message'];
//		}
		if ($star_count == 1) $stars = oci_fetch_array ($stars_stmt)[0];
		else {
			while ($starnames = oci_fetch_array($stars_stmt)) $stars .= $starnames['STARNAME'].',<br>';
			$stars = rtrim($stars,',<br>');
		}
	}
	else $stars = '정보 없음';
	
	if ($star_count == 0) $star_count = '정보없음';
	else $star_count = $star_count.'명';
	$year = $year.'년';
	$length = $length.'분';
	print "<TR> <TD style='color: #eee8d5;'> $title <TD style='color: #eee8d5;'> $year <TD style='color: #eee8d5;' align=right> $length<TD style='color: #eee8d5;'>$prodname<TD style='color: #eee8d5;'>$presname<TD style='color: #eee8d5;' align=right>$star_count<TD style='color: #eee8d5;'>$stars</TR>\n";
}
print "</TABLE>\n";

print "<br><a href='.'>홈으로 돌아가기</a>";

oci_free_statement($stmt);
oci_close($conn);
?>
