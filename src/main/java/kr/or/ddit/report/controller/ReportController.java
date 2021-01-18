package kr.or.ddit.report.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndViewDefiningException;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.or.ddit.business.busiboard.vo.BusiFileVO;
import kr.or.ddit.comm.util.FileUtils;
import kr.or.ddit.comm.vo.FileVO;
import kr.or.ddit.comm.vo.PaginationVO;
import kr.or.ddit.emp.vo.EmpVO;
import kr.or.ddit.emp.vo.LeftItemVO;
import kr.or.ddit.report.dao.ReportMapperDao;
import kr.or.ddit.report.service.ReportService;
import kr.or.ddit.report.util.ApprovLineListVOValidator;
import kr.or.ddit.report.util.ReportVOValidator;
import kr.or.ddit.report.vo.ApprovLineCounterVO;
import kr.or.ddit.report.vo.ApprovLineListVO;
import kr.or.ddit.report.vo.ApprovLineVO;
import kr.or.ddit.report.vo.ApprovalVO;
import kr.or.ddit.report.vo.ReportFileVO;
import kr.or.ddit.report.vo.ReportTypeVO;
import kr.or.ddit.report.vo.ReportVO;
import kr.or.ddit.report.vo.SubWorkerVO;

@Controller
public class ReportController {
	
	@Resource(name="reportService")
	ReportService reportService;
	
	private static final Logger logger = LoggerFactory.getLogger(ReportController.class);
	
	
	@RequestMapping("/report/settingView")
	public String insertReportView(ApprovLineVO approvLineVo, Model model, HttpSession session,
									@RequestParam(name = "apprLineInfoSel", required = false) String apprLineInfoSel) {
		EmpVO emp = (EmpVO) session.getAttribute("EMP");
		approvLineVo.setEmpId(emp.getEmpId());
		/* 기안문 작성화면(양식선택 화면)으로 포워딩, 양식 리스트 및 조직도 데이터를 갖고 가야함. */
		logger.debug("approvLineVo 정보 좀 보자 : {}", approvLineVo);
		try {
			List<ReportTypeVO> reportTypeList = reportService.selectReportTypeList();
			List<ApprovLineVO> approvLine = null;
			if(approvLineVo.getApprKind() != null && !"".equals(approvLineVo.getApprKind())) {
				approvLine = reportService.selectApprovLine(approvLineVo);
			}
			model.addAttribute("reportTypeList", reportTypeList);
			model.addAttribute("approvLineVo", approvLineVo);
			model.addAttribute("approvLine", approvLine);
			model.addAttribute("reportVacatePath", approvLineVo.getReportVacatePath());
			approvLineVo.setReportVacatePath("");
			if(apprLineInfoSel != null && !apprLineInfoSel.equals("")) {
				model.addAttribute("apprLineInfoSel", apprLineInfoSel);
				apprLineInfoSel = "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		session.setAttribute("menuLocation", "makeReport");
		session.setAttribute("openLeftId", "collapseUtilities");
		model.addAttribute("leftItemVo", new LeftItemVO());
		
		
		session.setAttribute("uploadtoken", "uploadchecking");
		return "tiles/report/settingView";
	}
	
	@RequestMapping("/report/loadApprovLine")
	public String loadApprovLine(ApprovLineVO approvLineVo, Model model) {
		logger.debug("loadApprovLine 정보 : {}", approvLineVo);
		List<ApprovLineVO> approvLineList = null;
		List<ApprovLineCounterVO> apprLineCounterList = null;
		try {
			approvLineList = reportService.selectApprovLineList(approvLineVo.getEmpId());
			apprLineCounterList = reportService.selectApprLineCounterList(approvLineVo.getEmpId());
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("approvLineList", approvLineList);
		model.addAttribute("apprLineCounterList", apprLineCounterList);
		model.addAttribute("approvLineVo", approvLineVo);
		
		return "/report/loadApprovLineList";
		
		
	}
	
	@RequestMapping("/report/saveApprovLine")
	public String saveApprovLine(ApprovLineListVO approvLineListVo, Model model, HttpSession session) {
		logger.debug("approvLineListVo 정보 : {}", approvLineListVo);
		/*db 작업 필요 (insert approvLineVO)*/
		
		if(approvLineListVo.getApprovLineList() == null) {
			model.addAttribute("error", "결재라인을 선택해주세요");
			return "jsonView";
		}
		
		
		String result = "등록 실패!!";
		
		if(approvLineListVo.getApprKind() == null 
				|| "".equals(approvLineListVo.getApprKind()) ) {
			String random = UUID.randomUUID().toString();
			approvLineListVo.setApprKind(random);
			/*for(ApprovLineVO approvLine : approvLineListVo.getApprovLineList()) {
				approvLine.setApprKind(random);
			}	*/
		}else {
			//사원이 등록한 결재선 종류가 무엇인지 가져오는 메서드 
			List<ApprovLineCounterVO> approvLineConter = 
					reportService.selectApprLineCounterList(approvLineListVo.getEmpId());
			//이미 등록된 결재선 이름인지 체크
			for (ApprovLineCounterVO approvLineCounterVO : approvLineConter) {
				if(approvLineCounterVO.getApprKind().equals(approvLineListVo.getApprKind())) {
					result += " : 이름이 중복됩니다..";
					model.addAttribute("message", result);
					return "jsonView";
				}
			}
		}
		
		//중복 아닐 시..
		String apprKind = reportService.insertApprovLine(approvLineListVo);
		model.addAttribute("apprKind", apprKind);
		
		result = apprKind+ " 등록 성공!!";
		
		model.addAttribute("message", result);
		model.addAttribute("apprStCode", approvLineListVo.getApprStCode());
		return "jsonView";
	}
	
	
	@RequestMapping(path="/report/insertReportView", method= {RequestMethod.POST})
	public String insertReportView(ReportVO reportVo, Model model, HttpSession session) {
		/* 문서 설정 정보를 받아 기안문서 데이터를 하나 만들고 해당 데이터의 pk(기안번호)를 select key로 받아옴.*/
		logger.debug("insertReportView -- reportVo 정보 : {}", reportVo);
		logger.debug("reportVo.apprKind : {}",reportVo.getApprKind());
		
		ReportVO report = reportService.insertReport(reportVo, session);

		
		// 결재라인 정보 가져오기
		EmpVO loginEmp = (EmpVO) session.getAttribute("EMP");
		ApprovLineVO tempApprovLineVo = new ApprovLineVO();
		tempApprovLineVo.setApprKind(report.getApprKind());
		tempApprovLineVo.setEmpId(loginEmp.getEmpId());
		List<ApprovLineVO> tempApprovLineList = reportService.selectApprovLineInfo(tempApprovLineVo);
		List<String> apprCurrNextEmpList = null;
		if(tempApprovLineList != null && tempApprovLineList.size() > 0) {
			apprCurrNextEmpList = new ArrayList<String>();
			for(int i=0; i<tempApprovLineList.size(); i++) {
				String apprCurrEmpId = tempApprovLineList.get(i).getApprCurrEmp();
				String apprNextEmpId = tempApprovLineList.get(i).getApprNextEmp();
				apprCurrNextEmpList.add(apprCurrEmpId+":~:"+apprNextEmpId);
			}
		}
		logger.debug("결재라인 정보 : {}", apprCurrNextEmpList);
		model.addAttribute("apprCurrNextEmpList", apprCurrNextEmpList);
		
		
		
		
		
		model.addAttribute("reportVo", report);
		session.removeAttribute("uploadtoken");
		return "tiles/report/insertReport";
	}
	
//	기안서 등록
	@RequestMapping(path="/report/insertReport", method= {RequestMethod.POST})
	public String insertReport(ReportVO reportVo, BindingResult bindingResult, Model model, HttpSession session) {
		/* 기안문 작성 정보를 입력받아 db에 저장.*/
		
		logger.debug("insertReport -- reportVo 정보 : {}", reportVo);
		logger.debug("insertReport -- content 정보 : {}", reportVo.getContent());
		
		new ReportVOValidator().validate(reportVo, bindingResult);

		if(bindingResult.hasErrors()) {
			ReportVO report = reportService.insertReport(reportVo, session);
			model.addAttribute("reportVo", report);
			model.addAttribute(BindingResult.class.getName()+".reportVo", bindingResult);
			logger.debug("bindingResult : {}", bindingResult);
			
			
			
			// 결재라인 정보 가져오기
			EmpVO loginEmp = (EmpVO) session.getAttribute("EMP");
			ApprovLineVO tempApprovLineVo = new ApprovLineVO();
			tempApprovLineVo.setApprKind(report.getApprKind());
			tempApprovLineVo.setEmpId(loginEmp.getEmpId());
			List<ApprovLineVO> tempApprovLineList = reportService.selectApprovLineInfo(tempApprovLineVo);
			List<String> apprCurrNextEmpList = null;
			if(tempApprovLineList != null && tempApprovLineList.size() > 0) {
				apprCurrNextEmpList = new ArrayList<String>();
				for(int i=0; i<tempApprovLineList.size(); i++) {
					String apprCurrEmpId = tempApprovLineList.get(i).getApprCurrEmp();
					String apprNextEmpId = tempApprovLineList.get(i).getApprNextEmp();
					apprCurrNextEmpList.add(apprCurrEmpId+":~:"+apprNextEmpId);
				}
			}
			logger.debug("결재라인 정보 : {}", apprCurrNextEmpList);
			model.addAttribute("apprCurrNextEmpList", apprCurrNextEmpList);
			
			
			
			return "tiles/report/insertReport";
		}
		
		
		logger.debug("processing success : {}", "**processing completed");

		reportService.insertReportComponent(reportVo);
		
		/*if(reportVo.getUploadtoken().equals(uploadtoken)) {
			logger.debug("insertReportComponent");
		}
		if("success".equals(result)) {
			logger.debug("insertReportComponent -- success");
			session.removeAttribute("uploadtoken");
		}
		if("fail".equals(result)) {
			logger.debug("insertReportComponent -- fail");
			return "tiles/report/insertReport";
		}*/
		
		session.setAttribute("menuLocation", "reportWait");
		
		return "redirect:/reportWait";
	}
	
	//기안서 조회
	@RequestMapping(path="/report/reportView", method=RequestMethod.POST)
	public String selectReport(ReportVO reportVo, Model model, HttpSession session) {
		EmpVO emp = (EmpVO) session.getAttribute("EMP");
		reportVo.setEmpId(emp.getEmpId());
		ReportVO report = reportService.selectReport(reportVo);
		report.setPageUnit(reportVo.getPageUnit());
		report.setPageIndex(reportVo.getPageIndex());
		report.setSearchCondition(reportVo.getSearchCondition());
		report.setSearchKeyword(reportVo.getSearchKeyword());
		
		// 결재라인 정보 가져오기
		ApprovLineVO tempApprovLineVo = new ApprovLineVO();
		tempApprovLineVo.setApprKind(report.getApprKind());
		tempApprovLineVo.setEmpId(report.getEmpId());
		List<ApprovLineVO> tempApprovLineList = reportService.selectApprovLineInfo(tempApprovLineVo);
		List<String> apprCurrNextEmpList = null;
		if(tempApprovLineList != null && tempApprovLineList.size() > 0) {
			apprCurrNextEmpList = new ArrayList<String>();
			for(int i=0; i<tempApprovLineList.size(); i++) {
				String apprCurrEmpId = tempApprovLineList.get(i).getApprCurrEmp();
				String apprNextEmpId = tempApprovLineList.get(i).getApprNextEmp();
				apprCurrNextEmpList.add(apprCurrEmpId+":~:"+apprNextEmpId);
			}
		}
		model.addAttribute("apprCurrNextEmpList", apprCurrNextEmpList);
		
		model.addAttribute("reportVo", report);
		session.setAttribute("uploadtoken", "uploadchecking");
		return "tiles/report/reportView";
	}
	
	
	@RequestMapping("/reportWait")
	public String reportView(Model model,ReportVO reportVo, HttpSession session) {
		
		EmpVO empVO = (EmpVO) session.getAttribute("EMP");
		logger.debug("empVO.getEmpId() : {}" , empVO.getEmpId());
		reportVo.setEmpId(empVO.getEmpId());
		reportVo.setReportSt("W");
		reportVo.setPageSize(5);
		
		int cnt = 1;
		List<ReportVO> reportList = null;
		try {
			reportList = reportService.getRepostList(reportVo);
			cnt = reportService.selectReportTotCnt(reportVo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		PaginationVO pagination = new PaginationVO(reportVo.getPageIndex(),
				reportVo.getRecordCountPerPage(), reportVo.getPageSize(), cnt);
		
		model.addAttribute("pagination", pagination);
		model.addAttribute("reportList",reportList);
		
		return "tiles/report/reportWait";
	}
	
	@RequestMapping("/reporting")
	public String reportingView(Model model,ReportVO reportVo, HttpSession session) {
		
		EmpVO empVO = (EmpVO) session.getAttribute("EMP");
		logger.debug("empVO.getEmpId() : {}" , empVO.getEmpId());
		reportVo.setEmpId(empVO.getEmpId());
		reportVo.setReportSt("ing");
		reportVo.setPageSize(5);
		reportVo.setRecordCountPerPage(5);
		
		int cnt = 1;
		List<ReportVO> reportList = null;
		try {
			reportList = reportService.getRepostList(reportVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		PaginationVO pagination = new PaginationVO(reportVo.getPageIndex(),
				reportVo.getRecordCountPerPage(), reportVo.getPageSize(), cnt);
		
		model.addAttribute("pagination", pagination);
		model.addAttribute("reportList",reportList);
		if("ajax".equals(reportVo.getUploadtoken())) {
			model.addAttribute("url", "reporting");
			session.setAttribute("menuLocation", "reporting");
			return "/main/mainpopup";
		}
		return "tiles/report/reporting";
	}
	
	@RequestMapping("/reportSuccess")
	public String reportSuccessView(Model model,ReportVO reportVo, HttpSession session) {
		
		EmpVO empVO = (EmpVO) session.getAttribute("EMP");
		logger.debug("empVO.getEmpId() : {}" , empVO.getEmpId());
		reportVo.setEmpId(empVO.getEmpId());
		reportVo.setReportSt("Y");
		reportVo.setPageSize(5);
		
		List<ReportVO> reportList = null;
		int cnt = 1;
		try {
			reportList = reportService.getRepostList(reportVo);
			cnt = reportService.selectReportTotCnt(reportVo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		PaginationVO pagination = new PaginationVO(reportVo.getPageIndex(),
				reportVo.getRecordCountPerPage(), reportVo.getPageSize(), cnt);
		
		model.addAttribute("pagination", pagination);
		model.addAttribute("reportList",reportList);
		
		return "tiles/report/reportSuccess";
	}
	
	
	@RequestMapping("/reportFail")
	public String reportFailView(Model model,ReportVO reportVo, HttpSession session) {
		
		EmpVO empVO = (EmpVO) session.getAttribute("EMP");
		logger.debug("empVO.getEmpId() : {}" , empVO.getEmpId());
		reportVo.setEmpId(empVO.getEmpId());
		reportVo.setReportSt("N");
		reportVo.setPageSize(5);
		
		int cnt = 1;
		List<ReportVO> reportList = null;
		try {
			reportList = reportService.getRepostList(reportVo);
			cnt = reportService.selectReportTotCnt(reportVo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		PaginationVO pagination = new PaginationVO(reportVo.getPageIndex(),
				reportVo.getRecordCountPerPage(), reportVo.getPageSize(), cnt);
		
		model.addAttribute("pagination", pagination);
		model.addAttribute("reportList",reportList);
		
		return "tiles/report/reportFail"; 
	}
	
	@RequestMapping("/report/approvListView")
	public String approvListView(ReportVO reportVo, Model model, HttpSession session) {
		reportVo.setEmpId("");
		EmpVO empVO = (EmpVO) session.getAttribute("EMP");
		SubWorkerVO subWorker = (SubWorkerVO) session.getAttribute("subWorker");

		logger.debug("empVO.getEmpId() : {}" , empVO.getEmpId());
		reportVo.setApprover((empVO.getEmpId())); //현 접속자가 결재자인 경우
		
		//대리 결재자가 대리 결재 목록을 요청하는 경우
		if(reportVo.getSubEmpId() != null && !"".equals(reportVo.getSubEmpId())) {
			reportVo.setApprover(subWorker.getEmpId());
		}
		
		PaginationVO paginationInfo = new PaginationVO();
		paginationInfo.setCurrentPageNo(reportVo.getPageIndex());
		paginationInfo.setRecordCountPerPage(reportVo.getPageUnit());
		paginationInfo.setPageSize(reportVo.getPageSize());
		
		reportVo.setFirstIndex(paginationInfo.getFirstRecordIndex());
		reportVo.setLastIndex(paginationInfo.getLastRecordIndex());
		reportVo.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
		List<ReportVO> reportList = null;
		int totCnt = 1;
		try {
			reportList = reportService.selectReportList(reportVo);
			totCnt = reportService.selectReportTotCnt(reportVo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("pagination", paginationInfo);
		model.addAttribute("reportList",reportList);
		model.addAttribute("reportVo", reportVo);
		
		if("ajax".equals(reportVo.getUploadtoken())) {
			model.addAttribute("url", "approvListView");
			session.setAttribute("menuLocation", "approvWait");
			return "/main/mainpopup";
		}
		
		
		return "tiles/report/approvalWait";
	}
	
	@RequestMapping("/report/approve")
	public String apporve(ApprovalVO approvalVo, Model model) {
		if("W".equals(approvalVo.getReportSt()) || "ing".equals(approvalVo.getReportSt())) {
			reportService.insertApproval(approvalVo);
		}
		
		return "redirect:/report/approvListView?approver="+approvalVo.getEmpId();
	
		
	}
	
	@RequestMapping("/report/approvFinListView")
	public String approvFinListView(ReportVO reportVo, Model model, HttpSession session) {
		/*결재자 아이디를 통해서 기안문서 정보 및 결재 정보를 가져오는 로직*/
		EmpVO emp = (EmpVO) session.getAttribute("EMP");
		SubWorkerVO subWorker = (SubWorkerVO) session.getAttribute("subWorker");
		if(subWorker != null) {
			reportVo.setSubEmpId(subWorker.getSubEmpId());
		}
		reportVo.setEmpId(emp.getEmpId());		//현 접속자가 결재자인데 결재는 끝난경우
		
		/*if(reportVo.getSubEmpId() != null && !"".equals(reportVo.getSubEmpId())) {
			reportVo.setEmpId(subWorker.getEmpId());
		}*/
		logger.debug("**reportVo** : {}", reportVo);
		
		/** pageing setting */
		PaginationVO paginationInfo = new PaginationVO();
		paginationInfo.setCurrentPageNo(reportVo.getPageIndex());
		paginationInfo.setRecordCountPerPage(reportVo.getPageUnit());
		paginationInfo.setPageSize(reportVo.getPageSize());
		
		reportVo.setFirstIndex(paginationInfo.getFirstRecordIndex());
		reportVo.setLastIndex(paginationInfo.getLastRecordIndex());
		reportVo.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<ReportVO> reportList = reportService.selectReportList(reportVo);
		
		for(ReportVO report : reportList) {
			logger.debug("**reportVo.title : {}", report.getTitle());
		}
		
		
		model.addAttribute("reportList", reportList);
		
		ApprovalVO approvalVo = new ApprovalVO();
		approvalVo.setEmpId(reportVo.getEmpId());
		approvalVo.setSearchCondition(reportVo.getSearchCondition());
		approvalVo.setSearchKeyword(reportVo.getSearchKeyword());
		
		int totCnt = reportService.selectApprovalTotCnt(approvalVo);
		paginationInfo.setTotalRecordCount(totCnt);
		
		logger.debug("**paginationInfo** : {}", paginationInfo);
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("reportVo", reportVo);
		
		return "tiles/report/approvalFinList";
	}
	
	
	
	
	@RequestMapping("/report/reportFileDownload")
	public String reportFileDownload(ReportFileVO reportFileVo, Model model) {
		ReportFileVO reportFile = null;
		try {
			reportFile = reportService.selectReportFile(reportFileVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("reportFile", reportFile);
		return "reportFileDownloadView";
	}
}
