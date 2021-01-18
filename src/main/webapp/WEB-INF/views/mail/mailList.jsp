<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10.12.5/dist/sweetalert2.all.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.rawgit.com/moonspam/NanumSquare/master/nanumsquare.css">
<title>수신 메일함</title>

<link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
      rel="stylesheet">

<style type="text/css">
	a{
		color: #858796;
	}
	#dataTable_filter{
		width: 200px;
		float: right;
	}
	#dataTable_filter{
		
	}
	label {
		width: 200px;
	}
	
	
	.form-control{
		display : inline;
/* 		width : 200px; */
	}
</style>

<script>

	$(document).ready(function() {
		
		$('input[name=tdbox]').on('click',function(){
			if($(this).is(":checked") == true){
				$(this).parent().parent().css('background-color','#EBF7FF');
			} else {
				$(this).parent().parent().css('background-color','white');
			}
		})
		
		$('.mailtitle').on('click',function(){
			
			var mailSeq = $(this).parent().parent().find("td:first").children().val()
			
			$.ajax({
				
				url : "/mail/read",
				method : "post",
				data : {
					mailSeq : mailSeq
				},
				success : function(data){
					location.href = "/mail/detail?mailSeq="+mailSeq;
				}
			})
			
		})
		
		
		if(${param.searchCondition == 'title'}){
			$('#searchType').val('title')
		} else if(${param.searchCondition == 'content'}){
			$('#searchType').val('content')
		} else if(${param.searchCondition == 'sender'}){
			$('#searchType').val('sender')
		}
		
		if(${param.searchKeyword != ''}){
			$('#searchKeyword').val("${param.searchKeyword}")		
		}
		
		$('#thbox').on('click', function() {
			checkAll();
		})

		$('#deleteBtn').on('click', function() {
			var checked = checkValue();
			if (checked == '') {
				alert('삭제하실 메일을 선택해주세요')
			} else {
				var result = confirm("메일을 삭제하시겠습니까 ?");
				if(result){
					$.ajax({
						url : "/mail/delete",
						method : "post",
						data : {
							mailSeq : checked
						},
						success : function(data) {
							window.location.href = "/mail/list";
						}
					})
				} 
			}
		});
		
		$('#searchBtn').on('click',function(){
			var searchCondition = $('#searchType option:selected').val()
			var searchKeyword = $('#searchKeyword').val()
			if(searchKeyword == ''){
				alert('키워드를 입력해주세요.')
				location.href = "/mail/list";
			} else {
				location.href = "/mail/list?searchCondition=" +searchCondition+ "&searchKeyword=" + searchKeyword;
			}
			var i = 0;
			
			
		})
	});

	function checkAll() {
	      if ($('#thbox').is(':checked')) {
	         $("input[name=tdbox]").prop("checked", true);
	         $('.listClass').css('background-color','#EBF7FF')
	      } else {
	         $("input[name=tdbox]").prop("checked", false);
	         $('.listClass').css('background-color','white')
	      }
	   }
	
	function checkValue() {
		var checked = "";
		$("input[name='tdbox']:checked").each(function() {
			checked = checked + $(this).val	() + ",";
		});
		checked = checked.substring(0, checked.lastIndexOf(",")); //맨끝 콤마 지우기
		return checked;
	}
</script>
</head>

<body id="page-top">

<!-- Page Wrapper -->
<div id="wrapper">


    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

        <!-- Main Content -->
        <div id="content">


            <!-- Begin Page Content -->
            <div class="container-fluid">
                <!-- Page Heading -->
                <br>
                <!-- DataTales Example -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text"><i class="fas fa-envelope-open" style="margin-left: 10px;"></i>&nbsp;받은 메일함</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive" style="overflow: hidden;">
                        
                        
                        <div id="tableHeader" style="margin-bottom: 10px;">
                        <select class="form-control" name="type" style="width : 7%;" id="searchType">
                        	<option value="title">제목</option>
                        	<option value="content">내용</option>
                        	<option value="sender">발신인</option>
                        </select>
                        <input type="text" placeholder="검색 키워드를 입력해주세요" style="width : 22%;" 
                        		class="form-control" id="searchKeyword">
                        <a href="#"><i class="fas fa-search" style="font-size : 20px; margin-bottom:7px;" id="searchBtn"></i></a>
                        <a href="#"><i class="far fa-trash-alt" style="font-size : 25px; float:right;" id="deleteBtn"></i></a>
                        </div>
                           
                           
                           
                            <table class="table table-bordered" width="100%" cellspacing="0" style="text-align: center;">
                                <thead>
                                    <tr>
                                        <th style="width : 8%;"><input type="checkbox" id="thbox"></th>
                                        <th style="width : 8%;">읽음</th>
                                        <th style="width : 15%;">발신인</th>
                                        <th>제목</th>
                                        <th style="width : 15%;">시간</th>
                                    </tr>
                                </thead>
                                
                                <tbody id="mailList">
                                	
                                	<c:forEach items="${MailList }" var="mail">
	                                     <tr class="listClass">
	                                     	 <td><input type="checkbox" name="tdbox" value="${mail.mailSeq }"></td>
	                                     	 <td>
	                                     	 <c:if test="${mail.mailCnt == 'Y' }">
	                                     	 	<i class="far fa-envelope-open"></i>
	                                         </c:if>
	                                         
	                                         <c:if test="${mail.mailCnt == 'N' }">
	                                         	<i class="far fa-envelope" style="color : blue;"></i>
	                                         </c:if>
	                                     	 
	                                     	 </td>
	                                     	 
	                                         <c:if test="${mail.mailCnt == 'Y' }">
	                                         <td>
		                                         ${mail.sender }@sendbox.com
		                                         </td>
	                                         </c:if>
	                                         
	                                         <c:if test="${mail.mailCnt == 'N' }">
	                                         <td style="color : blue;">
		                                         ${mail.sender }@sendbox.com
	                                         </td>
	                                         </c:if>
	                                         
	                                         
	                                         <td style="text-align : left;">
	                                         <c:if test="${mail.mailCnt == 'Y' }">
		                                         <a href="#" class="mailtitle">${mail.title}</a>
	                                         </c:if>
	                                         
	                                         <c:if test="${mail.mailCnt == 'N' }">
		                                         <a href="#" style="color : blue;" class="mailtitle">${mail.title}</a>
	                                         </c:if>
	                                         </td>
	                                         <c:if test="${mail.mailCnt == 'Y' }">
	                                         <td>
		                                         ${mail.mailSendTime}
		                                         </td>
	                                         </c:if>
	                                         
	                                         <c:if test="${mail.mailCnt == 'N' }">
	                                         <td style="color : blue;">
		                                         ${mail.mailSendTime}
	                                         </td>
	                                         </c:if>
	                                     </tr>
                                   	</c:forEach>
                                   	
                                   	
                                   	
                                   	<c:if test="${fn:length(MailList) == 0 }">
                                   		<tr>
                                   			<td colspan="5">메일이 없습니다</td>
                                   		</tr>
                                   	</c:if>
                                   	
                                </tbody>
                                
                            </table>
                        </div>
                        
<!--                         페이징 -->
                        <div class="row">
								<div class="col-sm-12 col-md-5">
									<div class="dataTables_info" id="dataTable_info" role="status" aria-live="polite">
									</div>
								</div>
								
								<div class="col-sm-12 col-md-7">
									<div class="dataTables_paginate paging_simple_numbers" id="dataTable_paginate">
										<ul class="pagination">
											<c:choose>
												<c:when test="${pagination.currentPageNo == 1 }">
													<li class="paginate_button page-item previous disabled" id="dataTable_previous">
														<a href="#" aria-controls="dataTable"  class="page-link">
															<i class="fas fa-angle-double-left"></i>
														</a>
													</li>
													<li class="paginate_button page-item previous disabled" id="dataTable_previous">
														<a href="#" aria-controls="dataTable"  class="page-link">
															<i class="fas fa-angle-left"></i>
														</a>
													</li>
												
												</c:when>
												<c:otherwise>
													<li class="paginate_button page-item previous" id="dataTable_previous">
														<c:choose>
								                        <c:when test="${param.searchCondition == null}">
															<a href="/mail/list" aria-controls="dataTable"  class="page-link">
																<i class="fas fa-angle-double-left"></i>
															</a>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<a href="/mail/list?searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable"  class="page-link">
																<i class="fas fa-angle-double-left"></i>
															</a>
								                        </c:when>
							                        	</c:choose>
													</li>
													<li class="paginate_button page-item previous" id="dataTable_previous">
														<c:choose>
								                        <c:when test="${param.searchCondition == null}">
															<a href="/mail/list?pageIndex=${pagination.currentPageNo-1}" aria-controls="dataTable"  class="page-link">
																<i class="fas fa-angle-left"></i>
															</a>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<a href="/mail/list?pageIndex=${pagination.currentPageNo-1}&searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable"  class="page-link">
																<i class="fas fa-angle-left"></i>
															</a>
								                        </c:when>
							                        	</c:choose>
													</li>
												</c:otherwise>
											
											
											</c:choose>
											
											
											<c:forEach begin="${pagination.getFirstPageNoOnPageList() }" end="${pagination.getLastPageNoOnPageList() }" step="1" var="i">
												<c:choose>
													<c:when test="${pagination.currentPageNo == i }">
														<li class="paginate_button page-item active">
															<a aria-controls="dataTable"  class="page-link">${i }</a>
														</li>
													</c:when>
													<c:otherwise>
													<c:choose>
								                        <c:when test="${param.searchCondition == null}">
															<li class="paginate_button page-item">
																<a href="/mail/list?pageIndex=${i}" aria-controls="dataTable"  class="page-link">${i }</a>
															</li>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<li class="paginate_button page-item">
																<a href="/mail/list?pageIndex=${i}&searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable"  class="page-link">${i }</a>
															</li>
								                        </c:when>
							                        	</c:choose>
													</c:otherwise>
												</c:choose>
											</c:forEach>
											
											
											<c:choose>
												<c:when test="${pagination.currentPageNo == pagination.getTotalPageCount()}">
													<li class="paginate_button page-item next disabled" id="dataTable_next">
														<a href="#" aria-controls="dataTable" " class="page-link">
															<i class="fas fa-angle-right"></i>
														</a>
													</li>
													<li class="paginate_button page-item next disabled" id="dataTable_next">
														<a href="#" aria-controls="dataTable"  class="page-link">
															<i class="fas fa-angle-double-right"></i>
														</a>
													</li>
												
												
												</c:when>
												<c:otherwise>
													<li class="paginate_button page-item next" id="dataTable_next">
														<c:choose>
								                        <c:when test="${param.searchCondition == null}">
															<a href="/mail/list?pageIndex=${pagination.currentPageNo+1}" aria-controls="dataTable" data-dt-idx="2" tabindex="0" class="page-link">
																<i class="fas fa-angle-right"></i>
															</a>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<a href="/mail/list?pageIndex=${pagination.currentPageNo+1}&searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable" data-dt-idx="2" tabindex="0" class="page-link">
																<i class="fas fa-angle-right"></i>
															</a>
								                        </c:when>	
							                        	</c:choose>
													</li>
													<li class="paginate_button page-item next" id="dataTable_next">
														<c:choose>
								                        <c:when test="${param.searchCondition == null}">
															<a href="/mail/list?pageIndex=${pagination.getTotalPageCount()}" aria-controls="dataTable" data-dt-idx="2" tabindex="0" class="page-link">
																<i class="fas fa-angle-double-right"></i>
															</a>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<a href="/mail/list?pageIndex=${pagination.getTotalPageCount()}&searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable" data-dt-idx="2" tabindex="0" class="page-link">
																<i class="fas fa-angle-double-right"></i>
															</a>
								                        </c:when>
							                        	</c:choose>
													</li>
												</c:otherwise>
											</c:choose>
										</ul>
									</div>
								</div>
							</div>   
                        
                        
                        
                        
                        
			<!-- 글작성버튼 -->
		</div>
                </div>

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

    <!-- Core plugin JavaScript-->
    <script src="/admin2form/vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="/admin2form/js/sb-admin-2.min.js"></script>

    <!-- Page level plugins -->
    <script src="/admin2form/vendor/datatables/jquery.dataTables.min.js"></script>
    <script src="/admin2form/vendor/datatables/dataTables.bootstrap4.min.js"></script>

    <!-- Page level custom scripts -->
    <script src="/admin2form/js/demo/datatables-demo.js"></script>
    
    
</body>

</html>