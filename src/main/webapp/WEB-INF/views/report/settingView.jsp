<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<style>
	img.typeIcon{
		
		width : 200px;
		height :200px;
		margin-right : 30px;
	
	}
	table{
		text-align :center;
		display : inline-block;
		margin-right : 50px;
		width : 700px;
	}
	
	.loadApprovTable{
		border : 3px solid #858796;
		box-shadow: 2px 2px 5px #858796;	
	}
	
	td, th{
	width : 200px;
	height : 50px;
	}
	
	.settingViewBtn{
		margin-left : 20px;
	}
	
	#typeTable{
/* 		text-align : center; */
		margin-left : 15%;
	}
	
	div.modal-body{
		height : 100px;
	}
	
	div.loadApprDiv{
		width : 800px;
		height : 700px;
	}
	
	input[type=checkbox]{
		width : 18px;
		height : 18px;
		vertical-align: middle;
	}
	
	#OrganChartDiv{
		width: 550px;
		height: 300px;
		margin: auto;
	}
	#jojikdo{
		display: inline-block;
		border: 1px solid black; 
		width: 200px; 
		height: 300px; 
		overflow: auto; 
		text-align: left;
	}
	
	#selectButtonDiv{
		text-align: center;
		float: right; 
		border: 1px solid black; 
		width: 100px;
		height: 300px;
		/* margin-right: 20px; */
	}
	#selectButtonDiv input{
		width: 80px;
		height: 30px;
		margin-top: 10px;
	}
	#jojikdoSelectDiv{
		float: right; 
		border: 1px solid black; 
		width: 220px;
		height: 300px;
		text-align : center;
		padding : 5px;
	}
	.addEmpInfotr th, .addEmpInfotr td{
		width : 70px;
		height : 10px;
	}
	
	.addEmpInfotr th:nth-child(1), 
	.addEmpInfotr th:nth-child(2), 
	.addEmpInfotr td:nth-child(1), 
	.addEmpInfotr td:nth-child(2) {
		border-right : 2px solid gray;
	}
	#upApprovLine{
	 	background-color: #003366;
	 	color: white;
	}
	#deleteApprover{
		background-color: #003366;
		color: white;
	}
	#listEmpty{
		background-color: #003366;
		color: white;
	}
	#downApprovLine{
		background-color: #003366;
		color: white;
	}
	#writeBtn{
		background-color: #003366;
		color: white;
	}
	#AddEmpBtn{
		margin: 10%;
	}
	#RemoveEmpBtn{
	margin: 10%;
	}
	#sortBtn{
	margin: 10%;
	}
	#btnLoad{
		background-color: #003366;
		color: white;
	}
	/* #btncancle{
		background-color: #003366;
		color: white;
	} */
	
	#btnSave{
		background-color: #003366;
		color: white;
	}
	
	#gray{
		vertical-align: middle;
	}
</style>


 <script>
	$(function(){
		
		console.log("${approvLineVo.empId}");
		console.log("${approvLineVo.typeId}");
		console.log("${approvLineVo.apprKind}");
		
		//전체 선택 / 해제 변수
		isChecked = false;
		//approverList = new Array();
		
		if("${approvLineVo.typeId != ''}"){
			td = $('td[data-typeid="${approvLineVo.typeId}"]');
			td.find('img.typeIcon').css({'border' : '3px solid #154999', 'box-shadow' : '3px 4px 4px #154999'});
			td.find('i.fa-check-circle').css({'visibility' : 'visible'});
			//window.scrollTo(0,document.body.scrollHeight);
			var typeId = "${approvLineVo.typeId}";
			$('.typeId').val(typeId);
		}
		
		apprKind = "${approvLineVo.apprKind}"
		
		if(apprKind == ''){
			console.log('null');
			$('#approvLineDiv').hide();
		}
		//결재선 입력 버튼
		/* $('#writeBtn').on('click', function(){		
			$('#writeReportForm').submit();
		
		}) */
		
		 $('#writeBtn').on('click', function(){
			var apprKind = $('.apprKind').val();
			if(apprKind == null || apprKind == ''){
				saveApprovLine();
			}else{
				$('#writeReportForm').submit();
			}
		})
		
		
		
		
		//양식 설정시 스크립트
		$('img.typeIcon').on('click', function(){
			$('.typeIcon').css({"border" : "none", 'box-shadow' : ''});
			$('.typeNmSpan').css({'font-weight' : '', 'color' : ''});
			$('.fa-check-circle').css({'visibility' : 'hidden'});
			$(this).css({'border' : '3px solid #154999', 'box-shadow' : '3px 4px 4px #154999'});
			$(this).parent().siblings('.typeNmSpan').css({'font-weight' : 'bold', 'color' : '#154999'});
			$(this).prev().css({'visibility' : 'visible', 'color' : '#154999'});
			var typeId = $(this).parents('td').data('typeid');
			$('#typeDiv').hide();
			console.log(typeId);
			$('#approvLineDiv').show();
			//window.scrollTo(0,document.body.scrollHeight);
			$('.typeId').val(typeId);
		})
		
		
		// 내 연차 페이지에서 휴가신청 클릭시 자동으로 양식을 휴가로 설정
		var reportVacatePath = "${reportVacatePath}";
		if(reportVacatePath == "vacatePage"){
			console.log("reportVacatePath = ", "${reportVacatePath}");
			var img = $("#reportVacateInfoImgTd").find("img.typeIcon");
			img.trigger("click");
			reportVacatePath = "";
			"${reportVacatePath = ''}";
		}
		
		//불러오기 버튼
		$("#btnLoad").on('click', function(){
			var selectedLine = document.querySelector('.selectedApprovLine');
			if(selectedLine != null){
				$('#approvLineForm').submit();
			}else{
				alert('결재라인을 선택해주세요');
			}
		})
		//양식 재설정 버튼
		$('#btnScrollUp').on('click', function(){
			$('#typeDiv').show();
			$('#approvLineDiv').hide();
		
			
			//window.scrollTo(100,document.body);
		})
		
		//전체 선택/해제
		$('#checkAll').on('click', function(){
			if(isChecked == false){
				$('.apprLineCheck').prop('checked', true);
				isChecked = true;
			}else{
				$('.apprLineCheck').prop('checked', false);
				isChecked = false;			
			}
		})
		
		//결재자 추가
		$('#addApprover').on('click', function(){
			var htmlList = new Array();
			var html = $('#addEmpInfotbody').find('tr');
			console.log('tbody tr : '+html);
			for(var i = 0; i<html.length;i++){
				htmlList.push(html[i]);
			}
			console.log(htmlList);
			
			var approvTrNum = $('.approvTr').length;
			for(var i = 0; i< htmlList.length; i++){
				console.log("i점검 : "+i);
				var dept = $(htmlList[i]).find('.dept').text();
				var jobtitle = $(htmlList[i]).find('.jobtitle').text();
				var currname = $(htmlList[i]).find('.currname').text();
				var currid = $(htmlList[i]).find('.currname').data('currid');
				
				
				var step = approvTrNum + i +1;
				console.log("step 점검 :"+step);
				var code = "";
				code += "<tr class='approvTr'>"
							+"<td><input type='checkbox' class='apprLineCheck'></td>"
							+"<td class='step'>"+step+"</td>"
							+"<td class='dept'>"+dept+"</td>"
							+"<td class='jobtitle'>"+jobtitle+"</td>"		
							+"<td class='currEmpId' data-currid="+currid+">"+currname+"</td>"
							+"</tr>"
				if($('.approvTr').length == 0){
					$('#approvLineResult').empty();
				}			
							
				$('#approvLineResult').append(code);
			}
			
			$('.approverCheck').prop('checked', false);
		})
		
		
		//결재자 삭제
		$('#deleteApprover').on('click', function(){
		
			var approvTr = $('.approvTr');
			var checkedItem = $('input:checkbox.apprLineCheck:checked').parents('tr');
			var step  = new Array();
			for(var i = 0; i < checkedItem.length; i++){
				step.unshift( parseInt($(checkedItem[i]).find('td.step').text()));
			}
			console.log(checkedItem);
			console.log(step);
			
			for(var i=0; i < step.length; i++){
				console.log(step[i]);
				var index = step[i];
				
				for(var j = step[i]; j < approvTr.length ; j++){
					console.log("loop!!");
					var num = parseInt($('.approvTr').eq(j).find('td.step').text())-1;
					console.log(num);
					$('.approvTr').eq(j).find('td.step').text(num);
				}
			}
			
			for(var i = 0; i< checkedItem.length; i++){
				$(checkedItem[i]).remove();
			}
			
			if($('.approvTr').length == 0){
				var html = '<tr><td colspan="5">결재라인을 추가해주세요</td></tr>';
				$('#approvLineResult').html(html);
			}
			
			$('input:checkbox').prop('checked', false);
		})
		
		//결재선 순서 변경(올리기)
		$('#upApprovLine').on('click', function(){
			var checkedItem = $('input:checkbox.apprLineCheck:checked').parents('tr');
			var step  = new Array();
			for(var i = 0; i < checkedItem.length; i++){
				step.unshift(checkedItem[i]);
			}
			console.log($(step[0]).prev());
			//처음이 포함 될때
			
			for(var i = 0; i< step.length; i++){
				if($(step[i]).prev().length != 0 && $(step[i]).prev().find('.apprLineCheck').prop('checked') == false){
					var temptext = $(step[i]).prev().find('.step').text();
					$(step[i]).prev().find('.step').text($(step[i]).find('.step').text());
					$(step[i]).find('.step').text(temptext);
					$(step[i]).insertBefore($(step[i]).prev());
				}
			}
		})
		
		//결재선 순서 변경(내리기)
		$('#downApprovLine').on('click', function(){
			var checkedItem = $('input:checkbox.apprLineCheck:checked').parents('tr');
			var step  = new Array();
			for(var i = 0; i < checkedItem.length; i++){
				step.push(checkedItem[i]);
			}
			console.log($(step[0]).next());
			//끝이 포함 될때
			
			for(var i = 0; i< step.length; i++){
				if($(step[i]).next().length != 0 && $(step[i]).next().find('.apprLineCheck').prop('checked') == false){
					var temptext = $(step[i]).next().find('.step').text();
					$(step[i]).next().find('.step').text($(step[i]).find('.step').text());
					$(step[i]).find('.step').text(temptext);
					$(step[i]).insertAfter($(step[i]).next());
				}
			}
		})
		
		//해제 텍스트 클릭시 체크 박스 모두 해제
		deselect = function(){
			$('.apprLineCheck').prop('checked', false);	
		}
		
		saveApprovLine = function(){
			var apprKind = $('#newName').val();
			var approvTrList = $('.approvTr');
			var param = {};
			param['empId'] = "${EMP.empId}";
			for(var i=0; i < approvTrList.length; i++){
				param['approvLineList['+i+'].apprStep'] = $(approvTrList[i]).find('td.step').text();
				param['approvLineList['+i+'].apprCurrEmp'] = $(approvTrList[i]).find('td.currEmpId').data('currid');
				var j = i+1 == approvTrList.length ? i : i+1;
				param['approvLineList['+i+'].apprNextEmp'] = $(approvTrList[j]).find('td.currEmpId').data('currid');
			}
			
			//내용이 있을때
			if(apprKind != null && apprKind != ''){
				param['apprKind'] = apprKind;
				param['apprStCode'] = "U";
			}else{
				param['apprStCode'] = "T";				
			}
			
			$.ajax({
				url : '/report/saveApprovLine',
				data : param,
				type : 'post',
				dataType : 'json',
				success : function(res){
					if(res.error != null && res.error != ''){
						alert(res.error);
					}
					else{
						$('.apprKind').val(res.apprKind);
						$('#newName').val('');
						if(res.apprStCode == 'T'){
							$('#writeReportForm').submit();						
						}else{
							$('#approvLineName').val(res.apprKind);
							alert(res.message);
						}												
					}
				}
			});				
		}
		
		/*궁리*/
		/*$('#btnSave').on('click', function(){
			
			var approvTrList = $('.approvTr');
			var param = {};
			for(var i=0; i < approvTrList.length; i++){
				param['approvLineList['+i+'].apprStep'] = $(approvTrList[i]).find('td.step').text();
				param['approvLineList['+i+'].apprCurrEmp'] = $(approvTrList[i]).find('td.currEmpId').data('currid');
				param['approvLineList['+i+'].empId'] = "${EMP.empId}";
				param['approvLineList['+i+'].apprKind'] = $('#newName').val();
				var j = i+1 == approvTrList.length ? i : i+1;
				param['approvLineList['+i+'].apprNextEmp'] = $(approvTrList[j]).find('td.currEmpId').data('currid');
			}
			
			$.ajax({
				url : '/report/saveApprovLine',
				data : param,
				type : 'post',
				dataType: 'json',
				success : function(res){
					$('#approvLineName').val($('#newName').val());
					$('.apprKind').val($('#newName').val());
					$('#newName').val('');
					alert(res.message);
				}
			});
			$('#saveApprovLineModal').modal('hide');
			console.log(param);	
			
		})*/
		
		$('#btnSave').on('click', function(){
			saveApprovLine();
			/* var approvTrList = $('.approvTr');
			var param = {};
			param['apprKind'] = $('#newName').val();
			param['empId'] = "${EMP.empId}";
			for(var i=0; i < approvTrList.length; i++){
				param['approvLineList['+i+'].apprStep'] = $(approvTrList[i]).find('td.step').text();
				param['approvLineList['+i+'].apprCurrEmp'] = $(approvTrList[i]).find('td.currEmpId').data('currid');
				//param['approvLineList['+i+'].empId'] = "${EMP.empId}";
				//param['approvLineList['+i+'].apprKind'] = $('#newName').val();
				//param['approvLineList['+i+'].apprStCode'] = 'U';
				var j = i+1 == approvTrList.length ? i : i+1;
				param['approvLineList['+i+'].apprNextEmp'] = $(approvTrList[j]).find('td.currEmpId').data('currid');
			}
			
			$.ajax({
				url : '/report/saveApprovLine',
				data : param,
				type : 'post',
				dataType: 'json',
				success : function(res){
					$('#approvLineName').val(res.apprKind);
					$('.apprKind').val(res.apprKind);
					$('#newName').val('');
					alert(res.message);
				}
			}); */
			$('#saveApprovLineModal').modal('hide');
			
		})
		

		$('#loadApprovLineList').on('click', function(){
			$.ajax({
				url : '/report/loadApprovLine',
				data : {empId : "${EMP.empId}"},
				type : 'post',
				success : function(res){
					$('#approvLineTemplate').html(res);
				}
			});
		});
		
		$('#listEmpty').on('click', function(){
			console.log('clicked!!!!');
			$('#approvLineResult').empty();
			
			var html = '<tr><td colspan="5">결재라인을 추가해주세요</td></tr>';
			$('#approvLineResult').html(html);
			
			
		});
		
		// 결재라인 불러오기 클릭시 상단의 양식 선택 메뉴 hide 함수
		var apprLineInfoSel = "${apprLineInfoSel}";
		console.log("apprLineInfoSel : ", "${apprLineInfoSel}")
		if(apprLineInfoSel == "selected"){
			console.log("apprLineInfoSel : ", "${apprLineInfoSel}")
			$('#typeDiv').hide();
			apprLineInfoSel = "";
			"${apprLineInfoSel = ''}"
		}
		
		
	});
	

</script>
<script>
	
		$(function(){
			
			$.ajax({
				url		: "/busiTree/businessTreeEmpDept",
				dataType: "json",
				method	: "post",
				success	: function(data){
					
					console.log("business data : ", data.businessTreeList);
					//조직도 자료
					var businessTreeList = data.businessTreeList;
					
					var TreeViewTag = "";
					
										for(var top=0; top<businessTreeList.length; top++){
											console.log(businessTreeList[top].upperDeptId);
						//사장인경우
						if(businessTreeList[top].upperDeptId == null){
							TreeViewTag += "	<li>";
							TreeViewTag += "		<span>&nbsp;&nbsp;"+businessTreeList[top].deptName+"</span>";
							TreeViewTag += "		<ul>";
							TreeViewTag += "			<li class='clickAddName' data-jobid="+businessTreeList[top].jobtitleId+" data-currid="+businessTreeList[top].empId+">&nbsp;&nbsp;"+businessTreeList[top].empNm+"["+businessTreeList[top].jobtitle+"]</li>";
							TreeViewTag += "		</ul>";
							
							var busiTop = businessTreeList[top].deptId;
							
							for(var i=0; i<businessTreeList.length; i++){
								
								if(businessTreeList[i].upperDeptId == busiTop){
									
									var busiBu = businessTreeList[i].deptId;
									
									console.log("busiBu = ", busiBu);
									
									TreeViewTag += "	<li>";
									TreeViewTag += "		<span>&nbsp;&nbsp;"+businessTreeList[i].deptName+"</span>";
									TreeViewTag += "		<ul>";
									TreeViewTag += "			<li class='clickAddName' data-jobid="+businessTreeList[i].jobtitleId+" data-currid="+businessTreeList[i].empId+">&nbsp;&nbsp;"+businessTreeList[i].empNm+"["+businessTreeList[i].jobtitle+"]</li>";
									TreeViewTag += "		</ul>";
									
									for(var j=0; j<businessTreeList.length; j++) {
										
										
										if(businessTreeList[j].upperDeptId == busiBu){
											var busiTeam = businessTreeList[j].deptId;
											
											
											console.log("busiTeam1 = ", busiTeam);
											
											TreeViewTag += "			<ul>";
											TreeViewTag += "				<li>";
											TreeViewTag += "					<span>&nbsp;&nbsp;"+businessTreeList[j].deptName+"</span>";
											TreeViewTag += "					<ul>";
											
											var teamCnt = 0;
											for(var k=0; k<businessTreeList.length; k++) {
												if(businessTreeList[k].deptId == busiTeam) {
													console.log("busiTeam2 = ", busiTeam);
													TreeViewTag += "				<li class='clickAddName' data-jobid="+businessTreeList[k].jobtitleId+" data-currid="+businessTreeList[k].empId+">&nbsp;&nbsp;"+businessTreeList[k].empNm+"["+businessTreeList[k].jobtitle+"]</li>";
													teamCnt++;
												}
											}
											j = (j-1)+teamCnt;
											TreeViewTag += "				</ul>";
											TreeViewTag += "			</li>";
											TreeViewTag += "		</ul>";
										}
									}
									TreeViewTag += "	</li>";
								}
							}
							TreeViewTag += "	</li>";
						}
						
					}
					$("#gray").append(TreeViewTag);
					$("#gray").treeview({collapsed: true});
				},
				error	: function(error){
					alert("error code : "+error.status);
				}
			});
			
			
			// 사원이 선택한 사원정보를 hidden 태그에 저장
			$("#gray").on("click", ".clickAddName", function(){
				$('.clickAddName').css({'color' : 'gray'});
				$(this).css({'color' : 'red'});
				$("#addEmpInfoId").val($(this).data('currid'));
				$("#addEmpInfoName").val($(this).text().split('[')[0]);
				$("#addEmpInfoDept").val($(this).parent().prev().text());
				$("#addEmpInfoJobtitle").val($(this).text().split('[')[1].split(']')[0]);
				$("#addEmpInfoJobId").val($(this).data('jobid'));
				
			});
			
			
			// add 버튼 클릭 액션
			$("#AddEmpBtn").on("click", function(){
				
				if($(".hiddenInfo").val() != ""){
					var addEmpTag = "";
					var addEmpInfoId = $("#addEmpInfoId").val()
					var addEmpInfoName = $("#addEmpInfoName").val()
					var addEmpInfoDept = $("#addEmpInfoDept").val()
					var addEmpInfoJobtitle = $("#addEmpInfoJobtitle").val()
					var addEmpInfoJobId = $("#addEmpInfoJobId").val()

					addEmpTag += "<tr class='addEmpInfotr' clicked=''>";
					addEmpTag += "<td class='addEmpInfoSpan dept'>"+addEmpInfoDept+"</td>";
					addEmpTag += "<td data-jobid="+addEmpInfoJobId+" class='addEmpInfoSpan jobtitle'>"+addEmpInfoJobtitle+"</td>";
					addEmpTag += "<td data-currid="+addEmpInfoId+" class='addEmpInfoSpan currname'>"+addEmpInfoName+"</td>";
					addEmpTag += "</tr>";
					$("#jojikdoSelectDiv table tbody").append(addEmpTag);
					$(".hiddenInfo").val("");
					$('.clickAddName').css({'color' : 'gray'});
				}else{
					alert("결재자를 선택해주세요.");
				}
				
			});
			
			
			isClicked = false;
			
			// remove 버튼 클릭 액션
			$("#addEmpInfotbody").on("click", "tr", function(){
				if($(this).attr('clicked') == ''){
					$(this).attr('clicked', 'clicked');
					$(this).css({'color' : 'red'});
				}else{
					$(this).attr('clicked', '');
					$(this).css({'color' : 'gray'});
				}
			});
			$("#RemoveEmpBtn").on("click", function(){
				$(".addEmpInfotr[clicked='clicked']").remove();
			});
			
			
			
			// 직급 정렬 버튼 클릭 액션
			$("#sortBtn").on("click", function(){
				
				var approveEmpList = $("#addEmpInfotbody .addEmpInfotr");
				console.log(approveEmpList);
				
				for(var i = 0; i< approveEmpList.length; i++){
					console.log($(approveEmpList[i]).find('td.jobtitle').data('jobid'));
				}
				
				// job title sorting
				for(var i=0; i<approveEmpList.length-1;){
					
					var tmpJobTitleId = $(approveEmpList[i]).find('.jobtitle').data('jobid');
					console.log("jobid : "+tmpJobTitleId);
					
					if(tmpJobTitleId > $(approveEmpList[i+1]).find('.jobtitle').data('jobid')){
						var temp = approveEmpList[i+1];
						approveEmpList[i+1] = approveEmpList[i];
						approveEmpList[i] = temp;
						i = 0;
					}else{
						i++;
					}
				}
				//정렬 후
				// refresh painting
				$("#addEmpInfotbody").empty();
				for(var i=0; i<approveEmpList.length; i++){
					$("#addEmpInfotbody").append(approveEmpList[i]);
				}
			});
			
			
			
			// 결재 라인 정보 부모 창에 넘기기
			/* $("#addAproveLineBtn").on("click", function(){
				if($("#jojikdoSelectDiv").text() != ""){
					var apprList = $("#jojikdoSelectDiv").text().split(".");
					var approveListInfo = [];
					for(var i=0; i<apprList.length-1; i++){
						approveListInfo.push(apprList[i]);
					}
					alert(approveListInfo);
				}else{
					alert("결재자를 추가해주세요");
				}
			}); */
			
		});
	
		
	</script>
<!-- 문서 양식 설정 화면  -->
		<div id="typeDiv">
			<h2>문서 양식 선택</h2>
			<hr>
			
			<div id="typeTable">
				<table>
					<c:set var="unit" value="5"/>
					<c:forEach begin="0" end="${reportTypeList.size()/unit }" var="i" step="1">
						<tr>
							<c:set var="endPoint" value="${i * unit + unit -1 }"/>
							<c:forEach begin="${i * unit }" end="${endPoint >= reportTypeList.size()-1 ? reportTypeList.size()-1 : endPoint }" step="1" var="j">
								<c:if test="${reportTypeList[j].typeNm == '휴가신청서'}">
									<td id="reportVacateInfoImgTd" data-typeid="${reportTypeList[j].typeId }">
										<label><i class="fas fa-check-circle" style="margin: 0px; float: left; position: relative; top : 30px; left: 15px; z-index:2; visibility: hidden;"></i><img class="typeIcon" alt="${reportTypeList[j].typeNm }" src="/images/${reportTypeList[j].typeId}.JPG"></label><br>
										<span>${reportTypeList[j].typeNm }</span>
									<td>
								</c:if>
								<c:if test="${reportTypeList[j].typeNm != '휴가신청서'}">
									<td data-typeid="${reportTypeList[j].typeId }">
										<label><i class="fas fa-check-circle" style="margin: 0px; float: left; position: relative; top : 30px; left: 15px; z-index:2; visibility: hidden;"></i><img class="typeIcon" alt="${reportTypeList[j].typeNm }" src="/images/${reportTypeList[j].typeId}.JPG"></label><br>
										<span>${reportTypeList[j].typeNm }</span>
									<td>
								</c:if>
							</c:forEach>
						</tr>				
					</c:forEach>
				</table>
			</div>
		</div>
		<!-- 결재선 설정 메뉴바  -->
		<div id="approvLineDiv">
			<h2>결재라인 설정</h2>
			<button class="settingViewBtn btn btn-secondary" type="button" id="btnScrollUp" style="float : right;">양식 재설정</button>
			<br>
			<hr>
			
			<div style="text-align: left; margin-left: 20px;">
					결재라인명 :&nbsp;
					<input type="text" id="approvLineName" name="apprKind" value="${approvLine[0].apprKind }" readonly>
					<!-- Button trigger modal -->
					<button class="settingViewBtn btn btn-secondary" type="button" id="saveApprovLine" data-toggle="modal" data-target="#saveApprovLineModal">
					  저장
					</button>
					<button class="settingViewBtn btn btn-secondary" type="button" id="loadApprovLineList" data-toggle="modal" data-target="#loadApprovLineModal">
					  불러오기
					</button>
			</div>
			<br>
			<!-- 결재선 결과 화면  -->
			<div style="text-align: center;">
				<div style="margin-right : 20px; width : 50%; height : 434px; display: inline-block; float: left;">
					<h3 style="text-align: left;">결과</h3>
					<div class="menubar" style="margin-right : 90px; float : right;">
						<button class="settingViewBtn btn" type="button" id="upApprovLine"><i class="fas fa-sort-up"></i></button>
						<button class="settingViewBtn btn" type="button" id="downApprovLine"><i class="fas fa-sort-down"></i></button>
						<button class="settingViewBtn btn" type="button" id="deleteApprover"><i class="fas fa-times"></i></button>
						<button class="settingViewBtn btn" type="button" id="listEmpty"><i class="fas fa-trash-alt"></i></button>
					</div>
						
					<br>
					<table id="approvLinetable" border="1" style="margin-top: 20px;">
						<thead>
							<tr>
								<th>전체 선택/<a href="javascript:deselect()">해제</a>
								&nbsp;<input type="checkbox" id="checkAll" ></th>
								<th>순서</th>
								<th>부서명</th>
								<th>직급</th>
								<th>결재자</th>
							</tr>
						</thead>
						<tbody id="approvLineResult">
							
							<c:if test="${approvLine == null }">
								<tr><td colspan="5">결재라인을 추가해주세요</td></tr>
							</c:if>
							
							<c:forEach items="${approvLine }" var="apprLine">
								<tr class="approvTr">
									<td><input type="checkbox" class="apprLineCheck"></td>
									<td class="step">${apprLine.apprStep }</td>
									<td class="dept">${apprLine.currDeptNm }</td>
									<td class="jobtitle">${apprLine.currJobNm }</td>
									<td class="currEmpId" data-currid="${apprLine.apprCurrEmp}">${apprLine.currEmpNm }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div style="width : 40%; float: left">
					<h3 style="text-align : left;">결재선 추가</h3>
					<table style="margin-top: 15px;">
						<tr><td>
					<!-- 조직도 이용 결재선 추가 화면  -->
						<div id="main">
							<input type="hidden" class="hiddenInfo" id="addEmpInfoName" />
							<input type="hidden" class="hiddenInfo" id="addEmpInfoDept" />
							<input type="hidden" class="hiddenInfo" id="addEmpInfoId" />
							<input type="hidden" class="hiddenInfo" id="addEmpInfoJobtitle" />
							<input type="hidden" class="hiddenInfo" id="addEmpInfoJobId" />
							<div id="OrganChartDiv" style="float: right;">
							
							
								<!-- 조직도 div -->
								<div id="jojikdo">
									<!-- 조직도 전체 -->
									<ul id="gray" class="treeview-gray">
									</ul>
								</div>
								
								
								<!-- selected empList div -->
								<div id="jojikdoSelectDiv">
									<table>
										<thead>
											<tr class="addEmpInfotr" style="border-bottom : 5px double gray;">
											<th>부서</th>
											<th>직급</th>
											<th>이름</th>									
											</tr>
										</thead>
										<tbody id="addEmpInfotbody">
										</tbody>
									</table>
								</div>
								
								<!-- select button div -->
								<div id="selectButtonDiv" style="margin-right : 10px;">
									<div style="margin-top: 50%;">
										<button type="button" class="btn btn-secondary" id="AddEmpBtn" >추가</button>
										<button type="button" class="btn btn-secondary" id="RemoveEmpBtn" >삭제</button>
										<button type="button" class="btn btn-secondary" id="sortBtn" >정렬</button>									
									</div>
								</div>
								
								<!-- <input type="button" id="addAproveLineBtn" value="결재라인등록" /> -->
								<button class="btn btn-secondary" type="button" id="writeBtn" style="float: right;">문서 작성</button>
								<button class="settingViewBtn btn btn-warning" type="button" id="addApprover" style="float: right; margin-right: 10px;">결재자 추가</button>
							</div>
						</div>
						</td></tr>
					</table>
				</div>
			</div>
			
		
		
			<!-- 결재라인 저장 Modal -->
			<div class="modal fade" id="saveApprovLineModal" tabindex="-1" role="dialog" aria-labelledby="saveApprovLineTitle" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title" id="saveApprovLineTitle">결재라인 저장</h5>
			        <button type="button" class="settingViewBtn close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true"><i class="fas fa-times"></i></span>
			        </button>
			      </div>
			      <div class="modal-body" style="vertical-align: middle;">
			        	 새 이름 설정 : <input type="text" id="newName" value="">
			      </div>
			      <div class="modal-footer">
			        <button type="button" id="btnSave" class="settingViewBtn btn btn-primary">저장</button>
			        <button type="button" id="btnCancel" class="settingViewBtn btn btn-secondary" data-dismiss="modal">취소</button>
			      </div>
			    </div>
			  </div>
			</div>
		
			<!-- 결재라인 불러오기 Modal -->
			<div class="modal fade bd-example-modal-lg" id="loadApprovLineModal" tabindex="-1" role="dialog" aria-labelledby="loadApprovLineTitle" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title" id="loadApprovLineTitle">결재라인 불러오기</h5>
			        <button type="button" class="settingViewBtn close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true"><i class="fas fa-times"></i></span>
			        </button>
			      </div>
			      <div class="modal-body loadApprDiv" style="overflow : auto;">
			      	<form:form id="approvLineForm" commandName="approvLineVo" action="/report/settingView" method="post" >
		      			<input type="hidden" class="empId"  name="empId" value="${EMP.empId}">
		      			<input type="hidden" class="typeId" name="typeId" value="${approvLineVo.typeId }">
		      			<input type="hidden" class="apprLineInfoSel" name="apprLineInfoSel" value="selected">
		      			<div id="approvLineTemplate">
		      				
		      			</div>
		      		</form:form>
			      </div>
			      <div class="modal-footer">
			        <button type="button" id="btnLoad" class="settingViewBtn btn btn-primary">불러오기</button>
			        <button type="button" id="btncancle" class="settingViewBtn btn btn-secondary btnCancel" data-dismiss="modal">취소</button>
			      </div>
			    </div>
			  </div>
			</div>
			
			<!-- 문서 작성   -->
			<form id="writeReportForm" action="/report/insertReportView" method="post">
				<input type="hidden" class="empId"  name="empId" value="${EMP.empId}">
		      	<input type="hidden" class="typeId" name="typeId" value="${approvLineVo.typeId }">
		      	<input type="hidden" class="apprKind" name="apprKind" value="${approvLineVo.apprKind }">
      			<input type="hidden" name="uploadtoken" value="uploadchecking">
			</form>
			
			
			
					
		</div>
