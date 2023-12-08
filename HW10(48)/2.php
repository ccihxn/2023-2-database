<?php

function p_error($e_message) {
	print "<font color=red>" . $e_message . "</font>";
	$e = oci_error();
	print htmlentities($e['message']);
}

$conn = oci_connect("db2018975058", "db85638267", "localhost/course");
if (!$conn)
	p_error();
$stmt = oci_parse(
	$conn,
	"select name,address from movieexec order by 1 "
);
if (!$stmt)
	p_error();
if (!oci_execute($stmt))
	p_error();

print "<TABLE border=1 cellspacing=2>\n";
print "<TR align=center><TH class = title> 순번 <TH class = title> 이름 <TH class = title> 주소 <TH class = title> 영화사 "
	. "<TH class = title> 제작한 영화 <TH class = title> 출연한 영화 </TR>\n";

$nrows = oci_fetch_all($stmt, $row, null, null, OCI_FETCHSTATEMENT_BY_ROW);
if ($nrows > 0) {
	for ($i = 0; $i < $nrows; $i++) {
		$name = $row[$i]['NAME'];
		$std_name = oci_parse($conn, "select name sname from studio where presno in (select certno from movieexec where name = '$name' ) ");
		$prod_title = oci_parse($conn, "select title,year from movie where producerno in (select certno from movieexec where name = '$name' ) order by 2");
		$acting_title = oci_parse(
			$conn, "select title,year from movie where (title,year) in (select movietitle,movieyear "
			. "from starsin where starname = '$name' ) order by 2 "
		);
		if (!$std_name)
			p_error();
		if (!$prod_title)
			p_error();
		if (!$acting_title)
			p_error();
		if (!oci_execute($std_name))
			p_error();
		if (!oci_execute($prod_title))
			p_error();
		if (!oci_execute($acting_title))
			p_error();
		$std_cnt = oci_fetch_all($std_name, $prod_rows, null, null, OCI_FETCHSTATEMENT_BY_ROW);
		$prod_cnt = oci_fetch_all($prod_title, $prod_count, null, null, OCI_FETCHSTATEMENT_BY_ROW);
		$acting_cnt = oci_fetch_all($acting_title, $st_count, null, null, OCI_FETCHSTATEMENT_BY_ROW);
		$tmp_std_cnt = $std_cnt;
		$tmp_prod_cnt = $prod_cnt;
		$tmp_acting_cnt = $acting_cnt;

		if ($std_cnt == 0 and ($prod_cnt != 0 or $acting_cnt != 0))
			$tmp_std_cnt = 1;
		if ($prod_cnt == 0 and ($std_cnt != 0 or $acting_cnt != 0))
			$tmp_prod_cnt = 1;
		if ($acting_cnt == 0 and ($prod_cnt != 0 or $prod_cnt != 0))
			$tmp_acting_cnt = 1;
		if ($acting_cnt == 0 and $prod_cnt == 0 and $prod_cnt == 0)
			$total_rowspan = 1;
		else {
			$total_rowspan = $tmp_std_cnt * $tmp_prod_cnt * $tmp_acting_cnt;
			$std_rowspan = $total_rowspan / $tmp_std_cnt;
			$prod_rowspan = $total_rowspan / $tmp_prod_cnt;
			$acting_rowspan = $total_rowspan / $tmp_acting_cnt;
		}

		for ($j = 0; $j < $total_rowspan; $j++) {
			if ($j == 0) {
				$real_count = $i + 1;
				print "<TR> <TD class = id rowspan=$total_rowspan> $real_count <TD class = gray rowspan=$total_rowspan> $name <TD class = gray align = center rowspan=$total_rowspan> {$row[$i]['ADDRESS']} ";
				if ($std_cnt == 0)
					print "<td class = color rowspan=$total_rowspan> <span style='background-color: red;'>없음</span>";
				else
					print "<td class = text rowspan=$std_rowspan> {$prod_rows[$j]['SNAME']}";
				if ($prod_cnt == 0)
					print "<td class = color rowspan=$total_rowspan> <span style='background-color: red;'>없음</span>";
				else
					print "<td class = text rowspan=$prod_rowspan> {$prod_count[$j]['TITLE']}<span class = year>({$prod_count[$j]['YEAR']})</span>";
				if ($acting_cnt == 0)
					print "<td class = color rowspan=$total_rowspan> <span style='background-color: red;'>없음</span>";
				else
					print "<td class = text rowspan=$acting_rowspan> {$st_count[$j]['TITLE']}<span class = year>({$st_count[$j]['YEAR']})</span>";
			} else {
				print "<TR>";
				if ($std_cnt != 0 and $j % $std_rowspan == 0) {
					print "<td class = text rowspan=$std_rowspan> {$prod_rows[$j / $std_rowspan]['SNAME']}";
				}
				if ($prod_cnt != 0 and $j % $prod_rowspan == 0) {
					print "<td class = text rowspan=$prod_rowspan> {$prod_count[$j / $prod_rowspan]['TITLE']}<span class = year>({$prod_count[$j / $prod_rowspan]['YEAR']})</span>";
				}
				if ($acting_cnt != 0 and $j % $acting_rowspan == 0) {
					print "<td class = text rowspan=$acting_rowspan> {$st_count[$j / $acting_rowspan]['TITLE']}<span class = year>({$st_count[$j / $acting_rowspan]['YEAR']})</span>";
				}
			}print "</tr> \n";
		}
		print "</tr> \n";
	}
} else {
	print "<td colspan=3>No Data Found";
}

print "</TABLE>\n";

oci_free_statement($stmt);
oci_close($conn);
?>
<style>
	body {
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	    background-color: skyblue;
	    margin: 0;
	    padding: 0;
	    color: #333;
	}

	table {
	    margin: 20px auto;
	    border-collapse: collapse;
	    width: 90%;
	    max-width: 1000px;
	}

	th, .id {
	    background-color: #4CAF50;
	    color: white;
	    font-weight: normal;
	    padding: 10px;
	    text-align: center;
	}

	td {
	    background-color: #002b36;
	    color: #eee8d5;
	    padding: 10px;
	    text-align: center;
	}

	.color, .empty {
	    background-color: #002b36;
	    color: white;
	}

	.empty {
	    font-style: italic;
	}

	.text {
	    color: #eee8d5;
	}

	.year {
	    color: #f0ad4e;
	    font-weight: bold;
	}

	.no-data-found {
	    text-align: center;
	    padding: 20px;
	    background-color: #002b36;
	    color: #eee8d5;
	}

	tr:hover {

	</style>