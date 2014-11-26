<%--
  Created by IntelliJ IDEA.
  User: Terence
  Date: 11/16/2014
  Time: 10:13 AM
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

  <style media="print">
    #dateParams{
      display: none;
    }
  </style>
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
        <li class="role-admin active"><a href="/itemrecap">Item Recap</a></li>
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

<div class="container" style="margin-bottom: 2%;">
  <div id="dateParams" class="row">
    <div class="col-sm-6">
      <label class="control-label">Order</label>
      <select class="form-control" id="asc-desc">
        <option value="desc">Descending</option>
        <option value="">Ascending</option>
      </select>
    </div>

    <div class="col-sm-2">
      <label class="control-label">Month</label>
      <input id="month" placeholder="MM" class="form-control" type="number">
    </div>

    <div class="col-sm-2">
      <label class="control-label">Day</label>
      <input id="day" placeholder="DD" class="form-control" type="number">
    </div>

    <div class="col-sm-2">
      <label class="control-label">Year</label>
      <input id="year" placeholder="YYYY" class="form-control" type="number">
    </div>

  </div>
  <div class="row">
    <div class="col-sm-4"></div>
    <div class="col-sm-4"><h2><span id="dateSpanLabel" class="label label-default"></span></h2></div>
    <div class="col-sm-4"></div>
  </div>
</div>

<div class="container">
  <table class="table table-bordered table-striped">
    <thead>
    <th>Name</th>
    <th style="text-align: center;">Number of Items Sold</th>
    <th style="text-align: center;">Total Money Made</th>
    </thead>

    <tbody id="salesTBody">

    </tbody>
  </table>

  <table class="table table-bordered table-striped">
    <thead>
    <th style="text-align: center">Total Items Sold</th>
    <th style="text-align: center">Total Cash Made</th>
    </thead>

    <tbody>
    <tr>
      <td style="text-align: center" id="totalItemsCount"></td>
      <td style="text-align: center" id="totalCashCount"></td>
    </tr>
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
    $("#year").val(date.getFullYear());
  }

  function updateData() {

    var query = "/itemrecapjson?";

    var month = $("#month").val();
    var day = $("#day").val();
    var year = $("#year").val();

    if(month || day || year){
      if(month)
        query += "month=" + month + "&";

      if(day)
        query += "day=" + day + "&";

      if(year)
        query += "year=" + year + "&";
    }

    query += "order=" + $("#asc-desc").val();

    console.log(query);

    $.get(query , null, function (data) {
      var json = $.parseJSON(data);
      console.log(json);

      $("#salesTBody td").fadeOut(500, function(){$(this).remove()})

      var oldest;
      var newest;

      var itemsSum = 0;
      var totalCash = 0.0;

      for(var i = 0; i < json.length; i++){
        var itemNameTD = document.createElement("td");
        itemNameTD.innerHTML = json[i].itemName;

        var numOfItemsTD = document.createElement("td");
        numOfItemsTD.innerHTML = json[i].numOfItems;
        numOfItemsTD.style.textAlign = "center";

        var totalCashTD = document.createElement("td");
        totalCashTD.innerHTML = "$" + parseFloat(json[i].totalCash).toFixed(2);
        totalCashTD.style.textAlign = "center";

        var tr = document.createElement("tr");
        tr.appendChild(itemNameTD);
        tr.appendChild(numOfItemsTD);
        tr.appendChild(totalCashTD);

        $("#salesTBody").append($(tr));

        itemsSum += json[i].numOfItems;
        totalCash += parseFloat(json[i].totalCash);

        console.log(json[i].date);

        if(!oldest && !newest)
          oldest = newest = json[i].date;

        if(json[i].date < oldest)
          oldest = json[i].date;

        if(json[i].date > newest)
          newest = json[i].date;
      }

      var oldestDate = new Date(oldest);
      var newestDate = new Date(newest);

      $("#totalItemsCount").html(itemsSum);
      $("#totalCashCount").html("$"+ totalCash.toFixed(2));

      $("#dateSpanLabel").html(oldestDate.toDateString() + " - " + newestDate.toDateString());
    });
  }

  $("#asc-desc").change(updateData);
  $("#month").change(updateData);
  $("#day").change(updateData);
  $("#year").change(updateData);

  $("#month").keyup(updateData);
  $("#day").keyup(updateData);
  $("#year").keyup(updateData);

  setDateToToday();

  updateData();
</script>

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- All Ads -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-4314299965778964"
     data-ad-slot="7278123533"></ins>
<script>
  (adsbygoogle = window.adsbygoogle || []).push({});
</script>
</body>
</html>
