package dbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import logic.GroupFR;

public class GroupFR_DAO {
	private static GroupFR_DAO singletonAccessor;
	private Connection con;

	// скрытый конструктор принимает драйвер и адрес БД
	// выбрасывает исключение Exception
	@SuppressWarnings("static-access")
	private GroupFR_DAO(String server, String urlDatabase) throws Exception {

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
	public static GroupFR_DAO getInstance(String _driver, String _urlDatabase)
			throws Exception {
		if (singletonAccessor == null)
			singletonAccessor = new GroupFR_DAO(_driver, _urlDatabase);
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
	
	public Vector<GroupFR> getAllGroups() throws SQLException {
		Vector<GroupFR> vFR = new Vector<GroupFR>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM groupFR");
		while (rs.next()) {
			vFR.add(new logic.GroupFR(rs.getInt("id"), rs.getString("groupName"), rs.getInt("refGroup")));
		}
		stat.close();
		return vFR;
	}
	
	public Vector<GroupFR> getGroupsByEmp(Integer id) throws SQLException {
		Vector<GroupFR> vFR = new Vector<GroupFR>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT distinct groupFR.id, groupFR.groupName, groupFR.refGroup FROM groupFR, fr, post_fr, post, employeepost where fr.groupFR = groupFR.groupName and post_fr.fr = fr.id and post.id = post_fr.post and employeepost.idPost = post.id and employeepost.idEmp = "+ id);
		while (rs.next()) {
			vFR.add(new logic.GroupFR(rs.getInt("id"), rs.getString("groupName"), rs.getInt("refGroup")));
		}
		stat.close();
		return vFR;
	}
	
	public Integer addGroupFR(GroupFR group) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from groupfr where groupName= '" + group.getName() + "'");
		if (!(rs.next())) {
			int n = stat.executeUpdate("INSERT INTO groupfr (groupName) VALUES('" + group.getName() + "')");
			if (n > 0) {
				System.out.println("GroupFR added = "+n);
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
	
	public boolean updateGroupFR(GroupFR group) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from groupfr where id= " + group.getIdGroup());
		if (rs.next()) {
			int n = stat.executeUpdate("UPDATE groupfr SET groupName = '" + group.getName() + "' where id = " + group.getIdGroup());
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
	
	public Integer deleteGroupFR(Integer id) throws SQLException {
		Statement stat = con.createStatement();
		String group = new String();
		ResultSet rs = stat.executeQuery("SELECT * from groupfr where id= " + id);
		if (rs.next()) {
			group = rs.getString("groupName");
			rs = stat.executeQuery("SELECT * from fr where groupFR = '" + group + "'");
			if (!rs.next()) {
				int n = stat.executeUpdate("DELETE FROM groupfr WHERE id = " + id);
				if (n > 0) {
					System.out.println("Execute = "+n);
					rs.close();
					return 1;
				} else {
					rs.close();
					return 2;
				}			
			} else {
				rs.close();
				return 3;
			}	
		} else {
			rs.close();
			return 4;
		}
	}

	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		GroupFR_DAO ac = new GroupFR_DAO("localhost", "system");
	}
	
}
