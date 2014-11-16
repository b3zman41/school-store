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
import java.util.ArrayList;
import java.util.stream.Collectors;

/**
 * Created by Terence on 11/11/2014.
 */
@Controller
@RequestMapping
public class ItemSettings {

    @RequestMapping(value = "/itemsettings", method = {RequestMethod.GET})
    public String ItemSettings(Model model, HttpServletRequest request){

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

        ArrayList itemNames = new ArrayList();

        try {
            ResultSet itemSet = IndexServlet.execQuery("select * from items");

            while(itemSet.next()){
                itemNames.add(itemSet.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        model.addAttribute("itemNames", itemNames.stream().collect(Collectors.joining(",")));

        return "itemsettings";
    }

    @RequestMapping(value = "/changeitemname", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String changeItemName(Model model, HttpServletRequest request, @RequestParam("name") String name, @RequestParam("oldName") String oldName){
        JSONObject jsonObject = new JSONObject();

        if(IndexServlet.isSessionAdmin(IndexServlet.getCookie(request.getCookies(), "sessionID").getValue())){
            try {
                IndexServlet.execUpdate("update items set name='" + StringEscapeUtils.escapeHtml(name) + "' where name='" + oldName + "'");
                jsonObject.put("success", "true");
            } catch (SQLException e) {
                jsonObject.put("success", "false");
            }
        }else{
            jsonObject.put("success", "false");
        }

        return jsonObject.toJSONString();
    }

    @RequestMapping(value = "/deleteitem", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String deleteItem(Model model, HttpServletRequest request, @RequestParam("name") String name){
        JSONObject jsonObject = new JSONObject();

        if(IndexServlet.isSessionAdmin(IndexServlet.getCookie(request.getCookies(), "sessionID").getValue())){
            try {
                IndexServlet.execUpdate("delete from items where name='" + name + "'");
                jsonObject.put("success", "true");
            } catch (SQLException e) {
                jsonObject.put("success", "false");
            }
        }else{
            jsonObject.put("success", "false");
        }

        return jsonObject.toJSONString();
    }

    @RequestMapping(value = "/additem", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String addItem(Model model, HttpServletRequest request, @RequestParam("name") String name){
        JSONObject jsonObject = new JSONObject();

        if(IndexServlet.isSessionAdmin(IndexServlet.getCookie(request.getCookies(), "sessionID").getValue())){
            try {
                IndexServlet.execUpdate("insert into items values('" + StringEscapeUtils.escapeHtml(name) + "')");
                jsonObject.put("success", "true");
            } catch (SQLException e) {
                jsonObject.put("success", "false");
            }
        }else{
            jsonObject.put("success", "false");
        }

        return jsonObject.toJSONString();
    }

}
