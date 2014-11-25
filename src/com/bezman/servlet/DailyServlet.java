package com.bezman.servlet;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by Terence on 11/9/2014.
 */
@Controller
@RequestMapping
public class DailyServlet {

    @RequestMapping(value = "/daily", method = RequestMethod.GET)
    public String getDaily(Model model, HttpServletRequest request, HttpServletResponse response){

        IndexServlet.servletLoginCheck(model, request, response);

        String school = IndexServlet.schoolForSessionID(request);

        if (school != null) {
            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("select * from items where school=?");
                statement.setString(1, school);

                ResultSet itemSet = statement.executeQuery();
                JSONArray jsonArray = new JSONArray();

                while (itemSet.next()) {
                    JSONObject jsonObject = new JSONObject();

                    jsonObject.put("itemName", itemSet.getString("name"));
                    jsonObject.put("priceOfItem", itemSet.getDouble("price"));

                    jsonArray.add(jsonObject);
                }

                model.addAttribute("itemNames", StringEscapeUtils.escapeJavaScript(jsonArray.toJSONString()));
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return "daily";
    }

}
