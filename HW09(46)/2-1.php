<?php

function p_error ($e_message) {
	print "<font color=red>".$e_message."</font>";
        $e = oci_error();
        print htmlentities($e['message']);
}

print '<style>body { background-color: #002b36; }</style>';
if(!($conn = oci_connect("db2018975058","db85638267", "localhost/course"))) p_error("Connection Failed ...");

if (isset ($_GET['studioname'])) {
	$select_studioname = $_GET['studioname'];
	if ($_GET['moviecount']) {
		$movie_statement = oci_parse($conn, "select title, year, length, name from movie, movieexec where studioname = '$select_studioname' and producerno = certno");
		if (!$movie_statement) p_error("Movie SQL Parsing Faild...");
		if (!oci_execute($movie_statement)) p_error ("movie Execution Failed...");
		
		print "<br><TABLE bgcolor=#002b36 border=1 cellspacing=2>\n";
		print "<TR bgcolor=#eee8d5><TH style='color: #002b36;'> 영화 제목 <TH style='color: #002b36;'> 개봉년도 <TH style='color: #002b36;'> 상영시간 <TH style='color: #002b36;'> 제작자 이름 \n";

		while ($row = oci_fetch_assoc($movie_statement)) {

			print "<TR> <TD style='color: #eee8d5;'>" . $row['TITLE'] . " <TD style='color: #eee8d5;'> " . $row['YEAR'] . " <TD style='color: #eee8d5;'> " . $row['LENGTH'] . " <TD style='color: #eee8d5;'> " . $row['NAME'] . " </TR>\n";

			}
	} else {
		$studio_statement = oci_parse($conn, "select studio.address studioaddress, movieexec.name presname, movieexec.address presaddress, networth from studio, movieexec where studio.name = '$select_studioname' and presno = certno");
		if (!$studio_statement) p_error("Studio SQL Parsing Faild...");
		if (!oci_execute($studio_statement)) p_error ("Studio Execution Failed...");
		while ($row = oci_fetch_assoc($studio_statement)) {
		    print "<br><TABLE bgcolor=#002b36 border=1 cellspacing=2>\n";
		    print "<TR bgcolor=#eee8d5><TH style='color: #002b36;'> 영화사 이름 <TH style='color: #002b36;'> 영화사 주소 <TH style='color: #002b36;'> 사장 이름 <TH style='color: #002b36;'> 사장의 주소 <TH style='color: #002b36;'> 재산 액수 \n";
		    print "<TR> <TD style='color: #eee8d5;'>$select_studioname <TD style='color: #eee8d5;'> " . $row['STUDIOADDRESS'] . " <TD style='color: #eee8d5;'> " . $row['PRESNAME'] . " <TD style='color: #eee8d5;'> " . $row['PRESADDRESS'] . " <TD style='color: #eee8d5;'>  " . $row['NETWORTH'] . " </TR>\n";
		
		}
	}
	print "</TABLE>\n";
}

print "<br><a href='2.php'>돌아가기</a>";

oci_free_statement($studio_statement);
oci_close($conn);

?>