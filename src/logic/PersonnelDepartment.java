package logic;

public class PersonnelDepartment {
	private Integer id;
	private Integer reading;
	private Integer editing;
	private Integer emp;
	
	public PersonnelDepartment() {
		this.id = 0;
		this.reading = 0;
		this.editing = 0;
		this.emp = 0;
	}
	
	public PersonnelDepartment(Integer id, Integer r, Integer e, Integer emp) {
		this.id = id;
		this.reading = r;
		this.editing = e;
		this.emp = emp;
	}


	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getId() {
		return id;
	}

	public void setReading(Integer r) {
		this.reading = r;
	}
	
	public void setEditing(Integer e) {
		this.editing = e;
	}
	
	public void setEmployee(Integer e) {
		this.emp = e;
	}

	public Integer getReading() {
		return reading;
	}
	
	public Integer getEditing() {
		return editing;
	}
	
	public Integer getEmployee() {
		return emp;
	}

	public String toString() {
		return reading + " " + editing;
	}

}
