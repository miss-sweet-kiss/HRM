package logic;

public class Post {
	private Integer idPost;
	private String name;
	private String department;
	
	public Post() {
		this.idPost = null;
		this.name = null;
		this.department = null;
	}
	public Post(Integer idPost, String name, String dep) {
		this.idPost = idPost;
		this.name = name;
		this.department = dep;
	}


	public void setIdPost(Integer id) {
		this.idPost = id;
	}

	public Integer getIdPost() {
		return idPost;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setDepartment(String dep) {
		this.department = dep;
	}
	
	public String getName() {
		return name;
	}
	
	public String getDepartment() {
		return department;
	}

	public String toString() {
		return name + " " + department;
	}

}
