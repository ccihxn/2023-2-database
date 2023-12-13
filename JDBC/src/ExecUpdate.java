import oracle.jdbc.pool.OracleDataSource;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.*;
import java.time.LocalDate;

public class ExecUpdate {
    public static void main(String[] args) throws IOException {
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(System.out));
        Connection conn = null;
        Statement stmt = null;
        ResultSet rst = null;
        String movSQL = "select name, address, certno, networth from movieexec";
        try {
            conn = Movies.Connect("db2018975058", "db85638267");
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            rst = stmt.executeQuery(movSQL);
            while (rst.next()) {
                String name;
                int cNo;
                String address;
                Long netWorth;

                name = rst.getString("name");
                cNo = rst.getInt("certno");
                address = rst.getString("address");
                netWorth = rst.getLong("networth");
                if (cNo % 3 == 0) {
                    rst.updateLong("networth", netWorth + 999);
                    rst.updateString("address", "부산시 남구 대연3동");
                    rst.updateRow();
                    address = rst.getString("address");
                    netWorth = rst.getLong("networth");
                } else if (cNo == 1) rst.deleteRow();
                else if (cNo == 10) {
                    rst.moveToInsertRow();
                    //insert할 새로운 빈 튜플로 이동
                    rst.updateInt("certno", 50);
                    rst.updateString("name", "경성대");
                    rst.updateLong("networth", 192992929239L);
                    //빈 튜플에 새로운 값들을 업데이트
                    rst.insertRow();
                    //새로운 튜플들이 들어간 로우를 직접 insert
                    rst.moveToCurrentRow();
                    //원래 가리키던 10번 로우로 돌아감
                }
                System.out.printf("[%s(%d) %s에 거주(재산: %d원)\n", name, cNo, address, netWorth);
            }
            writer.close();
            if (rst != null) rst.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            Movies.printSQLerr(e);
        }

    }
}
