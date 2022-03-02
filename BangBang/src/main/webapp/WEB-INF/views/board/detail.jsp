<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@  page session="true" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
 div.reviewModal { position:relative; z-index:1; display:none;}
 div.modalBackground { position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0, 0, 0, 0.8); z-index:-1; }
 div.reviewContent { position:fixed; top:20%; left:calc(50% - 250px); width:500px; height:250px; padding:20px 10px; background:#fff; border:2px solid #666; }
 div.reviewContent textarea { font-size:16px; font-family:'맑은 고딕', verdana; padding:10px; width:500px; height:200px; }
 div.reviewContent button { font-size:20px; padding:5px 10px; margin:10px 0; background:#fff; border:1px solid #ccc; }
 div.reviewContent button.modal_cancel { margin-left:20px; }
</style>
<style>
 section.reviewForm { padding:30px 0; }
 section.reviewForm div.input_area { margin:10px 0; }
 section.reviewForm textarea { font-size:16px; font-family:'맑은 고딕', verdana; padding:10px; width:1100px;; height:150px; }
 
 section.reviewList { padding:30px 0; }
 section.reviewList ol { padding:0; margin:0; }
 section.reviewList ol li { padding:10px 0; border-bottom:2px solid #eee; }
 section.reviewList div.userInfo { }
 section.reviewList div.userInfo .userName { font-size:24px; font-weight:bold; }
 section.reviewList div.userInfo .rating { font-size:15px; font-weight:bold; margin-left:10px;}
 section.reviewList div.userInfo .date { color:#999; display:inline-block; margin-left:10px; }
 section.reviewList div.reviewContent { padding:10px; margin:20px 0; }
 
 .rating_div { padding-top: 10px;}
 .rating_div h4{margin : 0;}
  select{margin: 15px; width: 100px; height: 40px; text-align: center; font-size: 16px; font-weight: 600;}
 
</style>

<div class="reviewModal">

 <div class="reviewContent">
  
  <div>
   <textarea class="modal_con" name="modal_con"></textarea>
  </div>
  
  <div>
   <button type="button" class="modal_btn">수정</button>
   <button type="button" class="modal_cancel">취소</button>
  </div>
  
 </div>

 <div class="modalBackground"></div>
 
</div>

<script>
$(".modal_cancel").click(function(){
 $(".reviewModal").fadeOut(200);
});
</script>

<%@include file="../includes/bangbang-header.jsp"%>
	
<%@include file="../includes/bangbang-nav.jsp"%>
<main>
	<script>
	function reviewList() {
		var iidx = ${item.iidx};
		$.getJSON("${pageContext.request.contextPath}/board/detail/review-list"+ "?iidx=" + iidx, function(data) {
			var str = "";
			$(data).each(function() {
				
				console.log(data);
				
				var date = new Date(this.date);
				date = date.toLocaleDateString("ko-US")
				
				str += "<li data-ridx='" + this.ridx + "'>"
				+ "<div class='userInfo'>"
				+ "<span class='userName'>"+ this.userName + "</span>"
				+ "<span class='rating'>"+ this.rating + "점</span>"
				+ "<span class='date'>"+ date + "</span>"
				+ "</div>"
				+ "<div class='content'>"+ this.content + "</div>"
				
				+ "<c:if test='${loginInfo != null}'>"
				+ "<div class='reviewFooter'>"
				/* + "<button type='button' class='update' data-ridx='" + this.ridx + "'>수정</button>" */
				+ "<button type='button' class='delete' data-ridx='" + this.ridx + "'>삭제</button>"
				+ "</div>"
				+ "</c:if>"
				+ "</li>";
			});
			$("section.reviewList ol").html(str);
		});
	}
		
	</script>
	<section class="py-5">
		<div class="container px-4 px-lg-5 my-5">
			<div class="row gx-4 gx-lg-5 align-items-center">
				<div class="col-md-6">
					<img class="card-img-top mb-5 mb-md-0"
						src="${pageContext.request.contextPath}/resources/uploadfile/${board.thumb}" alt="..." />
				</div>
				<div class="col-md-6">
					<div class="small mb-1">${board.date}</div>
					<h1 class="display-5 fw-bolder">${board.title}</h1>
					<div class="fs-5 mb-5">
						<span class="text-decoration-line-through">${item.sprice}</span> <span>${item.price}</span>
					</div>
					<p class="lead">상품 정보</p>
					<div class="d-flex">
						<input class="form-control text-center me-3" id="inputQuantity"
							type="num" value="1" style="max-width: 3rem" />
						<button class="btn btn-outline-dark flex-shrink-0" type="button">
							<i class="bi-cart-fill me-1"></i> Add to cart
						</button>
						<div class="w3-border w3-center w3-padding">
						<c:if test="${ loginInfo.uidx == null }">
							추천 기능은 <button type="button" id="newLogin"><b class="w3-text-blue">로그인</b></button> 후 사용 가능합니다.<br />
							<i class="fa fa-heart" style="font-size:16px;color:red"></i>
							<span class="rec_count"></span>					
						</c:if>
						<c:if test="${ loginInfo.uidx != null }">
							<button class="w3-button w3-black w3-round" id="rec_update" name="rec_update">
								<i class="fa fa-heart" style="font-size:16px;color:red"></i>
								&nbsp;<span class="rec_count"></span>
							</button> 
						</c:if>
						<script>
							// 추천버튼 클릭시(추천 추가 또는 추천 제거)
							$("#rec_update").click(function(){
								$.ajax({
									url: "${pageContext.request.contextPath}/board/detail/wishcheck",
					                type: "POST",
					                data: {
					                    no: '${board.iidx}',
					                    id: '${loginInfo.uidx}'
					                },
					                success: function () {
								        recCount();
					                },
								})
							})
							
							// 게시글 추천수
						    function recCount() {
								$.ajax({
									url: "${pageContext.request.contextPath}/board/detail/wishcount"+"?iidx="+"${board.iidx}",
					                type: "POST",
					                data: {
					                    no: '${board.iidx}'
					                },
					                success: function (count) {
					                	$(".rec_count").html(count);
					                },
								})
						    };
						    recCount();
						</script>
						</div>
					</div>
				</div>
			</div>
		<div>${board.content}</div>
	<hr>
		</div>
	</section>
	
	<div class="container px-4 px-lg-5 my-5">
    <h2>리뷰</h2>
	</div>
	<div class="container px-4 px-lg-5 my-5" id="review">
		
		<c:if test="${loginInfo == null}">
			<p>리뷰를 남기려면 <a herf="${pageContext.request.contextPath}/member/login">로그인</a>하세요.</p>
		</c:if>
		
		<c:if test="${loginInfo != null}">
		<section class="reviewForm">
			<form role="form" method="post">
				<input type="hidden" name="iidx" id="iidx" value="${item.iidx}">
				<input type="hidden" name="uidx" value="1">
				<div class="rating_div">
				<h4>평점</h4>
				<select name="rating" id ="rating">
					<option value="1">1.0</option>
					<option value="2">2.0</option>
					<option value="3">3.0</option>
					<option value="4">4.0</option>
					<option value="5">5.0</option>
				</select>
				</div> 
				<!-- <input type="range" min="1" max="5" step="1" value="5" id="rating" name="rating"> -->
				<div class="input_area">
					<textarea name="content" id="content" cssClass="form-control" rows="5"></textarea>
				</div>
				<div class="input_area">
					<button type="button" id="review_btn" class="btn btn-block btn-primary">리뷰 등록</button>
					<script>
 					$("#review_btn").click(function(){
  
 						var formObj = $(".reviewForm form[role='form']");
  						var iidx = $("#iidx").val();
  						var content = $("#content").val();
  						var rating = $("#rating").val();
  
 						var data = {
  							iidx : iidx,
   							content : content,
   							rating : rating
  						};
 						console.log(data)
  
 						$.ajax({
  					 		url : "${pageContext.request.contextPath}/board/detail/review-reg",
  							type : "post",
   							data : data,
  						 	success : function(){
  						 		reviewList();
  						 		$("#content").val("");
 						 	}
 						 });
					});
					</script>
				</div>
			</form>
		</section>
		</c:if>

		<section class="reviewList">
			<ol>
			</ol>
			<script>
				reviewList();
			</script>
			
			<script>
			$(document).on("click", ".update", function(){
				 $(".reviewModal").fadeIn(200);
				 
					 var ridx = $(this).attr("data-ridx");
					 var content = $(this).parent().parent().children(".content").text();
					 
					 $(".modal_repCon").val(repCon);
					 $(".modal_modify_btn").attr("data-repNum", repNum);
					 
				});
			</script>
			
			<script>
			 	$(document).on("click", ".delete", function(){
				  
			 	  var check = confirm("삭제하시겠습니까?");
			 	  
			 	  if(check){
				  var data = {ridx : $(this).attr("data-ridx")};
				   
				  console.log(data)
				  
				  $.ajax({
				   url : "${pageContext.request.contextPath}/board/detail/review-del",
				   type : "post",
				   data : data,
				   success : function(result){
					   if(result == 1){
						    reviewList();
						} else {
							alert("본인이 작성한 댓글만 삭제 가능합니다.")
						}
				   }
				  });
			 	  }
				 });
			</script>
			<script>
			$(".update").click(function(){
				 var confirm = confirm("정말로 수정하시겠습니까?");
 
				 if(confirm) {
 				 var data = {
   				  ridx : $(this).attr("data-ridx"),
    				 content : $(".modal_con").val()
  				  };  // ReplyVO 형태로 데이터 생성
  
  				$.ajax({
 				  url : "${pageContext.request.contextPath}/board/detail/review-up",
  				 type : "post",
  				 data : data,
  				 success : function(result){
    
  				  if(result == 1) {
  					reviewList();
  				   $(".reviewModal").fadeOut(200);
  				  } else {
   				  alert("작성자 본인만 할 수 있습니다.");       
  				  }
 				  },
 				 error : function(){
  				  alert("로그인하셔야합니다.")
  				 }
				 });
 				}
 
				});
			</script>
		</section>
		</div>


	<div class="container px-4 px-lg-5 my-5">
		<a class="btn btn-list" href="${pageContext.request.contextPath}/board/list">목록</a>
		<a class="btn btn-list" href="${pageContext.request.contextPath}/admin/board/delete?iidx=${board.iidx}">삭제</a>
	</div>


</main>

<%@include file="../includes/bangbang-footer.jsp"%>
