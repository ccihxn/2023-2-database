import oracle.jdbc.pool.OracleDataSource;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.*;
import java.time.LocalDate;

public class Movies {
    public static void main(String[] args) throws IOException {
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(System.out));
        Connection conn = null;
        Statement stmt = null;
        ResultSet rst = null;
        String movSQL = "select movietitle tt, movieyear yy from starsin where starname = ?";
        try {
            conn = Connect("db2018975058", "db85638267");
            stmt = conn.createStatement();
//            rst = stmt.executeQuery("select * from movie");
//            while (rst.next()) {
//                System.out.printf("[%s(%d) %d분 %s 제작\n", rst.getString("title"), rst.getInt("year"), rst.getInt("length"), rst.getString("studioname"));
////                writer.append(rst.getString(1)).append("\n");
//            }
            rst = stmt.executeQuery("select * from moviestar");
            while (rst.next()) {
                PreparedStatement stmt2 = null;
                ResultSet rst2 = null;
                String name;
                LocalDate bDate = rst.getObject("birthdate", LocalDate.class);
                String birthD = bDate.getYear()+"년 " + bDate.getMonthValue() + "월 " + bDate.getDayOfMonth()+"일";
                name = rst.getString("name");
                System.out.printf("[%s(%s) %s에 거주(%s에 태어남)\n",
                        rst.getString("name"), rst.getString("gender").strip(),
                        rst.getString("address"), birthD);
                stmt2 = conn.prepareStatement(movSQL);
                stmt2.setString(1, name);
                rst2 = stmt2.executeQuery();
                while (rst2.next()) {
                    System.out.printf("\t- %s(%d)\n", rst2.getString("tt"), rst2.getInt("yy"));
                }
                rst2.close();
                stmt2.close();
            }
            writer.close();
            if (rst != null) rst.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            printSQLerr(e);
        }

    }
    static void printSQLerr(SQLException e) {
        int i = 1;
        while (e != null) {
            System.out.printf("(%d) [%d] %s\n", i, e.getErrorCode(), e.getMessage());
            e = e.getNextException();
        }
    }
    static Connection Connect(String user, String passwd) throws SQLException {
        String url = "jdbc:oracle:thin:@cs.ks.ac.kr:1521:course";
        // oracle = oracle driver, thin = thin type driver
        OracleDataSource ods = new OracleDataSource();
        ods.setUser(user);
        ods.setPassword(passwd);
        ods.setURL(url);

        Connection conn;
        conn = ods.getConnection();

        return conn;
    }
}
