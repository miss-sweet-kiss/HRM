package logic;

public class GroupFR {
	private Integer idGroup;
	private String name;
	private Integer subordinacy;
	
	public GroupFR() {
		this.idGroup = null;
		this.name = null;
		this.subordinacy = null;
	}
	
	public GroupFR(Integer idGroup, String name, Integer sub) {
		this.idGroup = idGroup;
		this.name = name;
		this.subordinacy = sub;
	}


	public void setIdGroup(Integer id) {
		this.idGroup = id;
	}

	public Integer getIdGroup() {
		return idGroup;
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
