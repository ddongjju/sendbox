<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script>
$('table.loadApprovTable').on('click', function(){
	var emptyLine = document.querySelector(".emptyApprovLine");
	
	//console.log('table checked!!');
	//console.log("${apprLineCounterList.size()-1 < 0}");
	if(emptyLine == null){
		$('.selectedApprovLine').removeClass('selectedApprovLine');
		$(this).addClass('selectedApprovLine');
		var radioItem = $(this).prevAll('input:radio');
		var label = $(this).prevAll('.apprLineLabel');
		$(radioItem).prop('checked', true);
		$('.apprLineLabel').css({'font-weight' : '', 'color' : ''});
		$(label).css({'font-weight' : 'bold', 'color' : '#154999'});
		$('.loadApprovTable').css({'border' : '3px solid #858796', 'box-shadow' : '2px 2px 5px #858796', 'font-weight' : '', 'color' : '' });
		$(this).css({'border' : '3px solid #154999', 'box-shadow' : '3px 4px 4px #154999', 'font-weight' : 'bold', 'color' : '#154999'});
		
	}
	
})
</script>

      			<c:forEach begin="0" end="${apprLineCounterList.size()-1 < 0 ? 0 : apprLineCounterList.size()-1}" var="i">
     				<br>
     				<div>
			      	<label class="apprLineLabel">${apprLineCounterList[i].apprKind }</label>
     				<input type="radio" name="apprKind" value="${apprLineCounterList[i].apprKind }" style="display: none;">
			      	<table class="loadApprovTable" border="1" style="float: right;">
			      		<thead>
			      			<tr>
			      				<th>결재라인명</th>
			      				<th>결재순서</th>
			      				<th>결재자</th>
			      				<th>부서</th>
			      				<th>직급</th>
			      			</tr>
			      		</thead>
			      		
			      		<tbody>
			      			<c:choose>
				      			<c:when test="${apprLineCounterList.size()-1 < 0}">
									<tr class="emptyApprovLine"><td colspan="5">결재라인을 추가해주세요</td></tr>
								</c:when>
								<c:otherwise>
			      					<c:set var="base" value="0"/>
			      					<c:if test="${i > 0 }">
				      					<c:forEach begin="0" end="${i-1}" var="k">
				      						<c:set var="base" value="${base + apprLineCounterList[k].apprLineCnt }"/>
				      					</c:forEach>      					
			      					</c:if>
					      			<c:forEach begin="0" end="${apprLineCounterList[i].apprLineCnt-1 }" var="j">
					      				<tr>
					      					<td>${approvLineList[j + base].apprKind }</td>
					      					<td>${approvLineList[j + base].apprStep }</td>
					      					<td data-apprCurrEmp = "${approvLineList[j + base].apprCurrEmp }">
					      						${approvLineList[j + base].currEmpNm }
					      					</td>
					      					<td data-currDeptId = "${approvLineList[j + base].currDeptId }">
					      						${approvLineList[j + base].currDeptNm }
					      					</td>
					      					<td data-currJobId = "${approvLineList[j + base].currJobId}">
					      						${approvLineList[j + base].currJobNm }
					      					</td>
					      				</tr>	      			
					      			</c:forEach>
								</c:otherwise>
			      			</c:choose>
			      		</tbody>
			      	</table>
			      	</div>
		      </c:forEach>