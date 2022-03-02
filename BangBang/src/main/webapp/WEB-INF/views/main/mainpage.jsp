<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
	
<%@include file="../includes/bangbang-header.jsp"%>
	
<%@include file="../includes/bangbang-nav.jsp"%>

<main class="container">
     <div id="bar-image-container" style="padding-bottom: 20px;">
				<div class="bar-images hide--mobile">
					<img src="/bangbang/resources/hyunwoo/imageContainer/1.jpg" alt="1" class="bar-image">
					<img src="/bangbang/resources/hyunwoo/imageContainer/2.jpg" alt="2" class="bar-image">
					<img src="/bangbang/resources/hyunwoo/imageContainer/3.jpg" alt="3" class="bar-image">
				</div>
				<div class="bar-images hide--mobile">
					<img src="/bangbang/resources/hyunwoo/imageContainer/4.jpg" alt="4" class="bar-image">
					<img src="/bangbang/resources/hyunwoo/imageContainer/5.jpg" alt="5" class="bar-image">
					<img src="/bangbang/resources/hyunwoo/imageContainer/6.jpg" alt="6" class="bar-image">
				</div>
				<div class="bar-images hide--mobile">
					<img src="/bangbang/resources/hyunwoo/imageContainer/7.jpg" alt="7" class="bar-image">
					<img src="/bangbang/resources/hyunwoo/imageContainer/8.jpg" alt="8" class="bar-image">
					<img src="/bangbang/resources/hyunwoo/imageContainer/9.jpg" alt="9" class="bar-image">
				</div>
  </div>
  
  <br>
  
  
  <!-- 메인 시작 -->
  
   <div class="album py-5 bg-light">
    	
	<div class="border mt-3 p-2">전체 상품 수: ${board.totalCount}개 ,
				현재 페이지: ${board.currentPage}/${board.pageTotalCount}</div>

    <div class="container">
		<c:if test="${empty board.list}">
			  <h3>등록된 상품이 없습니다.</h3>
		</c:if>
		
		<c:if test="${not empty board.list}" >

      <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
		<c:forEach var="list" items="${board.list}">
        <div class="col">
          <div class="card shadow-sm">
            <image src="${pageContext.request.contextPath}/resources/uploadfile/${list.thumb}">

            <div class="card-body">
              <p class="card-text">${list.title}</p>
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <a href="${pageContext.request.contextPath}/board/detail?iidx=${list.iidx}"><button type="button" class="btn btn-sm btn-outline-secondary">View</button></a>
                  <c:if test="${member == null}">
                  <a href="${pageContext.request.contextPath}/admin/board/update?iidx=${list.iidx}"><button type="button" class="btn btn-sm btn-outline-secondary">Edit</button></a>
                  <a href="${pageContext.request.contextPath}/admin/board/delete?iidx=${list.iidx}"><button type="button" class="btn btn-sm btn-outline-secondary">delete</button></a>
                  </c:if>
                </div>
                <small class="text-muted">${list.hits}</small>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
      </div>
      </c:if>
   </div>
    <div class="btn-toolbar" role="toolbar" >
		<div class="btn-group mr-2" role="group">
				
			<c:if test="${board.pageTotalCount > 0}">
		
				<c:forEach begin="1" end="${board.pageTotalCount}" var="pnum">
					<a href="list?p=${pnum}&searchType=${param.searchType}&keyword=${param.keyword}"
				       class="btn ${board.currentPage eq pnum ? 'btn-dark': 'btn-white'}">${pnum}</a>
				</c:forEach>
			</c:if>
		</div>
	</div>
  </div>
  
  <!-- 메인 끝 -->
  
  
  
  
</main>


<%@include file="../includes/bangbang-footer.jsp"%>
	
	
	 