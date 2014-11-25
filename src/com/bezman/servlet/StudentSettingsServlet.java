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
import java.util.Comparator;

/**
 * Created by Terence on 11/13/2014.
 */
@Controller
@RequestMapping
public class StudentSettingsServlet {

    @RequestMapping(value = "/studentsettings", method = {RequestMethod.GET, RequestMethod.POST})
    public String studentSettings(Model model, HttpServletRequest request, HttpServletResponse response){

        IndexServlet.servletLoginCheck(model, request, response);

        return "studentsettings";
    }

    @RequestMapping(value = "/removestudent", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String removeStudent(HttpServletRequest request, @RequestParam("name") String name){

        JSONObject jsonObject = new JSONObject();

        String school = IndexServlet.schoolForSessionID(request);

        if (school != null) {
            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("DELETE from students where name=? and school=?");
                statement.setString(1, name);
                statement.setString(2, school);

                statement.executeUpdate();
                jsonObject.put("success", "true");
            } catch (SQLException e) {
                e.printStackTrace();
                jsonObject.put("success", "false");
            }
        }

        return jsonObject.toJSONString();
    }

    @RequestMapping(value = "/addstudent", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String addStudent(HttpServletRequest request, @RequestParam("name") String name, @RequestParam("period") String period){

        JSONObject jsonObject = new JSONObject();

        String school = IndexServlet.schoolForSessionID(request);

        if (school != null) {
            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("insert into students VALUES(?, ?, ?)");
                statement.setString(1, StringEscapeUtils.escapeHtml(name));
                statement.setString(2, StringEscapeUtils.escapeHtml(period));
                statement.setString(3, school);

                statement.executeUpdate();
                jsonObject.put("success", "true");
            } catch (SQLException e) {
                e.printStackTrace();
                jsonObject.put("success", "false");
            }
        }

        return jsonObject.toJSONString();
    }

    @RequestMapping(value = "/editstudent", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String editStudent(HttpServletRequest request, @RequestParam("oldName") String oldName, @RequestParam("newName") String newName, @RequestParam("oldPeriod") String oldPeriod, @RequestParam("newPeriod") String newPeriod){

        JSONObject jsonObject = new JSONObject();

        String school = IndexServlet.schoolForSessionID(request);

        if (school != null) {
            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("update students set name=?, period=? where name=? and period=? and school=?");
                statement.setString(1, newName);
                statement.setString(2, newPeriod);
                statement.setString(3, oldName);
                statement.setString(4, oldPeriod);
                statement.setString(5, school);

                statement.executeUpdate();
                jsonObject.put("success", "true");
            } catch (SQLException e) {
                e.printStackTrace();
                jsonObject.put("success", "false");
            }
        }

        return jsonObject.toJSONString();
    }

    @RequestMapping(value = "/getstudents", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String getStudents(Model model, HttpServletRequest request, @RequestParam(value = "period", required = false) String period){

        JSONArray jsonArray = new JSONArray();

        String school = IndexServlet.schoolForSessionID(request);

        if (school != null) {
            try {
                PreparedStatement statement;

                if (period == null) {
                    statement = IndexServlet.connection.prepareStatement("SELECT * FROM students where school=?");
                    statement.setString(1, school);
                } else {
                    statement = IndexServlet.connection.prepareStatement("SELECT * FROM students WHERE period=? and school=? ORDER BY period ASC");
                    statement.setString(1, period);
                    statement.setString(2, school);
                }

                ResultSet resultSet = statement.executeQuery();

                while (resultSet.next()) {
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
        }

        return  jsonArray.toJSONString();
    }

}
