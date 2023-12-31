<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="${pageContext.request.contextPath }/resources/css/etc/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath }/resources/css/common.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/etc/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/etc/jquery-3.7.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script>
let socket = null;

$(function () {
	let id = "";
	id = '${sId}';
    if (id != "") {
        connectWs();
    }
});

function connectWs() {
    let wsUrl = "<c:url value='/alram'/>"; // 웹소켓 엔드포인트 URL 설정
    const maxRetries = 5;
    let currentRetries = 0;

    function initWs() {
        const ws = new SockJS(wsUrl);
        socket = ws;

        ws.onopen = function () {
            console.log("open");
            currentRetries = 0;
        };

        ws.onmessage = function (event) {
            alert(event.data);
            let $socketAlert = $('div#socketAlert');
            $socketAlert.html(event.data);
            $socketAlert.css('display', 'block');

            setTimeout(function () {
                $socketAlert.css('display', 'none');
            }, 5000);
        };

        ws.onclose = function () {
            console.log('close');
            if (currentRetries < maxRetries) {
                setTimeout(() => {
                    console.log('Retrying WebSocket...');
                    currentRetries++;
                    initWs();
                }, 2000 * (currentRetries ** 2));
            } else {
                console.error('WebSocket reconnection attempts exceeded.');
            }
        };

        ws.onerror = function (error) {
            console.error('WebSocket error:', error);
        };
    }

    initWs();
};
</script>
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
		clearInterval(timer);
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
		$(".authMailBtn").on("click", () => {
			let email = $("#authEmail").val().trim();
			if(validateEmail(email)) {
				$.ajax({
					type: 'get'
					, url: 'idDuplicateCheck'
					, dataType: 'text'
					, data: {
						'email':email
					}
					, success: result => {
						if (result == 'false') {
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
										startTimer();
										$("#authMailBtn").text("인증번호 재발송")
										$("#authEmail").attr('readonly');
										$(".authRow").removeClass('d-none');
										$("#authMailBtn").addClass('d-none');
									} else {
										alert('인증메일 발송실패');
									}
								}
								, error: () => {
									console.log("error-mailSend");
								}
							});
						} else {
							alert("가입되어있는 메일 입니다."); // Modal창으로 변경
							$("#authEmail").val('').focus();
						};
					}
					, error: () => {
						console.log("error-idCheck")
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
		
		// 회원가입
		let passwdCheck = false;
		let passwdDuplicate = false;
		
		// 비밀번호 유효성
		function validatePassword(password) {
			const re = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,20}$/;
			return re.test(password);
		}
		
		// 비밀번호 유효성 검사
		$("#passwd").on('keyup',() => {
			let passwd = $("#passwd").val();
			let passwdError = $("#passwdCheck");
			
			if (validatePassword(passwd)) {
				console.log(passwd+" : true");
				passwdError.text('사용가능').css('color','#00ff00');
				passwdCheck = true;
			} else {
				console.log(passwd+" : false");
				passwdError.text('영문, 숫자, 특수문자 포함 8~20글자 이상 입력해주세요.').css('color','#ff0000');
				passwdCheck = false;
			}
		});
		
		// 비밀번호 중복 검사
		$("#ConfirmPassword").on('keyup',() => {
			let passwd = $("#passwd").val();
			let passwd2 = $("#ConfirmPassword").val();
			let passwdError = $("#passwdCheck2");
			
			if (passwd == passwd2) {
				passwdError.text('패스워드 일치').css('color','#00ff00');
				passwdDuplicate = true;
			} else {
				passwdError.text('패스워드가 일치하지 않습니다.').css('color','#ff0000');
				passwdDuplicate = false;
			}
		});
		
		// 회원가입
		$("#join").on("click",() => {
			$.ajax({
				type: 'post'
				, url: 'JoinMemberShip'
				, dataType: 'text'
				, data: {
					'email': $("#email").val()
					,'passwd': $("#passwd").val()
					,'name': $("#name").val()
					,'nickname': $("#nickname").val()
				}
				, success: result => {
					if(result == 'true') {
						alert('가입 완료');
						location.href="./";
					} else {
						alert('가입 실패');
					}
				}
				, error: () => {
					console.log("error");
				}
			});
		});
		
		$("#login").on("click",() => {
			$.ajax({
				type: 'get'
				, url: 'LoginMember'
				, dataType: 'text'
				, data: {
					'email': $("#loginEmail").val()
					, 'passwd': $("#loginPasswd").val()
					, 'rememberId': $("#rememberId").is(':checked')
				}
				, success: result => {
					if(result == 'true') {
						location.href="./";
					} else {
						alert('로그인 실패');
					}
				}
				, error: () => {
					console.log("error");
				}
			});
		});
		
		$("#logout").on("click",() => {
			let isLogout = confirm("로그아웃 하시겠습니까?");
			
			if(isLogout) {
				location.href="MemberLogout";
			}
		})
		
		
	});
</script>
<main class="container">
	<div class="row justify-content-end">
		<c:choose>
			<c:when test="${empty sessionScope.sId }">
				<div class="col-1 pointer" data-bs-toggle="modal" data-bs-target="#loginForm">
					로그인
				</div>
				<div class="col-1 pointer" data-bs-toggle="modal" data-bs-target="#mailCheck">
					회원가입
				</div>
			</c:when>
			<c:otherwise>
				<div class="col-2 pointer">${sessionScope.sId } 님</div>
				<div class="col-1 pointer" id="logout">Logout</div>
				<div class="col-1 pointer">
					알람
				</div>
			</c:otherwise>
		</c:choose>
	</div>
</main>

<!-- Modal - mailCheck -->
<div class="modal fade" id="mailCheck" data-bs-keyboard="false" tabindex="-1" aria-labelledby="mailCheck" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="mailCheck">Email Confirm</h5>
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
					<div class="row d-none authRow">
						<div class="col-8">
							<div class="form-floating mb-3">
								<input type="text" class="form-control" id="authCode" required><label for="autoCode">인증 번호</label>
							</div>
						</div>
						<div class="col-2">
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
				<button type="button" class="btn btn-primary authMailBtn">인증메일 발송</button>
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
      		<div class="modal-body container">
      			<div class="row">
					<div class="form-floating mb-3 col">
						<input type="email" class="form-control" id="email" disabled="disabled"><label for="email">Email address</label>
					</div>
					<div class="col">
						
					</div>
      			</div>
      			<div class="row">
					<div class="form-floating mb-3 col">
						<input type="password" class="form-control" id="passwd" required="required"><label for="passwd">Password</label>
					</div>
					<div class="col" id="passwdCheck">
						
					</div>
      			</div>
      			<div class="row">
					<div class="form-floating mb-3 col">
						<input type="password" class="form-control" id="ConfirmPassword" required="required"><label for="ConfirmPassword">Confirm password</label>
					</div>
					<div class="col" id="passwdCheck2">
						
					</div>
      			</div>
      			<div class="row">
					<div class="form-floating mb-3 col">
						<input type="text" class="form-control" id="name" required="required"><label for="name">Name</label>
					</div>
					<div class="col">
						
					</div>
      			</div>
      			<div class="row">
					<div class="form-floating mb-3 col">
						<input type="text" class="form-control" id="nickname" required="required"><label for="nickname">Nickname</label>
					</div>
					<div class="col" id="nicknameCheck">
						
					</div>
      			</div>
<!-- 				<div class="form-floating mb-3"> -->
<!-- 					<input type="text" class="form-control" id="mtel"><label for="mtel">Phone number</label> -->
<!-- 				</div> -->
      		</div>
      		<div class="modal-footer">
        		<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        		<button type="button" id="join" class="btn btn-primary">회원가입</button>
      		</div>
    	</div>
  	</div>
</div>

<!-- Modal - login -->
<div class="modal fade" id="loginForm" data-bs-keyboard="false" tabindex="-1" aria-labelledby="loginForm" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="loginForm">로그인</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      		</div>
      		<div class="modal-body container">
      			<div class="row">
					<div class="form-floating mb-3 col">
						<input type="email" class="form-control" id="loginEmail" value="${cookie.REMEMBER_ID.value }" required="required"><label for="email">Email address</label>
					</div>
      			</div>
      			<div class="row">
					<div class="form-floating mb-3 col">
						<input type="password" class="form-control" id="loginPasswd" required="required"><label for="passwd">Password</label>
					</div>
      			</div>
      			<div class="row">
	      			<div class="form-check form-check mb-3 col">
						<input class="form-check-input" type="checkbox" id="rememberId" 
							<c:if test="${not empty cookie.REMEMBER_ID.value }">checked</c:if> 
						><label class="form-check-label" for="rememberId">REMEMBER ID</label>
					</div>
      			</div>

      		</div>
      		<div class="modal-footer">
        		<button type="button" id="login" class="btn btn-primary">로그인</button>
      		</div>
    	</div>
  	</div>
</div>

