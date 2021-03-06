<%@page language = "java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/header.jsp"%>
<%@include file="/common/sideMenu.jsp"%>
<%@ page import = "java.sql.*"%>

<% request.setCharacterEncoding("utf-8"); // 인코딩 %>

<style>
#search{
width: 50%;
}
#option{
width: 20%;
}

</style>

<div class="container">
 <h2>자유 게시판</h2>
 
<div class="alert alert-warning alert-dismissable">
 <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  <strong>주의!</strong> 이용 약관을 위반한 게시글은 경고 없이 삭제됩니다!
</div>
  
  <table class="table table-bordered"> <!-- 각각을 나눈다. -->
    <thead>
      <tr>
        <th>글번호</th>
        <th>제목</th>
        <th>글쓴이</th>
        <th>조회수</th>
        <th>작성일</th>
      </tr>
    </thead>
    
    <% 
    	int id;
    	int row = 0;
    	String PageNum_temp = request.getParameter("PageNum");
    	
    	Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try
        {
           String jdbcurl = "jdbc:mysql://localhost:3306/SE?serverTimezone=UTC";
           Class.forName("com.mysql.jdbc.Driver");
           conn = DriverManager.getConnection(jdbcurl, "root", "capscaps12345");
           stmt = conn.createStatement(); // 질의를 위한 Stmt 객체 생성.
           String sql = "select * from Article order by article_id desc";
           // "select * from Article order by cast(article_id as unsigned)";
           // 검색하고 내림차순으로 글들 정렬. 
           rs = stmt.executeQuery(sql);
        } // 데이터의 접근 권한 획득. 
        catch (ClassNotFoundException e)
        {
           e.printStackTrace();
        }
        catch (SQLException e)
        {
           e.printStackTrace();
        }
        
        rs.last(); // 처음 레코드로 이동!
        row = rs.getRow(); // 현재 레코드의 행 번호 반환! 즉 첫 레코드 번호를 row로.
        rs.beforeFirst(); // 처음 레코드의 이전으로 이동!
        
        while(rs.next())
        {
            id = Integer.parseInt(rs.getString("article_id"));
        
    %>
    
      <tr>
        <td><%= row %></td> 
        <td><a href=read_article.jsp?id=<%= rs.getString("article_id")%>>
        <%= rs.getString("article_title")%></a></td>
        <td><%= rs.getString("article_user_id") %></td>
        <td><%= rs.getString("article_hits") %></td>
        <td><%= rs.getString("article_date") %></td>
      </tr>
    <%
    	row--;
    }
    %>
  </table>
 
  <%
  String test;
  test = (String)session.getAttribute("sessionID");
  if (test != null && test.length() != 0) {
      // 값이 있는 경우 처리
  %>
 <a href="insert_article.jsp">
<button type="button" class="btn btn-info">
 <span class="glyphicon glyphicon-write"></span> 글쓰기
</button>
 </a>
 
 <% 
	}
 %>
 
<button type="button" class="btn btn-info" data-toggle="collapse" data-target="#search">
  <span class="glyphicon glyphicon-search"></span> 검색
</button>
<div id="search" class="collapse">
<form name ="search" method = "post" action="search_DB.jsp">
<div class="form-group">
<label for="sel1"></label>
  <select class="form-control" name="option" id="option">
  	 <!-- 검색 옵션 -->
    <option value="글쓴이">글쓴이</option>
    <option value="제목">제목</option>
    <option value="내용">내용</option>
  </select>
</div>
  <div class="input-group" id ="search">
    <input type="text" class="st-default-search-input form-control" placeholder="Search"
    name = "searching" id = "searching">
    <!-- 검색하려는 내용 -->
    <div class="input-group-btn">
      <button class="btn btn-default" type="submit">
        <i class="glyphicon glyphicon-search"></i>
      </button>
    </div>
  </div>
</form>
 </div>

 <% 
 
 /*
  <div class="text-center">
  <ul class="pagination">
    <li class="active"><a href="#">1</a></li>
    <li><a href="bbs2.jsp">2</a></li>
    <li><a href="#">3</a></li>
    <li><a href="#">4</a></li>
    <li><a href="#">5</a></li>
  </ul>
  </div>
  */
%>
</div>

<%@include file="/common/footer.jsp"%>

<% 
	stmt.close();
	conn.close(); // 연결을 종료한다. 
%>

</body>
</html>