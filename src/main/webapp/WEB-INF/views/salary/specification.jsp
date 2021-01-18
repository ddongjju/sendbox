<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<title>SENDBOX</title>

<link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
      rel="stylesheet">

<style type="text/css">
	a{
		color: #858796;
	}
	label {
		width: 200px;
	}
	@font-face {
  font-family: 'LotteMartHappy';
  font-style: normal;
  font-weight: 400;
  src: url('//cdn.jsdelivr.net/korean-webfonts/1/corps/lottemart/LotteMartHappy/LotteMartHappyMedium.woff2') format('woff2'), url('//cdn.jsdelivr.net/korean-webfonts/1/corps/lottemart/LotteMartHappy/LotteMartHappyMedium.woff') format('woff');
}

@font-face {
  font-family: 'LotteMartHappy';
  font-style: normal;
  font-weight: 700;
  src: url('//cdn.jsdelivr.net/korean-webfonts/1/corps/lottemart/LotteMartHappy/LotteMartHappyBold.woff2') format('woff2'), url('//cdn.jsdelivr.net/korean-webfonts/1/corps/lottemart/LotteMartHappy/LotteMartHappyBold.woff') format('woff');
}

.lottemarthappy * {
 font-family: 'LotteMartHappy', sans-serif;
}
</style>

<script>

$(function(){
	
	$('#year').val(${param.year})
	var month = '${param.month}';
	$('option[value='+month+']').prop('selected', true);
	
	
	$('#searchBtn').on('click',function(){
		
		var year = $('#year option:selected').val()
		var month = $('#month option:selected').val()
		
		location.href = "/salary/specification?year=" + year + "&month=" + month;
		
		
	})
	
	
	$('#excel').on('click',function(){
		var year = $('#year option:selected').val()
		var month = $('#month option:selected').val()
		location.href = "/salary/excel2?year=" + year + "&month=" + month;
	})
})


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
                   <h2 class="h3 mb-2 text-gray-800"> <i class="fas fa-money-check-alt" style="margin-left: 10px;"></i>&nbsp&nbsp급여조회</h2>
                    <br>
                    <!-- DataTales Example -->
                    <div class="card shadow mb-4">
<!--                         <div class="card-header py-3"> -->
<!--                             <h6 class="m-0 font-weight-bold text-primary"> <a target="_blank" href="#"><i class="fas fa-fw fa-head-side-cough-slash" style="margin-left: 10px;"></i>&nbsp업무시간 마스크는 필수입니다.</a></h6> -->
<!--                         </div> -->
                        <div class="card-body">
                            <div class="table-responsive" style="overflow: hidden;">
                            
                            
								<select class="form-control" name="year" id="year"
									style="width: 100px; float: left; margin: 5px;">
									<c:forEach var="i" begin="2018" step="1" end="${yy }">
										<option value="${i }">${i }년</option>
									</c:forEach>
								</select> 
								
								<select class="form-control" name="month" id="month"
									style="width: 100px; float: left; margin: 5px;">
									<option value="01">1월</option>
									<option value="02">2월</option>
									<option value="03">3월</option>
									<option value="04">4월</option>
									<option value="05">5월</option>
									<option value="06">6월</option>
									<option value="07">7월</option>
									<option value="08">8월</option>
									<option value="09">9월</option>
									<option value="10">10월</option>
									<option value="11">11월</option>
									<option value="12">12월</option>
								</select>
								<input id="searchBtn" type="button" value="검색" style="margin-top : 5px; height : 38px;">
                                
                                
                                <table class="table table-bordered" id="" style="text-align: center;">
									<c:if test="${check eq 'O' }">
										<tr>
											<td colspan="4" style="font-size: 1.5em;">${year }년 ${month }월 급여명세서</td>
										</tr>
										<tr>
											<td colspan="2" style="text-align: left;">
											<c:if test="${salaryVO.deptName eq '사장' }">
												SENDBOX
											</c:if>
											<c:if test="${salaryVO.deptName ne '사장' }">
												${salaryVO.deptName }
											</c:if>
											${salaryVO.empNm } ${salaryVO.jobtitleNm } </td>
											<td colspan="2" style="text-align: right;">지급일 : ${salaryVO.salaryDt }</td>
										</tr>
										<tr style="background-color: #EAEAEA;">
											<td colspan="2">급여 내역</td>
											<td colspan="2">공제 내역</td>
										</tr>
										
										<tr>
											<td style="width: 300px;">기본급여</td>
											<td style="text-align: right; width: 300px;">	
												<fmt:parseNumber value="${salaryVO.basicAmt }" var="basicAmt"/>
												<fmt:formatNumber value="${basicAmt }" var="basicAmt2"/>
												${basicAmt2 } 원
											</td>
											<td style="width: 300px;">소득세</td>
											<td style="text-align: right; width: 300px;">
												<fmt:parseNumber value="${basicAmt*0.03 }" var="incomeTax"/>
												<fmt:formatNumber value="${incomeTax }" var="incomeTax2"/>
												${incomeTax2 } 원
											</td>
										</tr>
										
										<tr>
											<td>초과근무수당</td>
											<td style="text-align: right;">	
												<fmt:parseNumber value="${salaryVO.plusAmt }" var="plusAmt"/>
												<fmt:formatNumber value="${plusAmt }" var="plusAmt2"/>
												${plusAmt2 } 원
											</td>
											<td>주민세</td>
											<td style="text-align: right;">	
												<fmt:parseNumber value="${incomeTax*0.1 }" var="residentTax"/>
												<fmt:formatNumber value="${residentTax }" var="residentTax2"/>
												${residentTax2 } 원
											</td>
										</tr>
										
										<tr>
											<td></td>
											<td></td>
											<td>국민연금</td>
											<td style="text-align: right;">
												<fmt:parseNumber value="${basicAmt*0.045 }" var="nationalPension"/>
												<fmt:formatNumber value="${nationalPension }" var="nationalPension2"/>
												${nationalPension2 } 원
											</td>
										</tr>
										<tr>
											<td></td>
											<td></td>
											<td>건강보험</td>
											<td style="text-align: right;">
												<fmt:parseNumber value="${basicAmt*0.032 }" var="healthInsurance"/>
												<fmt:formatNumber value="${healthInsurance }" var="healthInsurance2"/>
												${healthInsurance2 } 원
											</td>
										</tr>
										<tr>
											<td></td>
											<td></td>
											<td>고용보험</td>
											<td style="text-align: right;">
												<fmt:parseNumber value="${basicAmt*0.008 }" var="empolymentInsurance"/>
												<fmt:formatNumber value="${empolymentInsurance }" var="empolymentInsurance2"/>
												${empolymentInsurance2 } 원
											</td>
										</tr>
										
										<tr>
											<td></td>
											<td></td>
											<td style="background-color: #EAEAEA;">공제총액</td>
											<td style="text-align: right;">
											<fmt:parseNumber value="${residentTax+incomeTax+nationalPension+healthInsurance+empolymentInsurance }" var="sumTax"/>
											<fmt:formatNumber value="${sumTax }" var="sumTax2"/>
											${sumTax2 } 원
											</td>
										</tr>
										
										<tr>
											<td style="background-color: #EAEAEA;">급여총액</td>
											<td style="text-align: right;">
												<fmt:parseNumber value="${salaryVO.salaryAmt }" var="salaryAmt"/>
												<fmt:formatNumber value="${salaryAmt }" var="salaryAmt2"/>
												${salaryAmt2 } 원
											</td>
											<td style="background-color: #EAEAEA;">실수령액</td>
											<td style="text-align: right;">
												<fmt:formatNumber value="${salaryAmt-sumTax }" var="finalAmt"/>
												${finalAmt } 원
											</td>
										</tr>
									</c:if>
									
									
									<c:if test="${check eq 'X' }">
										<tr>
											<td>해당 월의 기록이 존재하지 않습니다.</td>
										</tr>
									</c:if>
									
									
								</table>
								
								<c:if test="${check eq 'O' }">
								<button type="button" id="excel" class="btn btn btn-success" style="float: right;">엑셀 다운로드</button>
								</c:if>
								
                            </div>
                            
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