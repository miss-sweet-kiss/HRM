package dbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import logic.EmployeePost;
import logic.Post;

public class Employee_Post_DAO {
	private static Employee_Post_DAO singletonAccessor;
	private Connection con;

	// скрытый конструктор принимает драйвер и адрес БД
	// выбрасывает исключение Exception
	@SuppressWarnings("static-access")
	private Employee_Post_DAO(String server, String urlDatabase) throws Exception {

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
	public static Employee_Post_DAO getInstance(String _driver, String _urlDatabase)
			throws Exception {
		if (singletonAccessor == null)
			singletonAccessor = new Employee_Post_DAO(_driver, _urlDatabase);
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

	public Vector<Vector<Object>> getPostsByEmp(Integer id) throws SQLException {
		Vector<Vector<Object>> data = new Vector<Vector<Object>>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT Post.id, postName, department, EmployeePost.rate FROM Post, EmployeePost where idEmp="+id+" and post.id = EmployeePost.idPost");
		while (rs.next()) {
			Vector<Object> tempData = new Vector<Object>();
			tempData.add(new Post(rs.getInt("Post.id"), rs.getString("postName"), rs.getString("department")));
			tempData.add(new String(rs.getString("EmployeePost.rate")));
			data.add(tempData);
		}
		stat.close();
		return data;
	}
	
	public Integer addRate(EmployeePost ep) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from EmployeePost where idEmp='"+ ep.getIdEmp()+"' and idPost='"+ep.getIdPost()+"'");
		if (!(rs.next())) {
			int n = stat.executeUpdate("INSERT INTO EmployeePost (idEmp, idPost, rate) VALUES('" + ep.getIdEmp() + "','" + ep.getIdPost() + "','"+ep.getRate()+"')");
			if (n > 0) {
				System.out.println("Execute = "+n);
				rs.close();
				return 1;
			} else {
					rs.close();
					return 2;
				}			
		} else {
			System.out.println(rs.next());
			rs.close();
			return 3;
		}
	}
	
	public boolean deleteRate(EmployeePost ep) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from EmployeePost where idEmp="+ ep.getIdEmp() + " and idPost="+ep.getIdPost());
		if (rs.next()) {
			int n = stat.executeUpdate("DELETE FROM EmployeePost WHERE idEmp="+ ep.getIdEmp() + " and idPost="+ep.getIdPost());
			if (n > 0) {
				System.out.println("Execute = "+n);
				rs.close();
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
	
	public boolean deleteEmployeeRate(Integer id) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from EmployeePost where idEmp="+ id);
		if (rs.next()) {
			int n = stat.executeUpdate("DELETE FROM EmployeePost WHERE idEmp="+ id);
			if (n > 0) {
				System.out.println("Execute = "+n);
				rs.close();
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

	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		Employee_Post_DAO ac = new Employee_Post_DAO("localhost", "system");
	}


}
