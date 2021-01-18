package kr.or.ddit.businessTree.controller;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.businessTree.service.BusinessTreeService;
import kr.or.ddit.businessTree.vo.BusinessTreeVO;


@Controller
public class BusinessTreeController {

	private static final Logger logger = LoggerFactory.getLogger(BusinessTreeController.class);
	
	@Resource(name = "businessTreeService")
	private BusinessTreeService businessTreeService;
	
	
	
	
	
	@RequestMapping("/busiTree/busiTreeEmpView")
	public String busiTreeEmpView() {
		return "busiTreeChart/businessTreeEmp";
	}
	
	
	
	
	@RequestMapping("/busiTree/businessTreeEmpDept")
	public String organChartReport(BusinessTreeVO busiTree, Model model) {
		List<BusinessTreeVO> businessTreeList = null;
		try {
			businessTreeList = businessTreeService.selectBusinessTreeList(busiTree);
			if(businessTreeList != null) {
				model.addAttribute("businessTreeList", businessTreeList);
				
				logger.debug("businessTreeList : {}", businessTreeList);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "jsonView";
	}
	
	
	
}
