package com.bitwin.bangbang.admin.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bitwin.bangbang.admin.domain.BoardEdit;
import com.bitwin.bangbang.admin.domain.BoardReg;
import com.bitwin.bangbang.admin.service.BoardService;
import com.bitwin.bangbang.admin.service.ItemService;

@Controller
@RequestMapping("/admin/board/*")
public class AdminBoardController {

	@Autowired
	private BoardService boardService;
	
	@Autowired
	private ItemService itemService;
	 
	@RequestMapping(value = "write", method = RequestMethod.GET)
	public String write(@RequestParam int iidx, Model model) {
		model.addAttribute("item", itemService.read(iidx));
		return "board/write";
	}

	@RequestMapping(value = "insert", method = RequestMethod.POST)
	public String insert(BoardReg reg, Model model, HttpServletRequest request) throws IllegalStateException, IOException {
		model.addAttribute("board", boardService.create(reg, request));
		return "redirect:/board/list";
	}

	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String form(@RequestParam("iidx") int iidx, Model model) {
		model.addAttribute("board", boardService.read(iidx));
		System.out.println(boardService.read(iidx));
		model.addAttribute("item", itemService.read(iidx));
		return "board/update";
	}

	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(BoardEdit edit, HttpServletRequest request) throws IllegalStateException, IOException {
		System.out.println(edit);
		boardService.update(edit, request);
		return "redirect:list";
	}

	@RequestMapping(value = "delete")
	public String delete(@RequestParam int iidx) {
		boardService.delete(iidx);
		return "redirect:/board/list";
	}
	
}
