<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>게시글</title>


    <!-- Custom styles for this page -->
    <link href="/admin2form/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
	
	
	<!-- Bootstrap core JavaScript-->
<!--     <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script> -->
<!-- 	<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script> -->
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
    
    
    <!-- Custom fonts for this template -->
    <link href="/admin2form/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
          
<script>
    $(document).ready(function() {
        $('#summernote').summernote({
        	height: null,                 // 에디터 높이
			minHeight: null,             // 최소 높이
			maxHeight: null,             // 최대 높이
			focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
			lang: "ko-KR",					// 한글 설정
			toolbar: [],
			disableResizeEditor: false,
			disableDragAndDrop: true
        });
        $("#summernote").summernote('disable');
		$('.note-statusbar').hide();
        
        
        $("#fileAddTD").on("click", ".fileAddBtn", function(){
        	alert("fileAdd");
        	var tag = '<div class="col-sm-10 fileDiv" style="margin-bottom : 5px;">';
        	tag += '<input type="file" name="realfilename">';
        	tag += ' <input class="btn btn-primary fileAddBtn" type="button" value="+" style="outline: 0; border: 0; color: white; font-size:15px;">';
        	tag += ' <input class="btn btn-primary fileSubBtn" type="button" value="-" style="width : 32px; outline: 0; border: 0; color: white; font-size:15px; background: red;">';
        	tag += '</div>';
        	$("#fileAddTD").append(tag);
        });
        
        
        $("#fileAddTD").on("click", ".fileSubBtn", function(){
        	$(this).parents(".fileDiv").remove();
        });
        
        
        $("#updateBoardBtn").on("click", function(){
			document.location = "/freeBoard/updateBoardView?postSeq=${freeBoard.postSeq}";
        });
        
        $("#backBtn").on("click", function(){
        	document.location = "/freeBoard/freeBoardList?postSeq=${freeBoard.postSeq}";
        });
        
        $("#delBoardBtn").on("click", function(){
        	
        	if (confirm("삭제하시겠습니까?") == true){    //확인
    			document.location = "/freeBoard/deleteFreeBoard?postSeq=${freeBoard.postSeq}";
    		 }else{   //취소
    		     return false;
    		 }
        	
        });
        

        
        $("#repleInsertBtn").on("click", function(){
        	if ($("#repleContent").val() == "" ) {
        		alert("내용을 입력해주세요.");
        	} else {
	        	$("#repleWriteForm").submit();
        	}
        });
        
        
        $(".delRepleBtn").on("click", function(){
        	
        	if (confirm("삭제하시겠습니까?") == true) { //확인
	        	var repleSeq = $(this).parents(".showRepleDiv").find(".repleSeq").val();
	        	document.location = "/freeBoard/deleteFreeReple?repleSeq="+repleSeq+"&postSeq=${freeBoard.postSeq}";
        		
        	} else { // 취소
        		return false;
        	}
        	
        });
        
        $('#repleContent').val().replace(/\n/g, "<br>");

        
    });
</script>
<style>
	
	.note-editable{
		height: 350px;
	}
	.vl {
	  float : left;
	  text-align: center;
	}
	#d1{
	  border-left: 2px solid gray;
	}
	
	.front{
		text-align: center;
		font-family: 'Nanum Gothic', sans-serif;
		width: 200px;
	}
		
	table {
	    width: 100%;
	    border-top: 3px solid #858796;
	    border-collapse: collapse;
  	}
  	th, td {
	    border-bottom: 1px solid #858796;
	    padding: 10px;
  	}
  	#repleInsertBtn{
  		width : 75px;
  		height : 75px;
  		font-size: 18px;
  		vertical-align: top;
  		background-color: #3C5087;
  		border-color: #3C5087;
  	}
  	#repleContent{
  		width: 92%;
  	}
  	.showRepleDiv{
  		margin-bottom: 2px;
  		width: 98%;
  	}
		
</style>
</head>

<body id="page-top">
    <!-- Page Wrapper -->
    <div id="wrapper">
        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <!-- Main Content -->
            <div id="content">
                <!-- Begin Page Content -->
                <div class="container-fluid"  style="max-width: 90%;">
                    <!-- Page Heading -->
                    <h2 class="h3 mb-2 text-gray-800" style="display: inline;"><i class="fas fa-book-open" style="margin-left: 10px; "></i>&nbsp&nbsp 자유 게시글</h2>
                    <hr>
                    <br>
                    
                    
                    <!-- summernote -->
					<form action="" method="post" enctype="multipart/form-data">
	                    <table  width="100%" cellspacing="0" id="boardViewTable">
	                    	<tr>
	                    		<td class="front"><i class="fas fa-fw fa-pencil-alt"></i>&nbsp;&nbsp;&nbsp;제목</td>
	                    		<td>
	                    			<span>${freeBoard.title }</span>
	                    		</td>
	                    	</tr>
	                    	<br>
	                    	<tr>
	                    		<td class="front"><i class="fas fa-user-edit"></i>&nbsp;&nbsp;작성자</td>
	                    		<td>
	                    			<span>${freeBoard.empNm }</span>
	                    		</td>
	                    	</tr>
	                    	
	                    	
							<tr>
								<td class="front"><i class="fas fa-fw fa-paperclip" style="margin-left: 10px;"></i>첨부파일</td>
								<td id="fileAddTD">
								
									<!-- db에서 파일 가져오기 -->
									<div id="DBfileDivParent" class="col-sm-10 DBfileAddedDiv" style="margin-bottom : 5px;">
										<c:if test="${freeBoardFileList.size() > 0}">
											<c:forEach var="i" begin="0" end="${freeBoardFileList.size()-1}" step="1">
												<div class="DBfileDivChild" data-fileid="${freeBoardFileList.get(i).attachfileSeq }">
													<a href="/freeBoard/fileDown?attachfileSeq=${freeBoardFileList.get(i).attachfileSeq}&postSeq=${freeBoardFileList.get(i).postSeq}">▶&nbsp;${freeBoardFileList.get(i).realfilename}</a>
												</div>
											</c:forEach>
										</c:if>
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2">
								 	<textarea id="summernote" name="cont">${freeBoard.cont }</textarea>
								</td>
							</tr>
							</table>
						 	<br>
						 	
						 	<input type="hidden" name="title" value="${freeBoard.title }"/>
						 	<input type="hidden" name="postSeq" value="${freeBoard.postSeq }"/>
						 	
						 	
						 	<input id="backBtn" type="button" class="btn btn-outline-secondary btn-left" 
						 	value="목록" style="display:inline; margin-right: 10px; float: left; background: #3C5087; color: white;"/>
						 	
						 	<c:if test="${EMP.empId == freeBoard.empId}">
							 	<input type="button" id="updateBoardBtn" class="btn btn-outline-secondary"
							 	value="수정" style="float: right; margin-left: 10px; background: #f6c23e; border-color: #f6c23e; color: white;"/>
							 	
							 	<input type="button" id="delBoardBtn" class="btn btn-outline-secondary"
							 	value="삭제" style="float: right;  background: #e74a3b; border-color: #e74a3b; color: white;"/>
							 	
							 	
						 	</c:if>
						</form>
						
						<br><br><br>
						
		                <div id="repleDivParent" >
		                	<div id="repleDivHeader"><span>댓글 목록</span></div>
		                	<hr>
							<div id="repleDivBody" style="margin-left: 3%;">
								<c:if test="${repleList.size() > 0}">
									<c:forEach items="${repleList }" var="reple">
										<div class="showRepleDiv" 
											style="color: black; background: #F1F1F1; border-radius: 20px; padding: 20px; font-size: 15px; font-family: inherit;" >
											<input type="hidden" class="repleSeq" name="repleSeq" value="${reple.repleSeq }" />
											[ 작성자 : ${reple.empNm } ]
											<div style="float: right;">
												작성일자 : <fmt:formatDate value="${reple.regDt }" pattern="YYYY-MM-dd"/>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<c:if test="${reple.empId == EMP.empId}">
													<c:if test="${reple.repleSt == 'Y' }">
														<button type="button" class="btn btn-danger delRepleBtn" 
														style="float: right; margin-right: 5px; margin-top: -5px;">삭제</button>											
													</c:if>
												</c:if>
											</div>
											
											<br><br>
											<span>${reple.repleCont }</span>
										</div>
										<br>
									</c:forEach>
								</c:if>
							</div>
		                	<hr>
							<form id="repleWriteForm" action="/freeBoard/repleRegist" method="post">
								<input type="hidden" name="postSeq" value="${freeBoard.postSeq }"/>
								<input type="hidden" id="freeBoardEmpId" name="empId" value="${freeBoard.empId }"/>
								<div id="writeRepleDiv" style="margin-left: 3%;" >
									<textarea id="repleContent" name="repleCont" rows="3" cols="10" style="resize: none;"></textarea>&nbsp;
									<button type="button" id="repleInsertBtn" class="btn btn-success">등록</button>
								</div>
							</form>
		                	<hr>
		                </div>
				
				
				
				
				
				
				<!-- End summernote -->
                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->
            
            
            	

        </div>
        <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->

    <!-- Scroll to Top Button-->
<!--     <a class="scroll-to-top rounded" href="#page-top"> -->
<!--         <i class="fas fa-angle-up"></i> -->
<!--     </a> -->

    
</body>
