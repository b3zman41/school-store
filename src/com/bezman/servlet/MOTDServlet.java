package com.bezman.servlet;

import com.bezman.com.bezman.reference.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by Terence on 11/11/2014.
 */
@Controller
@RequestMapping
public class MOTDServlet {

    @RequestMapping(value = "/motd", method = RequestMethod.GET)
    @ResponseBody
    public String changeMOTD(Model model, @RequestParam("message") String message){
        Reference.motd = message;
        System.out.println(message);

        return "";
    }



}
