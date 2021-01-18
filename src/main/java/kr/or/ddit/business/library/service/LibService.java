package kr.or.ddit.business.library.service;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.or.ddit.business.library.dao.LibMapperDao;
import kr.or.ddit.business.library.vo.LibEmpVO;
import kr.or.ddit.business.library.vo.LibVO;

@Service("libService")
public class LibService{
	
	@Resource(name="libMapperDao")
	private LibMapperDao libMapperDao;
	
	// 조회
	public List<LibVO> libList(LibVO libVO) throws Exception{
		return libMapperDao.libList(libVO);
	}
	public List<LibEmpVO> libSelect(LibEmpVO libEmpVO) throws Exception{
		return libMapperDao.libSelect(libEmpVO);
	}
	public LibVO fileSelect(LibVO libVO) throws Exception{
		return libMapperDao.fileSelect(libVO);
	}
	public List<LibVO> folderSearch(LibVO libVO) throws Exception{
		return libMapperDao.folderSearch(libVO);
	}
	public List<LibVO> folderList(LibVO libVO) throws Exception{
		return libMapperDao.folderList(libVO);
	}
	public String libFileSize(LibVO libVO) throws Exception{
		return libMapperDao.libFileSize(libVO);
	}
	public List<LibVO> libFileList(LibVO libVO) throws Exception{
		return libMapperDao.libFileList(libVO);
	}
	
	// 등록
	public int fileUpload(LibVO libVO) throws Exception{
		return libMapperDao.fileUpload(libVO);
	}
	public int folderUpload(LibVO libVO) throws Exception{
		File newfile = new File("d:\\sendbox\\"+libVO.getFileRealNm()+"\\");
//		if (newfile.mkdir()) {
//			System.out.println("디렉토리 생성 성공");
//		} else {
//			System.out.println("디렉토리 생성 실패");
//		}
		return libMapperDao.folderUpload(libVO);
	}
	
	
	// 삭제
	public int deleteFile(LibVO libVO) throws Exception{
		return libMapperDao.deleteFile(libVO);
	}
	
	// 변경
	public int fileChange(LibVO libVO) throws Exception{
		return libMapperDao.fileChange(libVO);
	}
	
	public List<LibVO> fileSearchList(LibVO libVO) throws Exception{
		return libMapperDao.fileSearchList(libVO);
	}
	
}
