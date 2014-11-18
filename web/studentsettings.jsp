<%--
  Created by IntelliJ IDEA.
  User: Terence
  Date: 11/13/2014
  Time: 2:52 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <script src="/resources/jquery-2.1.1.js"></script>

  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css">

  <link rel="stylesheet" href="/resources/flatly.css">

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
      <ul><li><a href="/" class="navbar-brand">School Store</a></li></ul>
    </div>

    <div id="navbar" class="navbar-collapse collapse" aria-expanded="false" style="height: 1px;">
      <ul class="nav navbar-nav">
        <li><a href="/daily">Daily</a></li>
        <li class="role-admin"><a href="/monthlyrecap">Sales Recap</a></li>
        <li class="role-admin"><a href="/itemrecap">Item Recap</a></li>
        <li class="role-admin"><a href="/itemsettings">Item Settings</a></li>
        <li class="role-admin active"><a href="/studentsettings">Student Settings</a></li>
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
        </form>
      </div>
      <div class="modal-footer" style="text-align: center;">
        <button id="signInConfirmButton" type="button" class="btn btn-primary">Sign In</button>
        <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#signInModal">Cancel</button>
      </div>
    </div>
  </div>
</div>

<div id="newStudentModal" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        Set the student's name
      </div>

      <div class="modal-body">
        <form class="form-horizontal" role="form">
          <label class="control-label">Name</label>
          <input id="newNameInput" class="form-control" type="text">

          <label class="control-label">Period</label>
          <input id="newPeriodInput" class="form-control" type="text">
        </form>
      </div>

      <div class="modal-footer">
        <button type="button" id="newNameOkayButton" class="btn btn-primary">Okay</button>
        <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#newStudentModal">Cancel</button>
      </div>
    </div>
  </div>
</div>

<div id="editStudentModal" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        Edit the student's name
      </div>

      <div class="modal-body">
        <form class="form-horizontal" role="form">
          <label class="control-label">Name</label>
          <input id="editNameInput" class="form-control" type="text">

          <label class="control-label">Period</label>
          <input id="editPeriodInput" class="form-control" type="text">
        </form>
      </div>

      <div class="modal-footer">
        <button type="button" id="editNameButton" class="btn btn-primary">Okay</button>
        <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#editStudentModal">Cancel</button>
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

  <div class="row" style="margin-bottom: 5%;;">
    <div class="col-sm-4"></div>
    <button type="button" id="addStudent" class="btn btn-primary col-sm-4" data-toggle="modal" data-target="#newStudentModal">Add Student</button>
    <div class="col-sm-4"></div>
  </div>

  <table class="table table-bordered table-striped">
    <thead><th>Name</th><th>Period</th></th><th>Action</th></thead>
    <tbody id="studentsTBody">

    </tbody>
  </table>
</div>

<script>
  <%
  if(request.getAttribute("role") == null || !request.getAttribute("role").equals("admin")){
    out.println("$('.role-admin').remove();");
  }
%>

  var oldName;
  var oldPeriod;

  $("#newNameOkayButton").click(function () {

    var newName = $("#newNameInput").val();
    var period = $("#newPeriodInput").val();

    if(!newName || !period){
      sweetAlert("Error", "Please enter something for the new student's name and period.", "error");
    }else{
      $.get("/addstudent", {name : newName, period : period}, function (data) {
        var json = $.parseJSON(data);

        if(json.success === "true"){
          sweetAlert({
            title: "Success",
            text: "You successfully added " + newName + " to the system!",
            type: "success"
          }, function () {
            location.reload()
          });
        }else if (json.success === "false"){
          sweetAlert({
            title: "Error",
            text: "Could not add " + newName + " to the system",
            type: "error"
          });
        }
      })
    }
  });

  $("#editNameButton").click(function () {
    var newName = $("#editNameInput").val();
    var newPeriod = $("#editPeriodInput").val();

    console.log(oldName);
    console.log(oldPeriod);
    console.log(newName);
    console.log(newPeriod);

    if (oldName && oldPeriod && newName && newPeriod) {
      $.get("/editstudent", {
        oldName: oldName,
        oldPeriod: oldPeriod,
        newName: newName,
        newPeriod: newPeriod
      }, function (data) {
        var json = $.parseJSON(data);

        if (json.success === "true") {
          sweetAlert({
            title: "Success",
            text: "You successfully edited " + newName + " in the system!",
            type: "success"
          }, function () {
            location.reload()
          });
        } else if (json.success === "false") {
          sweetAlert({
            title: "Error",
            text: "Could not add " + newName + " to the system",
            type: "error"
          });
        }
      });
    }else {
      sweetAlert("Error", "The data that you entered was not valid!", "error");
    }
  });


  $.get("/getstudents", null, function(data){
    var json = $.parseJSON(data);

    for(var i = 0; i < json.length; i++){
      var tr = document.createElement("tr");
      $(tr).attr("id", json[i].name);
      $(tr).attr("period", json[i].period);
      $(tr).attr("class", "studentNode");

      var period = json[i].period;

      if(period === "0")
        period = "Before School";

      var nameTD = document.createElement("td");
      nameTD.innerHTML = json[i].name;

      var periodTD = document.createElement("td");
      periodTD.innerHTML = json[i].period;
      periodTD.style.textAlign = "center";

      var actionsTD = document.createElement("td");
      actionsTD.style.textAlign = "center";

      var editTDButton = document.createElement("button");
      editTDButton.innerHTML = "<span class='glyphicon glyphicon-pencil'></span> Edit";
      editTDButton.className = "btn btn-default";
      editTDButton.style.marginRight = "2%";

      var deleteTDButton = document.createElement("button");
      deleteTDButton.innerHTML = "<span class='glyphicon glyphicon-remove'></span> Delete";
      deleteTDButton.className = "btn btn-danger";
      deleteTDButton.style.marginLeft = "2%";

      actionsTD.appendChild(editTDButton);
      actionsTD.appendChild(deleteTDButton);

      tr.appendChild(nameTD);
      tr.appendChild(periodTD);
      tr.appendChild(actionsTD);

      $(editTDButton).click(function () {
        var id = $(this).closest(".studentNode").attr("id");
        var period = $(this).closest(".studentNode").attr("period");

        oldName = id;
        oldPeriod = period;

        $("#editNameInput").val(id);
        $("#editPeriodInput").val(period);

        $("#editStudentModal").modal("show");
      });

      $(deleteTDButton).click(function () {
        var id = $(this).closest(".studentNode").attr("id");
        var period = $(this).closest(".studentNode").attr("period");

        oldName = id;
        oldPeriod = period;

        $.get("/removestudent", {name : id}, function (data) {
          var json = $.parseJSON(data);

          if(json.success === "true"){
            sweetAlert({
              title: "Success",
              text: id + " was successfully removed!",
              type: "success"
            }, function () {
              location.reload();
            });
          }else if(json.success === "false"){

          }
        })
      });

      $("#studentsTBody").append($(tr));
    }
  });
</script>

</body>
</html>
