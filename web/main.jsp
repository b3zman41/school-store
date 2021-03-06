<%--
  Created by IntelliJ IDEA.
  User: Terence
  Date: 11/8/2014
  Time: 6:48 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

  <script src="/resources/jquery-2.1.1.js"></script>

  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css">

  <link rel="stylesheet" href="http://bootswatch.com/flatly/bootstrap.min.css">

  <!-- Latest compiled and minified JavaScript -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>

  <script src="https://rawgit.com/carhartl/jquery-cookie/master/src/jquery.cookie.js"></script>

  <script src="/resources/sweet-alert.min.js"></script>
  <link rel="stylesheet" type="text/css" href="/resources/sweet-alert.css">

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
      <ul><li class="active"><a href="/" class="navbar-brand">School Store</a></li></ul>
    </div>

    <div id="navbar" class="navbar-collapse collapse" aria-expanded="false" style="height: 1px;">
      <ul class="nav navbar-nav">
        <li class="role-student"><a href="/daily">Daily</a></li>
        <li class="role-admin"><a href="/monthlyrecap">Sales Recap</a></li>
        <li class="role-admin"><a href="/itemrecap">Item Recap</a></li>
        <li class="role-admin"><a href="/itemsettings">Item Settings</a></li>
        <li class="role-admin"><a href="/studentsettings">Student Settings</a></li>
        <li class="role-admin"><a href="/attendance">Attendance</a></li>
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

          <div class="form-group" style="padding: 3%">
            <label class="control-label"><h4><strong>School</strong></h4></label>
            <select class="form-control" id="schoolSelect">
              <option></option>
            </select>
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

<div id="motdModal" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        Enter the message for the students.
      </div>

      <div class="modal-body">
        <textarea id="motdTextArea" class="form-control" rows="6"></textarea>
      </div>

      <div class="modal-footer">
        <button id="motdDoneButton" type="button" class="btn btn-primary">Done!</button>
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
    var school = $("#signInModal").find("#schoolSelect").val();

    if(!username || !password || !school){
      sweetAlert("Sign In Error", "Please fill out the form correctly", "error");
    }else{
      $.post("/login", {username: username, password: password, school: school}, function(data){
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

  var allSchools = $.parseJSON('${allSchools}');

  for(var i = 0; i < allSchools.length; i++){
    var option = document.createElement("option");
    $(option).html(allSchools[i].toString().toUpperCase());
    $(option).attr("value", allSchools[i].toString());

    $("#schoolSelect").append($(option));
  }
</script>

<div style="text-align: center">
  <h2><strong>Messages</strong></h2>
</div>
<div class="container jumbotron" style="text-align: center">
  <p id="motdP" class="col-sm-12">${motd}</p>
</div>

<div class="row">
  <div class="col-sm-5"></div>
  <button data-toggle="modal" data-target="#motdModal" class="btn btn-primary col-sm-2 role-admin">Change Message</button>
  <div class="col-sm-5"></div>
</div>

<script>
  <%
  if(request.getAttribute("role") != null && !request.getAttribute("role").equals("")){
    if (request.getAttribute("role").equals("student")){
      out.println("$('.role-admin').remove();");
    }
  }else{
    out.println("$('.role-admin').remove();");
    out.println("$('.role-student').remove();");
  }
%>

  $("#motdTextArea").val($("#motdP").html().toString().replace(new RegExp("<br>", "g"), "\n"));

  $("#motdDoneButton").click(function () {
    $.get("/motd", {message: $("#motdTextArea").val()}, function(data){
      sweetAlert({
        title: "Good Job!",
        text: "You changed the message for the front page",
        type: "success"
      }, function () {
        location.reload();
      });
    });
  });
</script>

<script type="text/javascript">
  google_ad_client = "ca-pub-4314299965778964";
  google_ad_slot = "7278123533";
  google_ad_width = 728;
  google_ad_height = 90;
</script>
<!-- All Ads -->
<script type="text/javascript"
        src="//pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</body>
</html>
