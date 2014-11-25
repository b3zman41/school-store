package com.bezman.servlet;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by Terence on 11/11/2014.
 */
@Controller
@RequestMapping
public class ItemSettings {

    @RequestMapping(value = "/itemsettings", method = {RequestMethod.GET})
    public String ItemSettings(Model model, HttpServletRequest request, HttpServletResponse response){

        IndexServlet.servletLoginCheck(model, request, response);

        JSONArray jsonArray = new JSONArray();

        String school = IndexServlet.schoolForSessionID(request);

        if (school != null) {

            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("select * from items WHERE school=? order by name");
                statement.setString(1, school);

                ResultSet itemSet = statement.executeQuery();

                while (itemSet.next()) {
                    JSONObject jsonObject = new JSONObject();

                    jsonObject.put("itemName", itemSet.getString("name"));
                    jsonObject.put("priceOfItem", itemSet.getString("price"));

                    jsonArray.add(jsonObject);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        model.addAttribute("itemNames", StringEscapeUtils.escapeJavaScript(jsonArray.toJSONString()));

        return "itemsettings";
    }

    @RequestMapping(value = "/changeitemname", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String changeItemName(Model model, HttpServletRequest request, @RequestParam("name") String name, @RequestParam("oldName") String oldName, @RequestParam("price") String price){
        JSONObject jsonObject = new JSONObject();

        String school = IndexServlet.schoolForSessionID(request);

        if(IndexServlet.isSessionAdmin(IndexServlet.getCookie(request.getCookies(), "sessionID").getValue()) && school != null){
            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("update items set name=?,price=? where name=? and school=?");
                statement.setString(1, StringEscapeUtils.escapeHtml(name));
                statement.setDouble(2, Double.valueOf(price));
                statement.setString(3, StringEscapeUtils.escapeHtml(oldName));
                statement.setString(4, school);

                statement.executeUpdate();
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

        String school = IndexServlet.schoolForSessionID(request);

        if(IndexServlet.isSessionAdmin(IndexServlet.getCookie(request.getCookies(), "sessionID").getValue()) && school != null){
            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("delete from items where name=? and school=?");
                statement.setString(1, StringEscapeUtils.escapeHtml(name));
                statement.setString(2, school);

                statement.executeUpdate();
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
    public String addItem(Model model, HttpServletRequest request, @RequestParam("name") String name, @RequestParam("price") String price){
        JSONObject jsonObject = new JSONObject();

        String school = IndexServlet.schoolForSessionID(request);
        System.out.println(school);

        if(IndexServlet.isSessionAdmin(IndexServlet.getCookie(request.getCookies(), "sessionID").getValue()) && school != null){
            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("insert into items values(?, ?, ?)");
                statement.setString(1, StringEscapeUtils.escapeHtml(name));
                statement.setDouble(2, Double.valueOf(price));
                statement.setString(3, school);

                statement.executeUpdate();

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
