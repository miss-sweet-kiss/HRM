package logic;

public class Employee {
	private Integer idEmployee;
	private String name;
	private String surname;
	
	public Employee() {
		this.idEmployee = null;
		this.name = null;
		this.surname = null;
	}
	
	public Employee(Integer idEmployee, String name, String surname) {
		this.idEmployee = idEmployee;
		this.name = name;
		this.surname = surname;
	}

	public void setIdEmployee(Integer id) {
		this.idEmployee = id;
	}

	public Integer getIdEmployee() {
		return idEmployee;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setSurname(String surname) {
		this.surname = surname;
	}

	public String getName() {
		return name;
	}
	
	public String getSurname() {
		return surname;
	}

	public String toString() {
		return name + " " + surname;
	}

}
