<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="${pageContext.request.contextPath }/resources/css/etc/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath }/resources/css/common.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/etc/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/etc/jquery-3.7.0.js"></script>
<main>
	<nav class="navbar navbar-light bg-light">
		<div class="container-fluid">
			<a class="navbar-brand" href="${pageContext.request.contextPath }/">
<!-- 				<img src="logo.svg" alt="" width="30" height="24" class="d-inline-block align-text-top"> -->
				CatsArchive
			</a>
			<div>
				<span>
					<i class="fa fa-search" aria-hidden="true"></i>
				</span>
				<input type="text" id="product_search" name="product_search" placeholder="어떤 상품을 찾으시나요?" onkeypress="show_name(event)">
			</div>
		</div>
		<ul class="nav justify-content-center">
			<li class="nav-item">
				<a class="nav-link" href="#">DICTIONARY</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="#">PHOTOS</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="#">Link</a>
			</li>
			<li class="nav-item">
			  	<a class="nav-link" href="#">Link</a>
			</li>
		</ul>
	</nav>
</main>