<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file = "/user/logincheck.jsp"%>
<%@ include file="/common/header.jsp"%>

<%@ page import="Item.Item"%>
<%@ page import="Item.ItemController" contentType="text/html; charset=UTF-8" %>

<style>
	img 
	{
		display: block;
		max-width: 50%;
		height: auto;
	}
</style>

<div class = "container">
	<h1> 물품 신고 하기 </h1>
	<hr />
	
	<h2> 신고 물품 정보 </h2>
	<div class = "row" style = "height : 30px;"> </div>
	
	<form name = "reportForm" method = "post" class = "form-inline">
<%
	request.setCharacterEncoding("UTF-8");
	
	String LoginedUser = (String)session.getAttribute("sessionID");
	
	String reqItemId = request.getParameter("itemId");
	
	String search_value = request.getParameter("search_text");
	String search_type = request.getParameter("search_type");
	
	String inputValue = request.getParameter("search_price");
	
	String ishome = request.getParameter("home");
	String iscart = request.getParameter("cart");
	
	int search_price = 0;
	
	if (inputValue != null && !inputValue.equals("0"))
		search_price = Integer.parseInt(inputValue);
		
	String search_seller = request.getParameter("search_seller_id");
	
	String url = "search_text=";
		
	if (search_value != null)
	{		
		if (!search_value.equals("null"))
			url = url + search_value;
	}
	
	if (search_type != null)
		url = url + "&search_type=" + search_type;
	
	if (search_price > 0)
		url = url + "&search_price=" + search_price;
	
	if (search_seller != null)
		url = url + "&search_seller_id=" + search_seller;
	
	if (ishome != null)
		url = url + "&home";
	
	if (iscart != null)
		url = url + "&cart";
	
	try
	{
		Item targetItem = ItemController.getItem(reqItemId);
		
		if (LoginedUser == null)
			response.sendRedirect("/SE/item/item_show_detail.jsp?itemId=" + targetItem + "&" + url + "&failed");
	
		else if (targetItem != null)
		{
%>
		<div class = "row">
			<input type = "hidden" name = "itemId" value = "<%=reqItemId%>">
			<input type = "hidden" name = "searchName" value = "<%=search_value%>">
			<input type = "hidden" name = "postPage" value = "/SE/item/item_search.jsp">
			
			<div class = "col-sm-4">
				<div style = "width : 100%; height : 30%; text-align : center">
					<img src = "/SE/pictures/Item/<%= targetItem.itemImage %>" class = "img-responsive">
				</div>			
			
				<div style = "text-align : center;">
					<h3><%= targetItem.name %></h3>
				</div>
			
				<div style = "text-align : center;">
					<h4>판매자 : <%= targetItem.itemRegUserId %> </h4>
				</div>
			</div>
		
			<div class = "col-sm-8">
				<div class="row">
					<div class="col-sm-8">
						<h4> 상품 이름 : <%= targetItem.name %> </h4>
						<h4> 상품 타입 : <%= targetItem.getType() %> </h4>
						<h4> 상품 가격 : <%= targetItem.price %> 포인트 </h4>
						<h4> 현재 상태 : <%= targetItem.itemState %> </h4>
						<h4> 공식 등록 번호 : <%= targetItem.getRegId() %> </h4>
					</div>			
				
					<div class = "col-sm-4">
					</div>		
				</div>
			
				<hr />
			
				<h3> 상세 설명 </h3>			
				<p> <%= targetItem.explanation %> </p>
			</div>
		</div>
		
		<!-- 신고 폼 -->
		<div class = "row">
			<hr/>
			
			<h2> 신고 사유 </h2>
	
	
			<div>
				<div class = "row">
					<div class ="row">
						<div class="col-sm-10 col-sm-offset-1" style = "border-radius : 15px; padding : 10px;">
							<div class = "col-sm-4"> 신고 사유 </div>
							<div class = "col-sm-8"> 자세한 신고 내용 </div>
						</div>
					</div>
					
					<div class = "row">
						<div class="col-sm-10 col-sm-offset-1" style = " border-radius : 15px; padding : 10px;">
							<div class = "col-sm-4">
								<select class = "form-control" name = "report_reason" id = "report_reason" style = "width : 100%; height : 40px;">
									<option> 신고 사유를 선택해주세요. </option>
									<option> 적합하지 않은 물품 이름 </option>
									<option> 잘못된 출원 등록 </option>
									<option> 적절하지 못한 물품 판매 </option>
									<option> 기타 </option>
								</select>
							</div>
							<div class = "col-sm-8">
								<textarea  class = "form-control" id = "report_context" name = "report_context" style = "width : 100%; height : 100px; vertical-align : text-top"></textarea>
							</div>
						</div>
					</div>
				</div>
			</div>
	
			<div class = "row" style = "height : 30px;"> </div>
	
			<!-- 최종 버튼 -->
			<div class = "row">
				<div class="col-sm-6 col-sm-offset-3">
					<div class = "col-sm-6">
						<input class="btn btn-success btn-block" type = "button" onclick = "reportMove('report')" value = "신고">
					</div>
					
					<div class = "col-sm-6" style = "text-align : center;">
						<input class="btn btn-default btn-block" type = "button" title = "이전으로" onclick = "reportMove('post')" value = "이전">
					</div>
				</div>
			</div>
		</div>
	</form>
</div>
<%
		}
%>
	
<%
	}
	
	catch (Exception e)
	{
		out.println("Class name : " + e.getStackTrace().getClass().getName() + "<br>");
		out.println(e.toString());
	}
%>
</div>

<script>
function reportMove(str)
{	
	if (str == "report")
	{
		var context = document.getElementById("report_context").value;
		var reason = document.getElementById("report_reason").value;
		
		if (context == "" || context == null)
			alert('신고 내용을 기입해주세요.');
		
		else if (reason == "" || reason == null || reason == "신고 사유를 선택해주세요.")
			alert('신고 사유를 선택해주세요.');
		
		else
			document.reportForm.action = "/SE/item/item_report_update.jsp?<%=url%>";
	}
		
	else if (str == "post")
		document.reportForm.action = "/SE/item/item_show_detail.jsp?<%=url%>";
	
	document.reportForm.submit();
}
</script>

<%@include file="/common/sideMenu.jsp"%>
<%@include file="/common/footer.jsp"%>

</body>
</html>