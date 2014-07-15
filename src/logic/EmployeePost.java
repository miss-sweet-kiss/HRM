package logic;

public class EmployeePost {
	private Integer id;
	private Integer idEmp;
	private Integer idPost;
	private String rate;
	
	public EmployeePost() {
		this.id = null;
		this.idEmp = null;
		this.idPost = null;
		this.rate = null;
	}
	
	public EmployeePost(Integer id, Integer idEmp, Integer idPost, String rate) {
		this.id = id;
		this.idEmp = idEmp;
		this.idPost = idPost;
		this.rate = rate;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public void setIdEmp(Integer idEmp) {
		this.idEmp = idEmp;
	}
	
	public void setIdPost(Integer idPost) {
		this.idPost = idPost;
	}

	public void setRate(String rate) {
		this.rate = rate;
	}
	
	public Integer getId() {
		return id;
	}
	
	public Integer getIdEmp() {
		return idEmp;
	}
	
	public Integer getIdPost() {
		return idPost;
	}
	
	public String getRate() {
		return rate;
	}
	
	public String toString() {
		return idEmp + " " + idPost + " " + rate;
	}

}
