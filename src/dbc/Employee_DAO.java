package dbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import logic.Employee;

public class Employee_DAO {
	private static Employee_DAO singletonAccessor;
	private Connection con;

	// скрытый конструктор принимает драйвер и адрес БД
	// выбрасывает исключение Exception
	@SuppressWarnings("static-access")
	private Employee_DAO(String server, String urlDatabase) throws Exception {

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
	public static Employee_DAO getInstance(String _driver, String _urlDatabase)
			throws Exception {
		if (singletonAccessor == null)
			singletonAccessor = new Employee_DAO(_driver, _urlDatabase);
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

	public Vector<Employee> getEmployee() throws SQLException {
		Vector<Employee> vEmp = new Vector<Employee>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM Employee");
		while (rs.next()) {
			vEmp.add(new Employee(rs.getInt("id"), rs.getString("empName"), rs.getString("surname")));
		}
		stat.close();
		return vEmp;
	}
	
	public Vector<Employee> getEmployeeOK() throws SQLException {
		Vector<Employee> vEmp = new Vector<Employee>();
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM Employee, role where role.employee=employee.id and roleName = 'сотрудник ОК'");
		while (rs.next()) {
			vEmp.add(new Employee(rs.getInt("id"), rs.getString("empName"), rs.getString("surname")));
		}
		stat.close();
		return vEmp;
	}
	
	public Integer getIdEmployee(Employee emp) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT id FROM Employee where empName = '"+emp.getName()+"' and surname = '"+emp.getSurname()+"'");
		while (rs.next()) {
			return rs.getInt("id");
		}
		stat.close();
		return null;
	}
	
	public Employee getEmployeeById(Integer id) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * FROM Employee where id = "+id);
		while (rs.next()) {
			Employee emp = new Employee(rs.getInt("id"),rs.getString("empName"), rs.getString("surname"));
			return emp;
		}
		stat.close();
		return null;
	}
	
	public Integer addEmployee(Employee emp) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from employee where empName='"+ emp.getName()+"' and surname='"+emp.getSurname()+"'");
		if (!(rs.next())) {
			int n = stat.executeUpdate("INSERT INTO employee (empName, surname) VALUES('" + emp.getName() + "','" + emp.getSurname() + "')");
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
	
	public boolean updateEmployee(Employee emp) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from employee where id="+ emp.getIdEmployee());
		if (rs.next()) {
			int n = stat.executeUpdate("UPDATE employee SET empName = '" + emp.getName() + "', surname = '" + emp.getSurname() + "' where id = " + emp.getIdEmployee());
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
	
	public boolean deleteEmployee(Integer id) throws SQLException {
		Statement stat = con.createStatement();
		ResultSet rs = stat.executeQuery("SELECT * from employee where id = " + id);
		if (rs.next()) {
			int n = stat.executeUpdate("DELETE FROM employee WHERE id = " + id);
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
		Employee_DAO ac = new Employee_DAO("localhost", "system");
		//Employee emp = new Employee(2, "name2", "surname1", "jjj");
		System.out.println(ac.getEmployee());
	}


}
