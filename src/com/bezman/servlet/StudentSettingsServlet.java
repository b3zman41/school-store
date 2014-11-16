package com.bezman.servlet;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by Terence on 11/13/2014.
 */
@Controller
@RequestMapping
public class StudentSettingsServlet {

    @RequestMapping(value = "/studentsettings", method = {RequestMethod.GET, RequestMethod.POST})
    public String studentSettings(Model model, HttpServletRequest request){

        Cookie cookie = IndexServlet.getCookie(request.getCookies(), "sessionID");
        if (cookie != null){
            try {
                ResultSet resultSet = IndexServlet.execQuery("select * from sessions where sessionID='" + cookie.getValue() + "'");
                String username = null;

                while(resultSet.next()){
                    model.addAttribute("username", resultSet.getString("username"));
                    username = resultSet.getString("username");
                }

                System.out.println("Username : " + username);
                ResultSet accountSet = IndexServlet.execQuery("select * from accounts where username='" + username + "'");

                while(accountSet.next()){
                    model.addAttribute("role", accountSet.getString("role"));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return "studentsettings";
    }

    @RequestMapping(value = "/removestudent", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String removeStudent(@RequestParam("name") String name){

        JSONObject jsonObject = new JSONObject();

        try {
            IndexServlet.execUpdate("delete from students where name='" + name + "'");
            jsonObject.put("success", "true");
        } catch (SQLException e) {
            e.printStackTrace();
            jsonObject.put("success", "false");
        }

        return jsonObject.toJSONString();
    }

    @RequestMapping(value = "/addstudent", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String addStudent(@RequestParam("name") String name, @RequestParam("period") String period){

        JSONObject jsonObject = new JSONObject();

        try {
            IndexServlet.execUpdate("insert into students values('" + StringEscapeUtils.escapeHtml(name) + "', '" + StringEscapeUtils.escapeHtml(period) + "')");
            jsonObject.put("success", "true");
        } catch (SQLException e) {
            e.printStackTrace();
            jsonObject.put("success", "false");
        }

        return jsonObject.toJSONString();
    }

    @RequestMapping(value = "/editstudent", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String editStudent(@RequestParam("oldName") String oldName, @RequestParam("newName") String newName, @RequestParam("oldPeriod") String oldPeriod, @RequestParam("newPeriod") String newPeriod){

        JSONObject jsonObject = new JSONObject();

        try {
            IndexServlet.execUpdate("update students set name='" + StringEscapeUtils.escapeHtml(newName) + "',period='" + StringEscapeUtils.escapeHtml(newPeriod) + "' where name='" + oldName + "' and period='" + oldPeriod + "'");
            jsonObject.put("success", "true");
        } catch (SQLException e) {
            e.printStackTrace();
            jsonObject.put("success", "false");
        }

        return jsonObject.toJSONString();
    }

}
