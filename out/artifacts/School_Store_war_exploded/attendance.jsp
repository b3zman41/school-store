<%--
  Created by IntelliJ IDEA.
  User: Terence
  Date: 11/11/2014
  Time: 2:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

  <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>

  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css">

  <!-- Optional theme -->
  <link rel="stylesheet" href="http://bootswatch.com/flatly/bootstrap.css">

  <!-- Latest compiled and minified JavaScript -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>

  <script src="https://rawgit.com/carhartl/jquery-cookie/master/src/jquery.cookie.js"></script>

  <script src="https://rawgit.com/t4t5/sweetalert/master/lib/sweet-alert.min.js"></script>
  <link rel="stylesheet" type="text/css" href="https://rawgit.com/t4t5/sweetalert/master/lib/sweet-alert.css">

  <title></title>
</head>
<body>

<nav class="navbar navbar-default" role="navigation">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <ul><li><a href="/" class="navbar-brand">School Store</a></li></ul>
    </div>

    <div id="navbar" class="navbar-collapse collapse" aria-expanded="false" style="height: 1px;">
      <ul class="nav navbar-nav">
        <li><a href="/daily">Daily</a></li>
        <li class="role-admin"><a href="/monthlyrecap">Sales Recap</a></li>
        <li class="role-admin"><a href="/itemsettings">Item Settings</a></li>
        <li class="role-admin"><a href="/studentsettings">Student Settings</a></li>
        <li class="role-admin active"><a href="/attendance">Attendance</a></li>
      </ul>

      <ul class="nav navbar-nav navbar-right">
        <%
          if(request.getAttribute("username") != null){
            out.print("<li><a><button class='btn btn-primary' id='usernameButton' type='button'>" + request.getAttribute("username") + "</button></a></li>");
            out.print("<li><a><button class='btn btn-danger' id='signOut' type='button'>Sign Out</button></a></li>");
          }else out.print("<li><a><button class='btn btn-primary' data-toggle='modal' data-target='#signInModal' id='signIn' type='button'>Sign In</button></a></li>");
        %>
      </ul>
    </div>
  </div>
</nav>
<div id="signInModal" class="modal fade" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-body">
        <form class="form-horizontal" role="form">
          <div class="form-group" style="padding: 3%;">
            <label class="control-label"><h4><strong>Username</strong></h4></label>
            <input id="usernameInput" class="form-control" type="text"/>
          </div>

          <div class="form-group" style="padding: 3%;">
            <label class="control-label"><h4><strong>Password</strong></h4></label>
            <input id="passwordInput" class="form-control" type="password"/>
          </div>
        </form>
      </div>
      <div class="modal-footer" style="text-align: center;">
        <button id="signInConfirmButton" type="button" class="btn btn-primary">Sign In</button>
        <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#signInModal">Cancel</button>
      </div>
    </div>
  </div>
</div>

<script>
  $("#signOut").click(function(){
    $.removeCookie("sessionID");
    location.reload();
  });

  $("#signInConfirmButton").click(function () {
    var username = $("#signInModal").find("#usernameInput").val();
    var password = $("#signInModal").find("#passwordInput").val();

    if(!username || !password){
      sweetAlert("Sign In Error", "Please fill out the form correctly", "error");
    }else{
      $.post("/login", {username: username, password: password}, function(data){
        var json = $.parseJSON(data);

        if(json.success === "false"){
          sweetAlert("Sign In Error", "Invalid Username or Password", "error");
        }else sweetAlert({
          title: "Sign In Success!",
          text: "Good Job!",
          type: "success"
        }, function(){
          location.reload();
        });
      });
    }

    console.log("Username : " + username + ", Password: " + password);
  });
</script>

<div class="container">
  <div class="row">

    <div class="col-sm-4">
      <label class="control-label">Month</label>
      <input id="month" placeholder="MM" class="form-control" type="number">
    </div>

    <div class="col-sm-4">
      <label class="control-label">Day</label>
      <input id="day" placeholder="DD" class="form-control" type="number">
    </div>

    <div class="col-sm-4">
      <label class="control-label">Year</label>
      <input id="year" placeholder="YYYY" class="form-control" type="number">
    </div>

  </div>

  <table class="table table-bordered table-striped" style="margin-top: 5%;">
    <thead><th>Names</th><th>Period</th></thead>

    <tbody id="namesTBody">

    </tbody>
  </table>

</div>

<script>
  <%
  if(request.getAttribute("role") == null || !request.getAttribute("role").equals("admin")){
    out.println("$('.role-admin').remove();");
  }
%>

  function setDateToToday() {
    var date = new Date();

    $("#month").val(date.getMonth() + 1);
    $("#day").val(date.getDate());
    $("#year").val(date.getFullYear());
  }

  function updateData(){
    var query = "/attendancejson?";

    var month = $("#month").val();
    var day = $("#day").val();
    var year = $("#year").val();

    if(month)
      query += "month=" + month + "&";

    if(day)
      query += "day=" + day + "&";

    if(year)
      query += "year=" + year + "&";

    console.log(query);

    $.get(query, null, function(data){
      $(".realPeriodNode").fadeOut(500, function(){$(this).remove()});

      var json = $.parseJSON(data);
      for(var i = 0; i < json.length; i++){
        var nameString = json[i].toString().split(";")[0];
        var period = json[i].toString().split(";")[1];

        var periodTD = document.createElement("td");
        periodTD.innerHTML = "<h2>" + period + "</h2>";

        var namesTD = document.createElement("td");

        var namesTDInnerHTML = "<table class='table table-bordered'>"

        for(var x = 0; x < nameString.toString().split(",").length; x++){
          if(nameString.toString().split(",")[x])
            namesTDInnerHTML += "<tr><td>" + nameString.toString().split(",")[x] + "</td></tr>"
        }

        namesTDInnerHTML += "</table>"

        namesTD.innerHTML = namesTDInnerHTML;

        var tr = document.createElement("tr");
        tr.className = "realPeriodNode";

        $(tr).append($(namesTD));
        $(tr).append($(periodTD));

        $("#namesTBody").append($(tr));
      }
    });
  }

  $("#month").change(updateData);
  $("#day").change(updateData);
  $("#year").change(updateData);
  $("#selectOrder").change(updateData);

  $("#day").keyup(updateData);
  $("#year").keyup(updateData);
  $("#month").keyup(updateData);

  setDateToToday();
  updateData();
</script>
</body>
</html>
