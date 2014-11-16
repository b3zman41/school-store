package com.bezman.servlet;

import com.bezman.com.bezman.reference.Reference;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by Terence on 11/9/2014.
 */
@Controller
@RequestMapping
public class SubmitDaily {

    @RequestMapping(value = "/dailysubmit", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public String submit(@RequestParam Map allParams, Model model){
        String query = "insert into daily (date, ";

        JSONObject jsonObject = new JSONObject();

        String sales = (String) allParams.get("sale");
        allParams.remove("sale");

        Timestamp timestamp = new Timestamp(System.currentTimeMillis());

        String columnsNames = (String) allParams.keySet().stream().collect(Collectors.joining(", "));
        query += columnsNames;
        query += ") values('" + timestamp + "', " + (String) allParams.keySet().stream().map(a -> allParams.get(a)).collect(Collectors.joining("', '", "'", "'")) + ")";

        System.out.println("query : " + query);

        try {
            IndexServlet.execUpdate(query);

            System.out.println(sales);
            for(String currentSale : sales.split(",")) {
                query = "insert into sales values('" + timestamp + "', '" + currentSale + "')";
                System.out.println(query);
                IndexServlet.execUpdate(query);
            }

            jsonObject.put("success", "true");
        } catch (SQLException e) {
            jsonObject.put("success", "false");
            e.printStackTrace();
        }

        System.out.println("SUBMISSION WAS ENTERED :" + Reference.randomCounter++);

        return jsonObject.toJSONString();
    }

}
