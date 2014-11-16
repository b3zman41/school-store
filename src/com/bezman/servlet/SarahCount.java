package com.bezman.servlet;

import com.bezman.com.bezman.reference.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by Terence on 11/9/2014.
 */
@Controller
@RequestMapping
public class SarahCount {

    @RequestMapping(value = "/sarahcount", method = RequestMethod.GET)
    public String getCounter(Model model){
        model.addAttribute("count", Reference.randomCounter);
        return "sarahcount.jsp";
    }

}
