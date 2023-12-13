import oracle.jdbc.pool.OracleDataSource;
import java.sql.*;

public class InsertMovies {
    public static void main(String[] args) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        int[] rst = null;
        String movSQL = "insert into movie(title, year, length) values(?, ?, ?)";
        String TT = "ZZ_";
        try {
            conn = Connect("db2018975058", "db85638267");
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            stmt = conn.prepareStatement(movSQL);
            for (int i = 15; i >= 0; i--) {
                stmt.setString(1, TT + (i + 1));
                stmt.setInt(2, 2023);
                stmt.setInt(3, 123);
                stmt.addBatch();
//                if (i > 9) conn.setSavepoint();
            }

            rst = stmt.executeBatch();
            System.out.printf("%d tuples inserted\n", rst.length);

            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
            conn.commit();
        } catch (SQLException e) {
            printSQLerr(e);
            conn.rollback();
        }

    }
    private static void printSQLerr(SQLException e) {
        int i = 1;
        while (e != null) {
            System.out.printf("(%d) [%d] %s\n", i, e.getErrorCode(), e.getMessage());
            e = e.getNextException();
        }
    }
    private static Connection Connect(String user, String passwd) throws SQLException {
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
