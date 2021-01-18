<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>업무게시판</title>

<link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
      rel="stylesheet">

<style type="text/css">
	a{
		color: #858796;
	}
	label {
		width: 200px;
	}
	
	#tr1:hover{
		background-color : #EBF7FF;
	}
</style>

<script>
$(document).ready(function(){
	$("#insertEmp").on("click", function() {
		document.location.href = "/insertEmp";
	});
	
	$('#empList #tr1').on('click',function(){
		var empId =$(this).data("a");
		console.log(empId)

		document.location="/emp?empId="+empId;
	})
	$('#recordCnt').change(function(){
		var recordCountPerPage = $("#recordCnt option:selected").val();
		console.log($("#recordCnt option:selected").val());
		document.location = "/empManage?recordCountPerPage="+recordCountPerPage;
	})
	
	
	if(${param.searchCondition == 'emp_nm'}){
		$('#searchType').val('emp_nm')
	} else if(${param.searchCondition == 'emp_id'}){
		$('#searchType').val('emp_id')
	} else if(${param.searchCondition == 'dept_name'}){
		$('#searchType').val('dept_name')
	}
	
	if(${param.searchKeyword != ''}){
		$('#searchKeyword').val("${param.searchKeyword}")		
	}
	
	$('#btnSearch').on('click',function(){
		var searchCondition = $('#searchType option:selected').val()
		var searchKeyword = $('#searchKeyword').val()
		
		var i = 0;
		
		if(searchKeyword == ''){
			alert('키워드를 입력해주세요')
			location.href = "/empManage";
		} else {
			location.href = "/empManage?searchCondition=" +searchCondition+ "&searchKeyword=" + searchKeyword;
		}
		
		
	})
	
	
	
});	

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
                    <a href="/empManage" style="text-decoration: none;"><h2 class="h3 mb-2 text-gray-800"><i class="fas fa-user-friends" style="margin-left: 10px;"></i>&nbsp&nbsp사원관리</h2></a>
                    <br>
                    <!-- DataTales Example -->
                    <div class="card shadow mb-4">
<!--                         <div class="card-header py-3"> -->
<!--                             <h6 class="m-0 font-weight-bold text-primary"> <a target="_blank" href="#"><i class="fas fa-fw fa-head-side-cough-slash" style="margin-left: 10px;"></i>&nbsp업무시간 마스크는 필수입니다.</a></h6> -->
<!--                         </div> -->
                        <div class="card-body">
                            <div class="table-responsive" style="overflow: hidden;">
                            
						<div id="tableHeader" style="margin-bottom: 20px;">
	                        <select class="form-control" name="type" style="width : 7%; float: left;" id="searchType">
	                        	<option value="emp_nm">사원명</option>
	                        	<option value="emp_id">사원번호</option>
	                        	<option value="dept_name">부서</option>
	                        </select>
                        <input type="text" placeholder="검색 키워드를 입력해주세요" style="width : 22%; float: left; margin-left:10px;" 
                        		class="form-control" id="searchKeyword">
                        <a href="#"><i class="fas fa-search" style="font-size : 25px; margin-top:5px; margin-left:5px; float:left;" id="btnSearch"></i></a>
                        </div>
								<table class="table table-bordered" id=""  cellspacing="0" style="margin-top: 50px;">
                                    <thead style="text-align: center;">
                                        <tr>
                                            <th>사원번호</th>
                                            <th>사원명</th>
                                            <th>부서</th>
                                            <th>우편번호</th>
                                            <th>기본주소</th>
                                            <th>상세주소</th>
                                            <th>연락처</th>
                                            <th>계좌</th>
                                            <th>퇴사구분</th>
                                        </tr>
                                    </thead>
                                    <tbody id="empList"  style="text-align: center;"> 
                                      <c:forEach items="${list}" var="list"> 
                                        <tr id="tr1" data-a="${list.empId }">
                                            <td>${list.empId }</td>
                                            <td>${list.empNm }</td>
                                            <td>${list.deptId }</td>
                                            <td>${list.zipcode }</td>
                                            <td>${list.addr1 }</td>
                                            <td>${list.addr2 }</td>
                                            <td>${list.empHp }</td>
                                            <td>${list.bankAcctNo }</td>
                                            <td>
                                            <c:choose>
                                            	<c:when test="${list.empQuitYn =='N'}">재직</c:when>
                                            	<c:otherwise>퇴사</c:otherwise>
                                            </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                      <c:if test="${fn:length(list) == 0 }">
                                         <tr>
                                            <td colspan="9" style="text-align: center;">일치하는 사원 정보가 없습니다.</td>
                                         </tr>
                                      </c:if>
                                        
                                    </tbody>
                                </table>
                            </div>
                            
                          <!-- 페이징 처리  -->
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
															<a href="/empManage" aria-controls="dataTable"  class="page-link">
																<i class="fas fa-angle-double-left"></i>
															</a>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<a href="/empManage?searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable"  class="page-link">
																<i class="fas fa-angle-double-left"></i>
															</a>
								                        </c:when>
							                        	</c:choose>
													</li>
													<li class="paginate_button page-item previous" id="dataTable_previous">
														<c:choose>
								                        <c:when test="${param.searchCondition == null}">
															<a href="/empManage?pageIndex=${pagination.currentPageNo-1}" aria-controls="dataTable"  class="page-link">
																<i class="fas fa-angle-left"></i>
															</a>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<a href="/empManage?pageIndex=${pagination.currentPageNo-1}&searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable"  class="page-link">
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
																<a href="/empManage?pageIndex=${i}" aria-controls="dataTable"  class="page-link">${i }</a>
															</li>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<li class="paginate_button page-item">
																<a href="/empManage?pageIndex=${i}&searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable"  class="page-link">${i }</a>
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
															<a href="/empManage?pageIndex=${pagination.currentPageNo+1}" aria-controls="dataTable" data-dt-idx="2" tabindex="0" class="page-link">
																<i class="fas fa-angle-right"></i>
															</a>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<a href="/empManage?pageIndex=${pagination.currentPageNo+1}&searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable" data-dt-idx="2" tabindex="0" class="page-link">
																<i class="fas fa-angle-right"></i>
															</a>
								                        </c:when>	
							                        	</c:choose>
													</li>
													<li class="paginate_button page-item next" id="dataTable_next">
														<c:choose>
								                        <c:when test="${param.searchCondition == null}">
															<a href="/empManage?pageIndex=${pagination.getTotalPageCount()}" aria-controls="dataTable" data-dt-idx="2" tabindex="0" class="page-link">
																<i class="fas fa-angle-double-right"></i>
															</a>
								                        </c:when>
								                        <c:when test="${param.searchCondition != null}">
															<a href="/empManage?pageIndex=${pagination.getTotalPageCount()}&searchCondition=${param.searchCondition }&searchKeyword=${param.searchKeyword }" aria-controls="dataTable" data-dt-idx="2" tabindex="0" class="page-link">
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
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
    						<button id="insertEmp" type="button" class="btn btn-outline-primary" style="float: right;">회원등록</button>
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