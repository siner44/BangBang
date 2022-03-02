package com.bitwin.bangbang.member.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bitwin.bangbang.admin.domain.Review;
import com.bitwin.bangbang.admin.domain.ReviewList;
import com.bitwin.bangbang.admin.domain.SearchParams;
import com.bitwin.bangbang.admin.service.BoardService;
import com.bitwin.bangbang.admin.service.ItemService;
import com.bitwin.bangbang.admin.service.ReviewService;
import com.bitwin.bangbang.admin.service.WishService;
import com.bitwin.bangbang.member.domain.LoginInfo;
import com.bitwin.bangbang.member.service.MemberEditService;

@Controller
@RequestMapping("/board/*")
public class BoardController {

	@Autowired
	private BoardService boardService;

	@Autowired
	private ItemService itemService;

	@Autowired
	private ReviewService reviewService;

	@Autowired
	private WishService wishService;
	
	@Autowired
	private MemberEditService editService;

	@RequestMapping("list")
	public String getListPage(SearchParams params, Model model) throws SQLException {
		model.addAttribute("board", boardService.getPageView(params));
		return "board/list";
	}

	@RequestMapping("list-type")
	public void getListPage(SearchParams params, Model model, @RequestParam("type") String type) throws SQLException {
		params.setKeyword(type);
		model.addAttribute("board", boardService.getCateView(params));
	}

	@RequestMapping("detail")
	public void getPage(@RequestParam("iidx") int iidx, Model model) {
		boardService.hits(iidx);
		model.addAttribute("item", itemService.read(iidx));
		model.addAttribute("board", boardService.read(iidx));
	}

	@ResponseBody
	@RequestMapping(value = "/detail/review-list", method = RequestMethod.GET)
	public List<ReviewList> getReviewList(@RequestParam("iidx") int iidx) {
		List<ReviewList> review = reviewService.read(iidx);
		return review;
	}

	@ResponseBody
	@RequestMapping(value = "/detail/review-reg", method = RequestMethod.POST)
	public void write(Review review, Model model, HttpSession session) throws Exception {
		System.out.println(review);
		LoginInfo loginInfo = (LoginInfo) session.getAttribute("loginInfo");
		review.setUidx(loginInfo.getUidx());
//		model.addAttribute("member", editService.getMember(uidx));
		
		reviewService.create(review);
	}

	@ResponseBody
	@RequestMapping(value = "/detail/review-del", method = RequestMethod.POST)
	public int deleteReview(Review review, HttpSession session) throws Exception {
		int result = 0;
		
		LoginInfo loginInfo = (LoginInfo) session.getAttribute("loginInfo");
		int uidx = reviewService.reviewUidCheck(review.getRidx());

		if (loginInfo.getUidx() == uidx) {
			review.setUidx(loginInfo.getUidx());
			reviewService.delete(review);

			result = 1;
		}

		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/detail/review-up", method = RequestMethod.POST)
	public int updateReview(Review review, HttpSession session) throws Exception {
		int result = 0;
		
		LoginInfo loginInfo = (LoginInfo) session.getAttribute("loginInfo");
		int uidx = reviewService.reviewUidCheck(review.getRidx());

		if (loginInfo.getUidx() == uidx) {
			review.setUidx(loginInfo.getUidx());
			reviewService.update(review);
			result = 1;
		}

		return result;
	}

	@RequestMapping(value = "/detail/wishcheck", method = RequestMethod.POST)
	public void wishCheck(@RequestParam("iidx") int iidx, HttpSession session) {
		LoginInfo loginInfo = (LoginInfo) session.getAttribute("loginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iidx", iidx);
		map.put("uidx", loginInfo.getUidx());

		wishService.wishUpdate(map);
	}

	@RequestMapping(value = "/detail/wishcount", method = RequestMethod.POST)
	public void wishCount(@RequestParam("iidx") int iidx) {
		wishService.wishCnt(iidx);
	}

}
