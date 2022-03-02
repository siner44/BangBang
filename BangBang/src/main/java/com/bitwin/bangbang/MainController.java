package com.bitwin.bangbang;



import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bitwin.bangbang.admin.domain.SearchParams;
import com.bitwin.bangbang.admin.service.BoardService;
import com.bitwin.bangbang.member.domain.KakaoInfo;
import com.bitwin.bangbang.member.domain.NaverInfo;

import lombok.AllArgsConstructor;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/main/*")
@AllArgsConstructor
public class MainController {
	
	@Autowired
	BoardService boardService;
	
	@GetMapping("/mainpage")
	public void mainpage(Model model, SearchParams params) throws SQLException {
		KakaoInfo kakao = new KakaoInfo();
		NaverInfo naver = new NaverInfo();
		model.addAttribute("kakao", kakao);
		model.addAttribute("naver", naver);
		model.addAttribute("board", boardService.getPageView(params));
	}
	
}
