package dbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import logic.Post;

public class Post_DAO {
		private static Post_DAO singletonAccessor;
		private Connection con;

		// скрытый конструктор принимает драйвер и адрес БД
		// выбрасывает исключение Exception
		@SuppressWarnings("static-access")
		private Post_DAO(String server, String urlDatabase) throws Exception {

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
		public static Post_DAO getInstance(String _driver, String _urlDatabase)
				throws Exception {
			if (singletonAccessor == null)
				singletonAccessor = new Post_DAO(_driver, _urlDatabase);
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

		public Vector<Post> getPosts() throws SQLException {
			Vector<Post> vPost = new Vector<Post>();
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * FROM Post");
			while (rs.next()) {
				vPost.add(new Post(rs.getInt("id"), rs.getString("postName"), rs.getString("department")));
			}
			stat.close();
			return vPost;
		}
		
		public Vector<Post> getPostsByDep(Integer id) throws SQLException {
			Vector<Post> vPost = new Vector<Post>();
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * FROM Post, Department WHERE Department.depName = Post.department and Department.id = "+id);
			while (rs.next()) {
				vPost.add(new Post(rs.getInt("id"), rs.getString("postName"), rs.getString("department")));
			}
			stat.close();
			return vPost;
		}
		
		public Vector<Post> getPostsByDepEmp(Integer emp, Integer dep) throws SQLException {
			Vector<Post> vPost = new Vector<Post>();
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT distinct Post.id, Post.postName, Post.department FROM Department, Post, EmployeePost WHERE EmployeePost.idEmp = "+emp+" and EmployeePost.idPost = Post.id and Department.depName = Post.department and Department.id = "+dep);
			while (rs.next()) {
				vPost.add(new Post(rs.getInt("id"), rs.getString("postName"), rs.getString("department")));
			}
			stat.close();
			return vPost;
		}
		
		public Vector<Post> getPostsByEmp(Integer emp) throws SQLException {
			Vector<Post> vPost = new Vector<Post>();
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT distinct Post.id, Post.postName, Post.department FROM Post, EmployeePost WHERE EmployeePost.idEmp = "+emp+" and EmployeePost.idPost = Post.id");
			while (rs.next()) {
				vPost.add(new Post(rs.getInt("id"), rs.getString("postName"), rs.getString("department")));
			}
			stat.close();
			return vPost;
		}
		
		public Post getPostById(Integer id) throws SQLException {
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * FROM Post, Department WHERE Department.depName = Post.department and Post.id = " +id);
			while (rs.next()) {
				logic.Post post = new logic.Post(rs.getInt("id"), rs.getString("postName"), rs.getString("department"));
				return post;
			}
			stat.close();
			return null;
		}
		
		public Integer getCountPostsInDep(String dep) throws SQLException {
			Integer count = 0;
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT count(postName) as Res FROM Post WHERE department = '" +dep+"'");
			
			while (rs.next()) {
				count = rs.getInt(1);
			}
			stat.close();
			return count;
		}
		
		public Integer getCountPostsInDepByEmp(String dep, Integer emp) throws SQLException {
			Integer count = 0;
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT count(postName) as Res FROM Post, employeepost WHERE department = '" +dep+"' and employeepost.idPost = post.id and employeepost.idEmp = "+emp);
			
			while (rs.next()) {
				count = rs.getInt(1);
			}
			stat.close();
			return count;
		}
		
		public Integer addPost(Post post) throws SQLException {
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * from post where postName= '" + post.getName()+"' and department ='" +post.getDepartment()+"'");
			if (!(rs.next())) {
				int n = stat.executeUpdate("INSERT INTO post (postName, department) VALUES('" + post.getName() + "','" + post.getDepartment() + "')");
				if (n > 0) {
					System.out.println("Post added = "+n);
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
		
		public boolean updatePost(Post post) throws SQLException {
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * from post where id= " + post.getIdPost());
			if (rs.next()) {
				int n = stat.executeUpdate("UPDATE post SET postName = '" + post.getName() + "' where id = " + post.getIdPost());
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
		
		public boolean deletePost(Integer id) throws SQLException {
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT * from post where id= " + id);
			if (rs.next()) {
				int n = stat.executeUpdate("DELETE FROM post WHERE id = " + id);
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
		
		public Integer getIdPost(Post post) throws SQLException {
			Statement stat = con.createStatement();
			ResultSet rs = stat.executeQuery("SELECT id FROM post where department = '" +post.getDepartment()+ "' and postName= '" +post.getName()+"'");
			if (rs.next()) {
				Integer id = rs.getInt("id");
				return id;
			} else {
				stat.close();
				return 0;
			}
		}

		/**
		 * @param args
		 * @throws Exception
		 */
		public static void main(String[] args) throws Exception {
			// TODO Auto-generated method stub
			Post_DAO ac = new Post_DAO("localhost", "system");
		}

	}


