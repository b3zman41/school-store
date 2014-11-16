package com.bezman.servlet;

import org.json.simple.JSONArray;
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
import java.util.Comparator;
import java.util.stream.Collectors;

/**
 * Created by Terence on 11/9/2014.
 */
@Controller
@RequestMapping
public class DailyServlet {

    @RequestMapping(value = "/daily", method = RequestMethod.GET)
    public String getDaily(Model model, HttpServletRequest request){

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

                ResultSet itemSet = IndexServlet.execQuery("select * from items");
                ArrayList items = new ArrayList();

                while(itemSet.next()){
                    items.add(itemSet.getString("name"));
                }

                model.addAttribute("itemNames", items.stream().collect(Collectors.joining(",")));
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return "daily";
    }

    @RequestMapping(value = "/getstudents", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String getStudents(Model model, @RequestParam(value = "period", required = false) String period){

        JSONArray jsonArray = new JSONArray();

        try {
            String query = period == null ? "select * from students" : "select * from students where period='" + period + "' ORDER BY period ASC";
            ResultSet resultSet = IndexServlet.execQuery(query);

            while(resultSet.next()){
                JSONObject jsonObject = new JSONObject();

                jsonObject.put("name", resultSet.getString("name"));
                jsonObject.put("period", resultSet.getString("period"));

                jsonArray.add(jsonObject);
            }

            jsonArray.sort(new Comparator() {
                @Override
                public int compare(Object o1, Object o2) {
                    JSONObject jsonObject1 = (JSONObject) o1;
                    JSONObject jsonObject2 = (JSONObject) o2;

                    return String.valueOf(jsonObject1.get("period")).compareTo(String.valueOf(jsonObject2.get("period")));
                }
            });
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return  jsonArray.toJSONString();
    }

}
