package dbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import logic.PostFR;

public class Post_FR_DAO {
		private static Post_FR_DAO singletonAccessor;
		private Connection con;

		// скрытый конструктор принимает драйвер и адрес БД
		// выбрасывает исключение Exception
		@SuppressWarnings("static-access")
		private Post_FR_DAO(String server, String urlDatabase) throws Exception {

			String driverName = "com.mysql.jdbc.Driver";

			// Class.forName(driverName);
			this.getClass().forName(driverName);
			// формирование строки подключения
			String url = "jdbc:mysql://" + server + "/" + urlDatabase;
			String username = "root";
			String password = "65573";
			// подключение к БД
			con = DriverManager.getConnection(url, username, password);

		}

		// открытый метод получения единственного экземпляра аксесора
		// выбрасывает исключение Exception
		public static Post_FR_DAO getInstance(String _driver, String _urlDatabase)
				throws Exception {
			if (singletonAccessor == null)
				singletonAccessor = new Post_FR_DAO(_driver, _urlDatabase);
			return singletonAccessor;
		}

		// закрывает соединение с БД
		public void closeConnection() throws SQLException {
			if (con != null)
				con.close();
		}

		public void propertyStatement() throws SQLException {
			// проверка, реализует ли драйвер JDBC тот или иной тип выборки
			// TYPE_FORWARD_ONLY - курсор выборки перемещается только вперед
			// TYPE_SCROLL_INSENSITIVE - курсор перемещается в обеих направлениях,
			// выборка не изменяется
			// TYPE_SCROLL_SENSITIVE - курсор перемещается в обеих направлениях,
			// выборка изменяется при изменении строк в БД

			boolean ro = con.getMetaData().supportsResultSetType(
					ResultSet.TYPE_FORWARD_ONLY);
			System.out.println("TYPE_FORWARD_ONLY - " + ro);

			ro = con.getMetaData().supportsResultSetType(
					ResultSet.TYPE_SCROLL_INSENSITIVE);
			System.out.println("TYPE_SCROLL_INSENSITIVE - " + ro);

			ro = con.getMetaData().supportsResultSetType(
					ResultSet.TYPE_SCROLL_SENSITIVE);
			System.out.println("TYPE_SCROLL_SENSITIVE - " + ro);

			// проверка, поддерживает ли драйвер JDBC тот или иной режим изменения
			// выборки
			// CONCUR_READ_ONLY - выборку нельзя изменять
			// CONCUR_UPDATABLE - выборку можно изменять
			ro = con.getMetaData().supportsResultSetConcurrency(
					ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			System.out.println("CONCUR_READ_ONLY - " + ro);

			ro = con.getMetaData().supportsResultSetConcurrency(
					ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			System.out.println("CONCUR_UPDATABLE - " + ro);

		}

		protected void finalize() {
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		
		public PostFR getRelationByPostFR(Integer post, Integer fr) throws SQLException {
			PostFR pf = null;
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * FROM Post_fr WHERE post = " +post+ " and fr = " +fr);
			while (rs.next()) {
				pf = new PostFR(rs.getInt("id"), rs.getInt("post"), rs.getInt("fr"), rs.getInt("X"), rs.getInt("O"), rs.getInt("R1"), rs.getInt("Y"), rs.getInt("K"));
			}
			stat.close();
			return pf;
		}
		
		public boolean addRelation(PostFR pf) throws SQLException {
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * from post_fr where post= " + pf.getPost() + " and fr= " + pf.getFR());
			if (!(rs.next())) {
				int n = stat.executeUpdate("INSERT INTO post_fr (X, O, R1, Y, K, post, fr) VALUES ("+pf.getX()+","+pf.getO()+","+pf.get1()+","+pf.getY()+","+pf.getK()+","+pf.getPost()+","+pf.getFR()+")");
				if (n > 0) {
					System.out.println("Execute = "+n);
					//rs.close();
					return true;
				} else {
						rs.close();
						return false;
					}			
			} else {
				System.out.println(rs.next());
				rs.close();
				return false;
			}
		}
		
		public boolean updateRelation(PostFR pf) throws SQLException {
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * from post_fr where post= " + pf.getPost() + " and fr= " + pf.getFR());
			if (rs.next()) {
				int n = stat.executeUpdate("update post_fr set X="+pf.getX()+", O="+pf.getO()+", R1="+pf.get1()+", Y="+pf.getY()+", K="+pf.getK()+" where post= " + pf.getPost() + " and fr= " + pf.getFR());
				//UPDATE table SET c=c+1 WHERE a=1 OR b=2 LIMIT 1
				if (n > 0) {
					System.out.println("Execute = "+n);
					rs.close();
					return true;
				} else {
						rs.close();
						return false;
					}			
			} else {
				rs.close();
				return addRelation(pf);
			}
		}
}