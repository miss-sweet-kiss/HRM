package dbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import logic.Department;

public class Department_DAO {
	private static Department_DAO singletonAccessor;
	private Connection con;

	// ������� ����������� ��������� ������� � ����� ��
	// ����������� ���������� Exception
	@SuppressWarnings("static-access")
	private Department_DAO(String server, String urlDatabase) throws Exception {

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
	public static Department_DAO getInstance(String _driver, String _urlDatabase)
			throws Exception {
		if (singletonAccessor == null)
			singletonAccessor = new Department_DAO(_driver, _urlDatabase);
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
	
	public Vector<Department> getDepartments() throws SQLException {
		Vector<Department> vDep = new Vector<Department>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM Department");
		while (rs.next()) {
			vDep.add(new Department(rs.getInt("id"), rs.getString("depName"), rs.getInt("refDep")));
		}
		stat.close();
		return vDep;
	}
	
	public Vector<Department> getDepartmentsByEmp(Integer id) throws SQLException {
		Vector<Department> vDep = new Vector<Department>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT distinct Department.id, Department.depName, Department.refDep FROM Department, post, employeepost where post.department = Department.depName and post.id = employeepost.idPost and employeepost.idEmp = "+id);
		while (rs.next()) {
			vDep.add(new Department(rs.getInt("id"), rs.getString("depName"), rs.getInt("refDep")));
		}
		stat.close();
		return vDep;
	}
	
	public Integer addDepartment(Department dep) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from department where depName= '" + dep.getName() + "'");
		if (!(rs.next())) {
			int n = stat.executeUpdate("INSERT INTO department (depName) VALUES('" + dep.getName() + "')");
			if (n > 0) {
				System.out.println("Department added = "+n);
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
	
	public boolean updateDepartment(Department dep) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from department where id= " + dep.getIdDepartment());
		if (rs.next()) {
			int n = stat.executeUpdate("UPDATE department SET depName = '" + dep.getName() + "' where id = " + dep.getIdDepartment());
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
	
	public Integer deleteDepartment(Integer id) throws SQLException {
		Statement stat = con.createStatement();
		String dep = new String();
		ResultSet rs = stat.executeQuery("SELECT * from department where id= " + id);
		if (rs.next()) {
			dep = rs.getString("depName");
			rs = stat.executeQuery("SELECT * from post where department = '"+dep+"'");
			if(!rs.next()){
				int n = stat.executeUpdate("DELETE FROM department WHERE id = " + id);
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
		Department_DAO ac = new Department_DAO("localhost", "system");
		Department dep = new Department(3, "depName1", 0);
		System.out.println(ac.addDepartment(dep));
	}

}
