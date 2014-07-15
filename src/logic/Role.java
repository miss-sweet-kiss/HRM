package logic;

public class Role {
	private Integer idRole;
	private String name;
	private String login;
	private String password;
	private Integer pd;
	private Integer employee;
	
	public Role() {
		this.idRole = null;
		this.name = null;
		this.login = null;
		this.password = null;
		this.pd = null;
		this.employee = null;
	}
	
	public Role(Integer idRole, String name, String login, String pass, Integer pd, Integer employee) {
		this.idRole = idRole;
		this.name = name;
		this.login = login;
		this.password = pass;
		this.pd = pd;
		this.employee = employee;
	}

	public void setIdRole(Integer id) {
		this.idRole = id;
	}

	public Integer getIdRole() {
		return idRole;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setLogin(String login) {
		this.login = login;
	}
	
	public void setPassword(String pass) {
		this.password = pass;
	}
	
	public void setPD(Integer pd) {
		this.pd = pd;
	}
	
	public void setEmployee(Integer emp) {
		this.employee = emp;
	}
	
	public String getName() {
		return name;
	}
	
	public String getLogin() {
		return login;
	}
	
	public String getPassword() {
		return password;
	}
	
	public Integer getPD() {
		return pd;
	}
	
	public Integer getEmployee() {
		return employee;
	}

	public String toString() {
		return name + " " + login + " " + password + " " + pd + " " + employee;
	}

}
