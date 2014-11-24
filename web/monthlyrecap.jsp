<%--
  Created by IntelliJ IDEA.
  User: Terence
  Date: 11/10/2014
  Time: 7:55 PM
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
      <ul><li><a href="/" class="navbar-brand">School Store</a></li></ul>
    </div>

    <div id="navbar" class="navbar-collapse collapse" aria-expanded="false" style="height: 1px;">
      <ul class="nav navbar-nav">
        <li><a href="/daily">Daily</a></li>
        <li class="role-admin active"><a href="/monthlyrecap">Sales Recap</a></li>
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
  <div class="row">
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
</div>

<div id="templatePeriod" style="display: none; margin-left: 10%; margin-right: 10%;" class="container-fluid">
  <table class="table table-bordered">
    <thead id="staticThead"><th id="periodNumber">Period 9</th></thead>
    <tbody>
    <tr>
      <td>
        <table class="table table-striped">
          <tbody>
          <tr>
            <td>
              <table class="table table-striped table-bordered">
                <thead>
                <th>Names</th>
                </thead>
                <tbody id="nameBody">

                </tbody>
              </table>
            </td>

            <td>
              <table class="table table-striped table-bordered">
                <thead>
                <th>Item</th>
                <th>Price</th>
                <th>Item Count</th>
                <th>Total</th>
                </thead>

                <tbody id="itemDescBody">
                </tbody>
              </table>
            </td>

            <td>
              <table class="table table-bordered table-striped">
                <thead>
                <th>Money at start of Period</th>
                </thead>
                <tbody>
                <tr>
                  <td id="startSumTD"></td>
                </tr>
                </tbody>
              </table>

              <table class="table table-bordered table-striped">
                <thead>
                <th>Money at end of Period</th>
                </thead>
                <tbody>
                <tr>
                  <td id="endSumTD"></td>
                </tr>
                </tbody>
              </table>
            </td>
          </tr>
          </tbody>
        </table>
      </td>
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

  function deletePeriod(id){

    $.get("/deleteperiod", {date: id}, function (data) {
      var json = $.parseJSON(data);

      if(json.success === "true"){
        sweetAlert({
          title: "Are you sure?",
          text: "You will be deleting this entry.",
          type: "warning",

          closeOnConfirm: false,
          showCancelButton: true
        }, function (isConfirm) {
          if(isConfirm) {
            sweetAlert({
              title: "Good Job!",
              text: "You deleted the entry!",
              type: "success"
            }, function () {
              location.reload()
            });
          }
        });
      }else{
        sweetAlert({
          title: "Error",
          text: "The period could not be deleted.",
          type: "error"
        });
      }
    });
  }

  function insertPeriod(json){
    var clone = $("#templatePeriod").clone();

    $(clone).attr("id", json.date);
    $(clone).attr("class", "realPeriodNode");

    $(clone).css({"display": "block"});

    $(clone).find("#staticTHead").html("<th>" +
    "<table class='table table-bordered table-condensed'><thead><th>Period " + json.period + "</th><th>Date (" + json.date.toString().split(" ")[0] + ")</th><th>Time (" + json.date.toString().split(" ")[1] + ")</th><th style='text-align: center'><button type='button' class='btn btn-danger removeButton'>Remove</button></th></thead></table>" +
    "</th>");

    $(clone).find("#startSumTD").html("$" + parseFloat(json.startSum).toFixed(2));
    $(clone).find("#endSumTD").html("$" + parseFloat(json.endSum).toFixed(2));

    for(var names = 0; names < json.names.length; names++){
      var name = json.names[names].name;

      var td = document.createElement("td");
      var tr = document.createElement("tr");

      td.innerHTML = name;

      tr.appendChild(td);

      $(clone).find("#nameBody").append($(tr));
    }

    for(var sale = 0; sale < json.sales.length; sale++){

      var tr = document.createElement("tr");

      var itemTD = document.createElement("td");
      itemTD.innerHTML = json.sales[sale].itemName;

      var priceOfItemTD = document.createElement("td");
      priceOfItemTD.innerHTML = "$" + json.sales[sale].priceOfItem.toFixed(2);

      var numOfItemTD = document.createElement("td");
      numOfItemTD.innerHTML = json.sales[sale].numOfItems;

      var totalPriceOfItemTD = document.createElement("td");
      totalPriceOfItemTD.innerHTML = "$" + (parseFloat(json.sales[sale].numOfItems) * parseFloat(json.sales[sale].priceOfItem)).toFixed(2);

      tr.appendChild(itemTD);
      tr.appendChild(priceOfItemTD);
      tr.appendChild(numOfItemTD);
      tr.appendChild(totalPriceOfItemTD);

      $(clone).find("#itemDescBody").append($(tr));
    }

    $("#templatePeriod").parent().append($(clone));
  }

  function updateData() {

    var query = "/monthlyrecapjson?";

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

      $(".realPeriodNode").fadeOut(500, function(){$(this).remove()})

      for (var i = 0; i < json.length; i++) {
        insertPeriod(json[i]);
      }

      $(".removeButton").click(function () {
        var id = $(this).closest(".realPeriodNode").attr("id");

        deletePeriod(id);
      });
    });
  }

  $("#asc-desc").change(updateData);
  $("#month").change(updateData);
  $("#day").change(updateData);
  $("#year").change(updateData);

  $("#month").keyup(updateData);
  $("#day").keyup(updateData);
  $("#year").keyup(updateData);

  updateData();
</script>
</body>
</html>
