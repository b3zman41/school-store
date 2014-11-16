<%--
  Created by IntelliJ IDEA.
  User: Terence
  Date: 11/11/2014
  Time: 5:40 PM
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
        <li class="role-admin"><a href="/itemrecap">Item Recap</a></li>
        <li class="role-admin active"><a href="/itemsettings">Item Settings</a></li>
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

<div id="editItemModal" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content modal-sm">
      <div class="modal-header">
        Edit Name of Item
    </div>

      <div class="modal-body">
        <label class="control-label">Item Name</label>
        <input id="newItemNameInput" class="form-control" type="text">
      </div>

      <div class="modal-footer" style="text-align: center">
        <button id="changeItemNameButton" type="button" class="btn btn-primary">Done!</button>
        <button type="button" class="btn btn-default" onclick="$('#editItemModal').modal('hide')">Cancel</button>
      </div>
    </div>
  </div>
</div>

<div id="addItemModal" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content modal-sm">
      <div class="modal-header">
        Add Item to Database
      </div>

      <div class="modal-body">
        <label class="control-label">Item Name</label>
        <input id="addItemNameInput" class="form-control" type="text">
      </div>

      <div class="modal-footer" style="text-align: center">
        <button id="addItemNameInputButton" type="button" class="btn btn-primary">Add!</button>
        <button type="button" class="btn btn-default" onclick="$('#addItemModal').modal('hide')">Cancel</button>
      </div>
    </div>
  </div>
</div>

<div class="container">
  <div class="row" style="margin-bottom: 3%;">
    <div class="col-sm-4"></div>
    <div class="col-sm-4">
      <button id="addItemButton" type="button" class="btn btn-primary form-control"><span class="glyphicon glyphicon-plus"></span> Add</button>
    </div>
    <div class="col-sm-4"></div>
  </div>

  <table class="table table-bordered table-striped">
    <thead><th>Item Name</th><th>Edit</th></thead>

    <tbody id="itemsTBody">

    </tbody>

    <script>
      var itemNames = "${itemNames}";
      var itemClicked;

      $("#changeItemNameButton").click(function () {
        var query = "/changeitemname?";

        var newItemName = $("#newItemNameInput").val();

        if(newItemName){
          if(itemClicked){
            query += "name=" + newItemName + "&oldName=" + itemClicked;
            console.log(query);

            $.get(query, null, function(){
              sweetAlert({
                title: "Item Changed",
                text: "You changed the item name for " + itemClicked,
                type: "success"
              }, function(){
                location.reload();
              });
            });
          }
        }else{
          sweetAlert({
            title: "Error",
            text: "You did not type anything for the new item name",
            type: "error"
          });
        }
      });

      for(var i = 0; i < itemNames.split(",").length; i++){
        var tr = document.createElement("tr");

        var itemNameTD = document.createElement("td");
        itemNameTD.innerHTML = "<h4>" + itemNames.split(",")[i] + "</h4>";
        itemNameTD.className = "itemNameTD col-sm-8";

        var editTD = document.createElement("td");
        editTD.className = "col-sm-4"
        editTD.style.textAlign = "center";

        var editTDButton = document.createElement("button");
        editTDButton.innerHTML = "<span class='glyphicon glyphicon-pencil'></span> Edit";
        editTDButton.className = "btn btn-default";
        editTDButton.style.marginRight = "2%";

        var deleteTDButton = document.createElement("button");
        deleteTDButton.innerHTML = "<span class='glyphicon glyphicon-remove'></span> Delete";
        deleteTDButton.className = "btn btn-danger";

        $(deleteTDButton).click(function () {
          itemClicked = $(this).parent().parent().find(".itemNameTD h4").html();
          console.log(itemClicked);

          sweetAlert({
            title: "Confirmation",
            text: "Are you sure you want to remove : " + itemClicked,
            type: "warning",

            confirmButtonText: "Confirm",

            showCancelButton: true
          }, function(){
            $.get("/deleteitem?name=" + itemClicked, null, function(data){
              var json = $.parseJSON(data);

              if(json.success === "true"){
                sweetAlert({
                  title: "Item Deletion",
                  text: "The Item : " + itemClicked + " was deleted from the database.",
                  type: "success"
                })
              }else{
                sweetAlert({
                  title: "Item Deletion",
                  text: "The Item : " + itemClicked + " could not be deleted from the database.",
                  type: "error"
                })
              }

            })
          });
        });

        $(editTDButton).click(function () {
          itemClicked = $(this).parent().parent().find(".itemNameTD h4").html();
          console.log(itemClicked);
          $("#editItemModal").modal("show");
          $("#newItemNameInput").val(itemClicked);
        });

        editTD.appendChild(editTDButton);
        editTD.appendChild(deleteTDButton);

        tr.appendChild(itemNameTD);
        tr.appendChild(editTD);

        $("#itemsTBody").append($(tr));
      }
    </script>
  </table>
</div>

<script>
  <%
    if(request.getAttribute("role") == null || !request.getAttribute("role").equals("admin")){
      out.println("$('.role-admin').remove();");
    }
  %>

  $("#addItemButton").click(function () {
    $("#addItemModal").modal("show");
  });

  $("#addItemNameInputButton").click(function () {
    var addItemName = $("#addItemNameInput").val();

    if(addItemName){
      $.get("/additem?name=" + addItemName, null, function (data) {
        var json = $.parseJSON(data);

        if(json.success === "true"){
          sweetAlert({
            title: "Good Job!",
            text: "Your item was added to the database!",
            type: "success"
          }, function(){
            location.reload();
          });
        }else{
          sweetAlert({
            title: "Error",
            text: "Your item could not be added to the database!",
            type: "error"
          });
        }
      })
    }else{
      sweetAlert({
        title: "Error",
        text: "You did not enter a new item.",
        type: "error"
      });
    }
  });
</script>
</body>
</html>
