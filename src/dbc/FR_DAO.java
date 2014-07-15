package dbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import logic.FR;

public class FR_DAO {
	private static FR_DAO singletonAccessor;
	private Connection con;

	// ������� ����������� ��������� ������� � ����� ��
	// ����������� ���������� Exception
	@SuppressWarnings("static-access")
	private FR_DAO(String server, String urlDatabase) throws Exception {

		String driverName = "com.mysql.jdbc.Driver";

		// Class.forName(driverName);
		this.getClass().forName(driverName);
		// ������������ ������ �����������
		String url = "jdbc:mysql://" + server + "/" + urlDatabase;
		String username = "root";
		String password = "65573";
		// ����������� � ��
		con = DriverManager.getConnection(url, username, password);

	}

	// �������� ����� ��������� ������������� ���������� ��������
	// ����������� ���������� Exception
	public static FR_DAO getInstance(String _driver, String _urlDatabase)
			throws Exception {
		if (singletonAccessor == null)
			singletonAccessor = new FR_DAO(_driver, _urlDatabase);
		return singletonAccessor;
	}

	// ��������� ���������� � ��
	public void closeConnection() throws SQLException {
		if (con != null)
			con.close();
	}

	public void propertyStatement() throws SQLException {
		// ��������, ��������� �� ������� JDBC ��� ��� ���� ��� �������
		// TYPE_FORWARD_ONLY - ������ ������� ������������ ������ ������
		// TYPE_SCROLL_INSENSITIVE - ������ ������������ � ����� ������������,
		// ������� �� ����������
		// TYPE_SCROLL_SENSITIVE - ������ ������������ � ����� ������������,
		// ������� ���������� ��� ��������� ����� � ��

		boolean ro = con.getMetaData().supportsResultSetType(
				ResultSet.TYPE_FORWARD_ONLY);
		System.out.println("TYPE_FORWARD_ONLY - " + ro);

		ro = con.getMetaData().supportsResultSetType(
				ResultSet.TYPE_SCROLL_INSENSITIVE);
		System.out.println("TYPE_SCROLL_INSENSITIVE - " + ro);

		ro = con.getMetaData().supportsResultSetType(
				ResultSet.TYPE_SCROLL_SENSITIVE);
		System.out.println("TYPE_SCROLL_SENSITIVE - " + ro);

		// ��������, ������������ �� ������� JDBC ��� ��� ���� ����� ���������
		// �������
		// CONCUR_READ_ONLY - ������� ������ ��������
		// CONCUR_UPDATABLE - ������� ����� ��������
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

	public Vector<String> getAllCorporateStandarts() throws SQLException {
		Vector<String> vStandarts = new Vector<String>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT fr.standart FROM fr");
		while (rs.next()) {
			vStandarts.add(new String(rs.getString("standart")));
		}
		stat.close();
		return vStandarts;
	}
	
	public String getCorporateStandartByFR(Integer id) throws SQLException {
		String stand;
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT standart FROM fr WHERE fr.id = " + id);
		if(rs.next()) {
			if(rs.getString("standart") == null) {
				return null;
			} else {
				stand = new String(rs.getString("standart"));
				return stand;
			}
		}
		stat.close();
		return null;
	}
	
	public boolean changeCorporateStandart(FR fr) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from fr where id="+ fr.getIdFR());
		if (rs.next()) {
			int n = stat.executeUpdate("UPDATE fr SET standart = '" + fr.getStandart() + "' where id = " + fr.getIdFR());
			if (n > 0) {
				System.out.println("Execute = "+n);
				rs.close();
				return true;
			} else {
					rs.close();
					return false;
				}			
		} else {
			System.out.println("fff" + rs.next());
			rs.close();
			return false;
		}
	}
	
	public Integer addFR(FR fr) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from fr where frName='"+ fr.getName()+"' and groupFR='"+fr.getGroup()+"'");
		if (!(rs.next())) {
			int n = stat.executeUpdate("INSERT INTO fr (frName, groupFR, standart) VALUES ('" + fr.getName() + "','" + fr.getGroup() + "','" + fr.getStandart() +"')");
			if (n > 0) {
				System.out.println("FR added = "+n);
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
	
	public boolean updateFR(FR fr) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from fr where id="+ fr.getIdFR());
		if (rs.next()) {
			int n = stat.executeUpdate("UPDATE fr SET FRname = '" + fr.getName() + "' where id = " + fr.getIdFR());
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
	
	public boolean deleteFR(Integer id) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from fr where id="+ id);
		if (rs.next()) {
			int n = stat.executeUpdate("DELETE FROM fr WHERE id = " + id);
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
	
	public Vector<FR> getAllFR() throws SQLException {
		Vector<FR> vFR = new Vector<FR>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM fr, groupFR where fr.groupFR = groupFR.groupName");
		while (rs.next()) {
			vFR.add(new logic.FR(rs.getInt("id"), rs.getString("FRname"), rs.getString("standart"), rs.getString("groupFR")));
		}
		stat.close();
		return vFR;
	}
	
	public Vector<FR> getFRByGroup(Integer id) throws SQLException {
		Vector<FR> vFR = new Vector<FR>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM fr, groupFR where fr.groupFR = groupFR.groupName and groupFR.id = " + id);
		while (rs.next()) {
			vFR.add(new logic.FR(rs.getInt("id"), rs.getString("FRname"), rs.getString("standart"), rs.getString("groupFR")));
		}
		stat.close();
		return vFR;
	}
	
	public Vector<FR> getFRByGroupEmp(Integer gr, Integer emp) throws SQLException {
		Vector<FR> vFR = new Vector<FR>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT distinct fr.id, fr.FRname, fr.standart, fr.groupFR FROM groupFR, fr, post_fr, post, employeepost where groupFR.groupName = fr.groupFR and post_fr.fr = fr.id and post.id = post_fr.post and employeepost.idPost = post.id and employeepost.idEmp = "+ emp +" and groupFR.id = "+gr);
		while (rs.next()) {
			vFR.add(new logic.FR(rs.getInt("id"), rs.getString("FRname"), rs.getString("standart"), rs.getString("groupFR")));
		}
		stat.close();
		return vFR;
	}
	
	public FR getFRById(Integer id) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM fr, groupFR where fr.groupFR = groupFR.groupName and FR.id = " + id);
		while (rs.next()) {
			logic.FR fr = new logic.FR(rs.getInt("id"), rs.getString("FRname"), rs.getString("standart"), rs.getString("groupFR"));
			return fr;
		}
		stat.close();
		return null;
	}
	
	public Integer getIdFR(FR fr) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT id FROM fr where groupFR = '" +fr.getGroup()+ "' and FRname= '" + fr.getName()+"'");
		if (rs.next()) {
			Integer id = rs.getInt("id");
			return id;
		} else {
			stat.close();
			return 0;
		}
	}
	
	/*public Vector<FR> getFRByEmployee(Employee emp) throws SQLException {
		Vector<FR> vFR = new Vector<FR>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM fr, groupFR where fr.groupFR = groupFR.id");
		while (rs.next()) {
			vFR.add(new logic.FR(rs.getInt("id"), rs.getString("FRname"), rs.getString("standart"), new logic.GroupFR(rs.getInt("id"), rs.getString("groupName"), rs.getInt("refGroup"))));
		}
		stat.close();
		return vFR;
	}*///������� ��������!!!!!!!!!
	

	/**
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		FR_DAO ac = new FR_DAO("localhost", "system");
	}


}
