<?php

function p_error ($e_message) {
	print "<font color=red>".$e_message."</font>";
        $e = oci_error();
        print htmlentities($e['message']);
}

print '<style>body { background-color: #002b36; }</style>';
if(!($conn = oci_connect("db2018975058","db85638267", "localhost/course"))) p_error("Connection Failed ...");

$statement = oci_parse($conn, "select studio.name studioname, studio.address studioaddress, presno, movieexec.name presname, movieexec.address presaddress, networth, count(title) moviecount from studio inner join movie on name = studioname, movieexec where presno = certno group by studio.name, studio.address, presno, movieexec.name, movieexec.address, networth order by studio.name");
if (!$statement)	p_error("SQL Parsing Failed...");

oci_define_by_name($statement, "STUDIONAME", $studioname);
oci_define_by_name($statement, "MOVIECOUNT", $moviecount);

if (!oci_execute($statement))	p_error("Execution Failed...");

print "<style> a { color: #eee8d5; } </style>";
print "<TABLE bgcolor=#002b36 border=1 cellspacing=2>\n";
print "<TR bgcolor=#eee8d5><TH style='color: #002b36;'> 영화사 <TH style='color: #002b36;'> 제작한 영화수 \n";

while (oci_fetch($statement)) {
	
	
	print "<TR> <TD style='color: #eee8d5;'> <a href='2-1.php?studioname=$studioname'>$studioname</a> <TD style='color: #eee8d5;'> <a href='2-1.php?studioname=$studioname&moviecount=true'>$moviecount</a> </TR>\n";

}
print "</TABLE>\n";

print "<br><a href='.'>홈으로 돌아가기</a>";

oci_free_statement($statement);
oci_close($conn);
?>
