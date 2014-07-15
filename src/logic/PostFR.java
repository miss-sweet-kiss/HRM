package logic;

public class PostFR {
	private Integer id;
	private Integer post;
	private Integer fr;
	private Integer relationX;
	private Integer relationO;
	private Integer relation1;
	private Integer relationY;
	private Integer relationK;
	
	public PostFR() {
		this.id = null;
		this.post = null;
		this.fr = null;
		this.relationX = 0;
		this.relationO = 0;
		this.relation1 = 0;
		this.relationY = 0;
		this.relationK = 0;
	}
	
	public PostFR(Integer id, Integer post, Integer fr, Integer x, Integer o, Integer r1, Integer y, Integer k) {
		this.id = id;
		this.post = post;
		this.fr = fr;
		this.relationX = x;
		this.relationO = o;
		this.relation1 = r1;
		this.relationY = y;
		this.relationK = k;
	}


	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getId() {
		return id;
	}

	public void setPost(Integer post) {
		this.post = post;
	}

	public void setFR(Integer fr) {
		this.fr = fr;
	}
	
	public void setX(Integer x) {
		this.relationX = x;
	}
	
	public void setO(Integer o) {
		this.relationO = o;
	}
	
	public void set1(Integer r1) {
		this.relation1 = r1;
	}
	
	public void setY(Integer y) {
		this.relationY = y;
	}
	
	public void setK(Integer k) {
		this.relationK = k;
	}
	
	public Integer getPost() {
		return post;
	}
	
	public Integer getFR() {
		return fr;
	}
	
	public Integer getX() {
		return relationX;
	}
	
	public Integer getO() {
		return relationO;
	}
	
	public Integer get1() {
		return relation1;
	}
	
	public Integer getY() {
		return relationY;
	}
	
	public Integer getK() {
		return relationK;
	}

	public String toString() {
	//	return post + " " +fr+" "+relationX+" "+relationO+" "+relation1+" "+relationY+ " "+relationK;
		String str = " ";
		if(relationX == 1){
			str += " X";
		}
		if(relationO == 1){
			str += " O";
		}
		if(relation1 == 1){
			str += " 1";
		}
		if(relationY == 1){
			str += " Y";
		}
		if(relationK == 1){
			str += " K";
		}
		
		return str;
	}

}
