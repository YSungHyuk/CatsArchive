<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="${pageContext.request.contextPath }/resources/css/etc/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath }/resources/css/common.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/etc/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/etc/jquery-3.7.0.js"></script>
<script>
	function validateEmail(email) {
		const re = /([!#-'+/-9=?A-Z^-~-]+(.[!#-'+/-9=?A-Z^-~-]+)|"([]!#-[^-~ \t]|([\t -~]))+")@([!#-'+/-9=?A-Z^-~-]+(.[!#-'+/-9=?A-Z^-~-]+)|[[\t -Z^-~]*])+$/;
		const hasKorean = /[ㄱ-ㅎㅏ-ㅣ가-힣]/;
		return re.test(String(email).toLowerCase()) && !hasKorean.test(email);
	}
	
	let mailModal = new bootstrap.Modal($("#mailCheck"), { keyboard: false });
	let joinModal = new bootstrap.Modal($("#joinForm"), { keyboard: false });
	
	$(function() {
		$("#authMailBtn").on("click",function() {
			let email = $("#email").val();
			if(validateEmail(email)) {
				$.ajax({
					type: 'post'
					, url: 'authMailSend'
					, dataType: 'text'
					, data: {
						'email':email
					}
					, success: function(data) {
						if(data == '1') {
							alert('인증메일 발송완료');
							// 타이머 3분, 인증번호 입력칸, 인증버튼 추가
							// 인증완료시 mailModal.hide() , joinModal.show()
						} else {
							alert('인증메일 발송실패');
						}
					}
					
				})
			} else {
				alert("메일 주소를 정확히 입력하세요."); // Modal창으로 변경
				$("#email").val('').focus();
				return false;
			}
		});
		
		// 인증성공 시
// 		mailModal.hide();
// 		joinModal.show();
		
	});
</script>
<main class="container">
	<div class="row">
		<div class="col-2 pointer" data-bs-toggle="modal" data-bs-target="#mailCheck">
			회원가입
		</div>
		<div class="col-2">
			로그인
		</div>
		<div class="col-2">
			알람
		</div>
	</div>
</main>

<!-- Modal - mailCheck -->
<div class="modal fade" id="mailCheck" data-bs-keyboard="false" tabindex="-1" aria-labelledby="mailCheck" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="mailCheck">Modal title</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<div class="form-floating mb-3">
					<input type="email" class="form-control" id="email" required><label for="email">Email address</label>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				<button type="button" class="btn btn-primary" id="authMailBtn">인증메일 발송</button>
			</div>
		</div>
	</div>
</div>

<!-- Modal - join -->
<div class="modal fade" id="joinForm" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="joinForm" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="joinForm">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        ...
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Understood</button>
      </div>
    </div>
  </div>
</div>

