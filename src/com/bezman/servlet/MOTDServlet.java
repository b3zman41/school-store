package com.bezman.servlet;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by Terence on 11/11/2014.
 */
@Controller
@RequestMapping
public class MOTDServlet {

    @RequestMapping(value = "/motd", method = RequestMethod.GET)
    @ResponseBody
    public String changeMOTD(Model model, HttpServletRequest request, @RequestParam("message") String message){

        String school = IndexServlet.schoolForSessionID(request);

        if (school != null) {
            try {
                PreparedStatement statement = IndexServlet.connection.prepareStatement("SELECT * from other where theKey=? and school=?");
                statement.setString(1, "motd");
                statement.setString(2, school);


                boolean foundRow = false;

                ResultSet resultSet = statement.executeQuery();

                while (resultSet.next()){
                    foundRow = true;
                }

                if (foundRow){
                    //Update, not insert
                    PreparedStatement updateStatement = IndexServlet.connection.prepareStatement("update other SET value=? where theKey=? and school=?");
                    updateStatement.setString(1, message);
                    updateStatement.setString(2, "motd");
                    updateStatement.setString(3, school);

                    updateStatement.executeUpdate();
                }else{
                    //Insert, not update
                    PreparedStatement insertStatement = IndexServlet.connection.prepareStatement("insert into other VALUES(?, ?, ?)");
                    insertStatement.setString(1, "motd");
                    insertStatement.setString(2, message);
                    insertStatement.setString(3, school);

                    insertStatement.executeUpdate();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return "";
    }



}
