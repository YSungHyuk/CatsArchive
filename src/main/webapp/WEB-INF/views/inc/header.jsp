<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="${pageContext.request.contextPath }/resources/css/etc/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath }/resources/css/common.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/etc/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/etc/jquery-3.7.0.js"></script>
<script>
	// 메일 유효성
	function validateEmail(email) {
		const re = /([!#-'+/-9=?A-Z^-~-]+(.[!#-'+/-9=?A-Z^-~-]+)|"([]!#-[^-~ \t]|([\t -~]))+")@([!#-'+/-9=?A-Z^-~-]+(.[!#-'+/-9=?A-Z^-~-]+)|[[\t -Z^-~]*])+$/;
		const hasKorean = /[ㄱ-ㅎㅏ-ㅣ가-힣]/;
		return re.test(String(email).toLowerCase()) && !hasKorean.test(email);
	}
	
	// 인증시간 타이머
	let timer; // 타이머 변수
	const startTimer = () => {
		let seconds = 180; // 타이머 초기 시간 (3분)
		timer = setInterval(function() {
			let minutes = Math.floor(seconds / 60);
			let remainingSeconds = seconds % 60;
	
		    if (seconds <= 0) {
				// 타이머 시간 초과
				clearInterval(timer);
		        $("#authTimer").html("인증번호 만료");
		    } else {
				// 타이머 시간 출력
		        let result =  
			        minutes + '분' + remainingSeconds + '초';
		        $("label[for=authTimer]").html(result); 
			}
	    seconds--;
		}, 1000);
	}
	
	$(function() {
		// 인증메일 발송
		$("#authMailBtn").on("click", () => {
			let email = $("#authEmail").val().trim();
			if(validateEmail(email)) {
				$.ajax({
					type: 'get'
					, url: 'AuthMailSend'
					, dataType: 'text'
					, data: {
						'email':email
					}
					, success: result => {
						if(result == 'true') {
							alert('인증메일 발송완료');
							// 타이머 3분, 인증번호 입력칸, 인증버튼 추가
							// 인증완료시 mailModal.hide() , joinModal.show()
							startTimer();
							$("#authEmail").attr('readonly');
							$("#authRow").removeClass('d-none');
							$("#authMailBtn").addClass('d-none');
						} else {
							alert('인증메일 발송실패');
						}
					}
					, error: () => {
						console.log("error");
					}
				});
			} else {
				alert("메일 주소를 정확히 입력하세요."); // Modal창으로 변경
				$("#authEmail").val('').focus();
			}
		});
		
		// 인증
		$("#authMailCheck").on("click", () => {
			let email = $("#authEmail").val().trim();
			let authCode = $("#authCode").val().trim();
			$.ajax({
				type: 'get'
				, url: 'AuthMailCheck'
				, dataType: 'text'
				, data: {
					'email':email
					,'authCode':authCode
				}
				, success: result => {
					if(result == 'true') {
// 						alert('인증 완료');
						$("#mailCheck").modal('hide');
						$('.modal-backdrop').remove();
						$("#joinForm").modal('show');
						$("#email").val(email);
					} else {
						alert('인증 실패');
					}
				}
				, error: () => {
					console.log("error");
				}
			});
		});
	});
</script>
<main class="container">
	<div class="row justify-content-end">
		<div class="col-1 pointer" data-bs-toggle="modal" data-bs-target="#mailCheck">
			회원가입
		</div>
		<div class="col-1">
			로그인
		</div>
<!-- 		<div class="col-1"> -->
<!-- 			알람 -->
<!-- 		</div> -->
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
				<div class="container">
					<div class="row">
						<div class="col">
							<div class="form-floating mb-3">
								<input type="email" class="form-control" id="authEmail"><label for="authEmail">Email address</label>
							</div>
						</div>
					</div>
					<div class="row d-none" id="authRow">
						<div class="col-6">
							<div class="form-floating mb-3">
								<input type="text" class="form-control" id="authCode" required><label for="autoCode">인증 번호</label>
							</div>
						</div>
						<div class="col-4">
							<div class="form-floating mb-3">
								<input type="text" class="form-control-plaintext" readonly id="authTimer" required><label for="authTimer"></label>
							</div>
						</div>
						<div class="col-2">
							<button type="button" class="btn btn-primary" id="authMailCheck">인증</button>
						</div>
					</div>
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
				<h5 class="modal-title" id="joinForm">회원 가입</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      		</div>
      		<div class="modal-body">
				<div class="form-floating mb-3">
					<input type="email" class="form-control" id="email" readonly><label for="email">Email address</label>
				</div>
      		</div>
      		<div class="modal-footer">
        		<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        		<button type="button" class="btn btn-primary">Understood</button>
      		</div>
    	</div>
  	</div>
</div>

