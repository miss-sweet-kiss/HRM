package dbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import logic.PersonnelDepartment;
import logic.Role;

public class Role_DAO {
	private static Role_DAO singletonAccessor;
	private Connection con;

	// ������� ����������� ��������� ������� � ����� ��
	// ����������� ���������� Exception
	@SuppressWarnings("static-access")
	private Role_DAO(String server, String urlDatabase) throws Exception {

		String driverName = "com.mysql.jdbc.Driver";

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
	public static Role_DAO getInstance(String _driver, String _urlDatabase) throws Exception {
		if (singletonAccessor == null)
			singletonAccessor = new Role_DAO(_driver, _urlDatabase);
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
	//��� enter.jsp
	public Integer isEmployee(String log, String pass) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from role where login='"+log+"'");
		if (rs.next()) {
			ResultSet rs1 = stat.executeQuery("SELECT * from role where login='"+log+"' and password='"+pass+"'");
			if (rs1.next()) {
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
	}
	
	//��� enter.jsp
	public String getRoleName(String log, String pass) throws SQLException {
		Statement stat = con.createStatement();
		String role = new String();
		ResultSet rs = stat.executeQuery("SELECT roleName from role where login='"+log+"' and password='"+pass+"'");
		if (rs.next()) {
			role = rs.getString("roleName");
			rs.close();			
			return role;		
		}else {
			rs.close();
			return null;
		}
	}
	
	public Integer getEmployee(String log, String pass) throws SQLException {
		Statement stat = con.createStatement();
		Integer emp;
		ResultSet rs = stat.executeQuery("SELECT employee from role where login='"+log+"' and password='"+pass+"'");
		if (rs.next()) {
			emp = rs.getInt("employee");
			rs.close();			
			return emp;		
		}else {
			rs.close();
			return null;
		}
	}

	public Integer addRole(Role role) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from role where login='"+ role.getLogin()+"'");
		if (!rs.next()) {
			ResultSet rs1 = stat.executeQuery("SELECT * from role where employee='"+ role.getEmployee()+"'");
			if (!rs1.next()) {
				int n = stat.executeUpdate("INSERT INTO role (roleName, login, password, personDepart, employee) VALUES('" + role.getName() + "','" + role.getLogin() + "','"+role.getPassword()+"','"+role.getPD()+"','"+role.getEmployee()+"')");
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
				return 4;
			}
		} else {
			System.out.println(rs.next());
			rs.close();
			return 3;
		}
	}
	
	public PersonnelDepartment getRights(Integer emp) throws SQLException {
		Statement stat = con.createStatement();
		PersonnelDepartment pd = new PersonnelDepartment();
		ResultSet rs = stat.executeQuery("SELECT * from personneldepartment where employee="+emp);
		if(rs.next()){
			pd.setEditing(rs.getInt("editing"));
			pd.setReading(rs.getInt("reading"));
			pd.setEmployee(rs.getInt("employee"));
		
			return pd;	
		} else {
			return null;
		}
	}
	
	public Integer setRights(PersonnelDepartment pd) throws SQLException {
		Statement stat = con.createStatement();
		Integer id;
		ResultSet rs = stat.executeQuery("SELECT * from personneldepartment where employee="+pd.getEmployee());
		if (!rs.next()) {
			int n = stat.executeUpdate("INSERT INTO personneldepartment (reading, editing, employee) VALUES("+pd.getReading()+","+pd.getEditing()+","+pd.getEmployee()+")");
			if (n > 0) {
				ResultSet rs1 = stat.executeQuery("SELECT * from personneldepartment where employee="+pd.getEmployee());
				if(rs1.next()){
				id = rs1.getInt("id");
				System.out.println(id);
				int m = stat.executeUpdate("UPDATE role set personDepart ="+ id +" where employee="+pd.getEmployee());
				if (m > 0) {
					System.out.println("Execute = "+n);
					rs1.close();
					rs.close();
					return 1;
				} else {
					rs1.close();
					rs.close();
					return 2;
				} 
				} else {
					rs1.close();
					rs.close();
					return 4;
				}
			} else {
				rs.close();
				return 4;
			}
		} else {
			int n = stat.executeUpdate("UPDATE personneldepartment SET reading="+pd.getReading()+", editing="+pd.getEditing()+" where employee="+pd.getEmployee());
			if(n > 0){
				rs.close();
				return 1;
			} else {
				rs.close();
				return 3;
			}
		}
	}
	
	public boolean deleteRole(Role role) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from role where login='"+ role.getLogin()+"'");
		if (rs.next()) {
			int n = stat.executeUpdate("DELETE FROM role WHERE login='"+ role.getLogin()+"'");
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
	
	public boolean deleteEmployeeRole(Integer id) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from role where employee="+id);
		if (rs.next()) {
			int n = stat.executeUpdate("DELETE FROM role WHERE employee="+id);
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
		Role_DAO ac = new Role_DAO("localhost", "system");
	}
}
