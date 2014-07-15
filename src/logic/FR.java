package logic;

public class FR {
	private Integer idFR;
	private String name;
	private String corpStandart;
	private String group;
	
	public FR() {
		this.idFR = null;
		this.name = null;
		this.corpStandart = null;
		this.group = null;
	}
	public FR(Integer idFR, String name, String cs, String group) {
		this.idFR = idFR;
		this.name = name;
		this.corpStandart = cs;
		this.group = group;
	}


	public void setIdFR(Integer id) {
		this.idFR = id;
	}

	public Integer getIdFR() {
		return idFR;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setStandart(String cs) {
		this.corpStandart = cs;
	}
	
	public void setGroup(String group) {
		this.group = group;
	}
	
	public String getName() {
		return name;
	}
	
	public String getStandart() {
		return corpStandart;
	}
	
	public String getGroup() {
		return group;
	}

	public String toString() {
		return name + " " + corpStandart + " " + group;
	}


}
