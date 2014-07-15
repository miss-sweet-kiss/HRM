package logic;

public class Department {
	private Integer idDepartment;
	private String name;
	private Integer subordinacy;
	
	public Department() {
		this.idDepartment = null;
		this.name = null;
		this.subordinacy = null;
	}
	
	public Department(Integer idDepartment, String name, Integer sub) {
		this.idDepartment = idDepartment;
		this.name = name;
		this.subordinacy = sub;
	}


	public void setIdDepartment(Integer id) {
		this.idDepartment = id;
	}

	public Integer getIdDepartment() {
		return idDepartment;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setSubordinacy(Integer sub) {
		this.subordinacy = sub;
	}
	
	public String getName() {
		return name;
	}
	
	public Integer getSubordinacy() {
		return subordinacy;
	}

	public String toString() {
		return name + " " + subordinacy;
	}

}
