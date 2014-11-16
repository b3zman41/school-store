<!DOCTYPE HTML>

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

  <style>
    .realSaleNode{
      margin-bottom: 3%;
    }

    .realSaleNode:last-child{
      margin-bottom: 0;
    }

    #mainContainer{
      background-image: url(http://content.mycutegraphics.com/graphics/school/paper.png);
    }
  </style>

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
        <li class="active"><a href="/daily">Daily</a></li>
        <li class="role-admin"><a href="/monthlyrecap">Sales Recap</a></li>
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

<div id="mainContainer" class="container-fluid">

  <form class="form-horizontal" role="form">
    <div class="container">

      <div><label class="control-label">Period</label><input id="periodInput" class="form-control"></div>
      <div>
        <label class="control-label">Attendance (Check box next to name if person is present)</label>
        <table class="table table-bordered table-striped">
          <thead><th>Name</th></thead>
          <tbody id="namesTBody"></tbody>
        </table>
      </div>

      <div class="jumbotron">
        <div class="container" style="margin-top: 5%;">
          <table class="table table-striped table-bordered">
            <tbody>
            <td>
              <div>
                <div class="form-group">
                  <label class="control-label col-sm-2"></label>
                  <h2 class="col-sm-8" style="text-align: center;"><span class="label label-default">Before Period Start</span></h2>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">$1s</label>
                  <div class="col-sm-4">
                    <input id="startOnes" class="form-control moneyInput" name="startOnes"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startOnesValue" class="form-control" scale="1" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">$5s</label>
                  <div class="col-sm-4">
                    <input id="startFives" class="form-control moneyInput" name="startFives"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startFivesValue" class="form-control" scale="5" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">$10s</label>
                  <div class="col-sm-4">
                    <input id="startTens" class="form-control moneyInput" name="startTens"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startTensValue" class="form-control" scale="10" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">$20s</label>
                  <div class="col-sm-4">
                    <input id="startTwenties" class="form-control moneyInput" name="startTwenties"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startTwentiesValue" class="form-control" scale="20" contenteditable="false">
                  </div>
                </div>

                <div class="form-group" style="margin-bottom: 10%;">
                  <label class="control-label col-sm-2">Total Bills</label>
                  <div class="col-sm-4">
                    <input id="startTotalBills" class="form-control" contenteditable="false"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startTotalBillsValue" class="form-control" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Pennies</label>
                  <div class="col-sm-4">
                    <input id="startPennies" class="form-control moneyInput" name="startPennies"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startPenniesValue" class="form-control" scale=".01" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Nickels</label>
                  <div class="col-sm-4">
                    <input id="startNickels" class="form-control moneyInput" name="startNickels"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startNickelsValue" class="form-control" scale=".05" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Dimes</label>
                  <div class="col-sm-4">
                    <input id="startDimes" class="form-control moneyInput" name="startDimes"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startDimesValue" class="form-control" scale=".10" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Quarters</label>
                  <div class="col-sm-4">
                    <input id="startQuarters" class="form-control moneyInput" name="startQuarters"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startQuartersValue" class="form-control" scale=".25" contenteditable="false">
                  </div>
                </div>

                <div class="form-group" style="margin-bottom: 15%;">
                  <label class="control-label col-sm-2">Total Coins</label>
                  <div class="col-sm-4">
                    <input id="startTotalCoins" class="form-control"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startTotalCoinsValue" class="form-control" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Total</label>
                  <div class="col-sm-4">
                    <input id="startTotalCountAll" class="form-control" contenteditable="false"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="startTotalValueAll" class="form-control" contenteditable="false">
                  </div>
                </div>

              </div>
            </td>

            <td>
              <div>

                <div class="form-group">
                  <label class="control-label col-sm-2"></label>
                  <h2 class="col-sm-8" style="text-align: center;"><span class="label label-default">At Period End</span></h2>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">$1s</label>
                  <div class="col-sm-4">
                    <input id="endOnes" class="form-control moneyInput" name="endOnes"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endOnesValue" class="form-control" scale="1" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">$5s</label>
                  <div class="col-sm-4">
                    <input id="endFives" class="form-control moneyInput" name="endFives"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endFivesValue" class="form-control" scale="5" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">$10s</label>
                  <div class="col-sm-4">
                    <input id="endTens" class="form-control moneyInput" name="endTens"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endTensValue" class="form-control" scale="10" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">$20s</label>
                  <div class="col-sm-4">
                    <input id="endTwenties" class="form-control moneyInput" name="endTwenties"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endTwentiesValue" class="form-control" scale="20" contenteditable="false">
                  </div>
                </div>

                <div class="form-group" style="margin-bottom: 10%;">
                  <label class="control-label col-sm-2">Total Bills</label>
                  <div class="col-sm-4">
                    <input id="endTotalBills" class="form-control" contenteditable="false"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endTotalBillsValue" class="form-control" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Pennies</label>
                  <div class="col-sm-4">
                    <input id="endPennies" class="form-control moneyInput" name="endPennies"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endPenniesValue" class="form-control" scale=".01" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Nickels</label>
                  <div class="col-sm-4">
                    <input id="endNickels" class="form-control moneyInput" name="endNickels"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endNickelsValue" class="form-control" scale=".05" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Dimes</label>
                  <div class="col-sm-4">
                    <input id="endDimes" class="form-control moneyInput" name="endDimes"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endDimesValue" class="form-control" scale=".10" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Quarters</label>
                  <div class="col-sm-4">
                    <input id="endQuarters" class="form-control moneyInput" name="endQuarters"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endQuartersValue" class="form-control" scale=".25" contenteditable="false">
                  </div>
                </div>

                <div class="form-group" style="margin-bottom: 15%;">
                  <label class="control-label col-sm-2">Total Coins</label>
                  <div class="col-sm-4">
                    <input id="endTotalCoins" class="form-control"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endTotalCoinsValue" class="form-control" contenteditable="false">
                  </div>
                </div>

                <div class="form-group">
                  <label class="control-label col-sm-2">Total</label>
                  <div class="col-sm-4">
                    <input id="endTotalCountAll" class="form-control" contenteditable="false"/>
                  </div>


                  <label class="control-label col-sm-3">$</label>
                  <div class="col-sm-3">
                    <input id="endTotalValueAll" class="form-control" contenteditable="false">
                  </div>
                </div>
              </div>
            </td>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div style="text-align: center; margin-bottom: 3%;"><h2>Sales</h2></div>
    <div class="row jumbotron">
      <div id="templateSale" style="display: none;" class="form-group">
        <div class="col-sm-2" style="margin-left: 5%;">
          <select id="itemSelect" class="form-control">
            <option></option>
          </select>

          <script>
            var itemNames = "${itemNames}";

            for(var i = 0; i < itemNames.split(",").length; i++){
              var option = document.createElement("option");

              $(option).attr("value", itemNames.split(",")[i]);
              $(option).html(itemNames.split(",")[i]);

              $("#itemSelect").append($(option));
            }
          </script>
        </div>

        <label class="control-label col-sm-2"># Of Items Sold</label>

        <div class="col-sm-1">
          <input id="numOfItems" class="form-control">
        </div>

        <label class="control-label col-sm-2">Price of Item: $</label>

        <div class="col-sm-1">
          <input id="priceOfItem" class="form-control">
        </div>

        <label class="control-label col-sm-2">Total Cost: $</label>

        <div class="col-sm-1">
          <input id="totalCost" class="form-control" contenteditable="false">
        </div>
        <div class="col-sm-1"></div>
      </div>
    </div>

    <div id="totalSalesDiv" class="jumbotron row" style="width: 75%; margin: 0 auto; margin-bottom: 5%;">
      <div class="row col-sm-6">
        <label class="control-label col-sm-3">Total Items</label>
        <div class="col-sm-9">
          <input id="totalSalesItems" class="form-control">
        </div>
      </div>

      <div class="row col-sm-6">
        <label class="control-label col-sm-3">Total Sales $</label>
        <div class="col-sm-9">
          <input id="totalSalesMoney" class="form-control">
        </div>
      </div>
    </div>

    <div class="col-sm-12">
      <button id="submitButton" class="btn btn-primary" style="width: 100%; margin-bottom: 5%;" type="button"><h2>Submit</h2></button>
    </div>
  </form>

</div>

</div>

<script>

  var lastPeriod;

  <%
    if(request.getAttribute("role") == null || !request.getAttribute("role").equals("admin")){
      out.println("$('.role-admin').remove();");
    }
  %>

  inputChanged();

  function submit(){
    var params = "";

    var startOnes = valueFromInput($("#startOnesValue"));
    var startFives = valueFromInput($("#startFivesValue"));
    var startTens = valueFromInput($("#startTensValue"));
    var startTwenties = valueFromInput($("#startTwentiesValue"));
    var startPennies = valueFromInput($("#startPenniesValue"));
    var startNickels = valueFromInput($("#startNickelsValue"));
    var startDimes = valueFromInput($("#startDimesValue"));
    var startQuarters = valueFromInput($("#startQuartersValue"));

    var endOnes = valueFromInput($("#endOnesValue"));
    var endFives = valueFromInput($("#endFivesValue"));
    var endTens = valueFromInput($("#endTensValue"));
    var endTwenties = valueFromInput($("#endTwentiesValue"));
    var endPennies = valueFromInput($("#endPenniesValue"));
    var endNickels = valueFromInput($("#endNickelsValue"));
    var endDimes = valueFromInput($("#endDimesValue"));
    var endQuarters = valueFromInput($("#endQuartersValue"));

    var startSum = startOnes + startFives + startTens + startTwenties + startPennies + startNickels + startDimes + startQuarters;
    var endSum = endOnes + endFives + endTens + endTwenties + endPennies + endNickels + endDimes + endQuarters;

    var names = "";

    $(".nameCheck").each(function(){
      if(this.checked === true){
        names += $(this).attr("id") + ",";
      }
    });

    console.log(names);

    var period = $("#periodInput").val();

    params += "startOnes=" + startOnes + "&startFives=" + startFives + "&startTens=" + startTens + "&startTwenties=" + startTwenties + "&startPennies=" + startPennies + "&startNickels=" + startNickels + "&startDimes=" + startDimes + "&startQuarters=" + startQuarters + "&";
    params += "endOnes=" + endOnes + "&endFives=" + endFives + "&endTens=" + endTens + "&endTwenties=" + endTwenties + "&endPennies=" + endPennies + "&endNickels=" + endNickels + "&endDimes=" + endDimes + "&endQuarters=" + endQuarters + "&";

    params += "startSum=" + startSum.toFixed(2) + "&endSum=" + endSum.toFixed(2) + "&";

    params += "names=" + names + "&period=" + period + "&sale=";

    var saleCount = 0;
    var totalSalesCash = 0;
    $(".realSaleNode").each(function(){
      var item = $(this).find("#itemSelect").val();
      var numOfItems = $(this).find("#numOfItems").val();
      var priceOfItem = $(this).find("#priceOfItem").val();

      if(item !== "" && !isNaN(numOfItems) && !isNaN(priceOfItem)) {
        params += $(this).find("#itemSelect").val() + ";" + $(this).find("#numOfItems").val() + ";" + $(this).find("#priceOfItem").val() + ",";
        totalSalesCash += parseFloat(numOfItems) * parseFloat(priceOfItem);
        saleCount++;
      }
    });

    var url = "/dailysubmit?" + params;

    console.log("Total sales cash" + totalSalesCash);
    console.log(startSum + totalSalesCash + ", " + endSum);

    if(endSum < startSum) {
      sweetAlert("Error", "You have less money than you started with! Please revise the form.", "error");
    }else if((startSum + totalSalesCash).toFixed(2) !== endSum.toFixed(2)) {
      sweetAlert("Error", "Your sales do not add up to then ending sum! Please revise the form.", "error");
    }else if(startSum > 0 & endSum > 0 && names !== "" && period) {
      $.get(url, null, function (data) {
        var json = $.parseJSON(data);

        if (json.success === "true")
          sweetAlert("Good Job!", "You've entered the whole form correctly.", "success");

        console.log(json);
      });
    }else{
      sweetAlert({
        title: "Error",
        text: "Please fill out the form correctly.",
        type: "error"
      });
    }
  }

  function getSaleNode(){
    var clone = $($("#templateSale").clone());
    clone.attr("class", "form-group realSaleNode");
    clone.attr("id", "");
    clone.css({"display": "block"});

    $(clone).change(inputChanged);
    $(clone).keyup(inputChanged);
    $(clone).scroll(inputChanged);

    return clone;
  }

  $("#templateSale").parent().append(getSaleNode());

  function valueFromInput(elem){
    if(isNaN(parseFloat($(elem).val())))
      return 0;
    else return parseFloat($(elem).val());
  }

  function updateSales(){
    var needNewOne = true;

    $(".realSaleNode").each(function(){
      if($($(this).find("#itemSelect")[0]).val().toString() === "") {
        needNewOne = false;
      }
    });

    var totalMoney = 0;
    var totalItems = 0;

    $(".realSaleNode").each(function(){
      var numOfItems = parseFloat($($(this).find("#numOfItems")[0]).val());
      var priceOfItem = parseFloat($($(this).find("#priceOfItem")[0]).val());
      var itemToBuy = $($(this).find("#itemSelect")[0]).val();

      if(!isNaN(numOfItems) && !isNaN(priceOfItem) && itemToBuy !== ""){
        $($(this).find("#totalCost")[0]).val((numOfItems * priceOfItem).toFixed(2));

        var cashMade = numOfItems * priceOfItem;
        totalMoney += cashMade;
        totalItems += numOfItems;
      }
    });

    if(totalMoney > 0 && totalItems > 0){
      $("#totalSalesItems").val(totalItems);
      $("#totalSalesMoney").val(totalMoney.toFixed(2));
    }

    if(needNewOne){
      $("#templateSale").parent().append(getSaleNode());
    }
  }

  function inputChanged(){
    var startTotalCount = 0;
    var startTotalCountValue = 0;

    var endTotalCount = 0;
    var endTotalCountValue = 0;

    console.log("Value changed");

    //Update all values
    $(".col-sm-3 input").each(function(){

      //Get input where they enter number of bills
      var parentInput = $($(this).parent().parent().children(".col-sm-4")[0]).children("input")[0];
      var amountOfBills = parseInt($(parentInput).val());
      var multiplier = parseFloat($(this).attr("scale")); //Value of this bill or coin

      //Adding Placeholder if there is no value there
      if(isNaN(amountOfBills)) {
        $(parentInput).val("");
        $(parentInput).attr("placeholder", "-");
      }

      //Adding to final/total count
      if(!isNaN(amountOfBills) && !isNaN(multiplier)) {
        if ($(parentInput).attr("id").toString().indexOf("start") !== -1) {
          startTotalCount += amountOfBills;
          startTotalCountValue += (amountOfBills * multiplier);
        } else if ($(parentInput).attr("id").toString().indexOf("end") !== -1) {
          endTotalCount += amountOfBills;
          endTotalCountValue += (amountOfBills * multiplier);
        }
      }

      if(amountOfBills && multiplier) {
        $(this).val((amountOfBills * multiplier).toFixed(2));
      }else $(this).attr("placeholder", "-");
    });

    //Starting Count of bills
    var startOnesCount = valueFromInput($("#startOnes"));
    var startFivesCount = valueFromInput($("#startFives"));
    var startTensCount = valueFromInput($("#startTens"));
    var startTwentiesCount = valueFromInput($("#startTwenties"));

    //Starting total values of bills
    var startOnesCountValue = valueFromInput($("#startOnesValue"));
    var startFivesCountValue = valueFromInput($("#startFivesValue"));
    var startTensCountValue = valueFromInput($("#startTensValue"));
    var startTwentiesCountValue = valueFromInput($("#startTwentiesValue"));

    //Setting the totals for the bills
    $("#startTotalBills").val((startOnesCount + startFivesCount + startTensCount + startTwentiesCount).toFixed(0));
    $("#startTotalBillsValue").val((startOnesCountValue + startFivesCountValue + startTensCountValue + startTwentiesCountValue).toFixed(2));

    //Starting Count of Pennies
    var startPenniesCount = valueFromInput($("#startPennies"));
    var startNickelsCount = valueFromInput($("#startNickels"));
    var startDimesCount = valueFromInput($("#startDimes"));
    var startQuartersCount = valueFromInput($("#startQuarters"));

    //Starting total values of coins
    var startPenniesCountValue = valueFromInput($("#startPenniesValue"));
    var startNickelsCountValue = valueFromInput($("#startNickelsValue"));
    var startDimesCountValue = valueFromInput($("#startDimesValue"));
    var startQuartersCountValue = valueFromInput($("#startQuartersValue"));

    //Setting the totals for the coins
    $("#startTotalCoins").val((startPenniesCount + startNickelsCount + startDimesCount + startQuartersCount).toFixed(0));
    $("#startTotalCoinsValue").val((startPenniesCountValue + startNickelsCountValue + startDimesCountValue + startQuartersCountValue).toFixed(2));

    //The total of everything for the starting
    $("#startTotalCountAll").val(startTotalCount.toFixed(0));
    $("#startTotalValueAll").val(startTotalCountValue.toFixed(2));

    //ending Count of bills
    var endOnesCount = valueFromInput($("#endOnes"));
    var endFivesCount = valueFromInput($("#endFives"));
    var endTensCount = valueFromInput($("#endTens"));
    var endTwentiesCount = valueFromInput($("#endTwenties"));

    //ending total values of bills
    var endOnesCountValue = valueFromInput($("#endOnesValue"));
    var endFivesCountValue = valueFromInput($("#endFivesValue"));
    var endTensCountValue = valueFromInput($("#endTensValue"));
    var endTwentiesCountValue = valueFromInput($("#endTwentiesValue"));

    //Setting the totals for the bills
    $("#endTotalBills").val((endOnesCount + endFivesCount + endTensCount + endTwentiesCount).toFixed(0));
    $("#endTotalBillsValue").val((endOnesCountValue + endFivesCountValue + endTensCountValue + endTwentiesCountValue).toFixed(2));

    //ending Count of Pennies
    var endPenniesCount = valueFromInput($("#endPennies"));
    var endNickelsCount = valueFromInput($("#endNickels"));
    var endDimesCount = valueFromInput($("#endDimes"));
    var endQuartersCount = valueFromInput($("#endQuarters"));

    //ending total values of coins
    var endPenniesCountValue = valueFromInput($("#endPenniesValue"));
    var endNickelsCountValue = valueFromInput($("#endNickelsValue"));
    var endDimesCountValue = valueFromInput($("#endDimesValue"));
    var endQuartersCountValue = valueFromInput($("#endQuartersValue"));

    //Setting the totals for the coins
    $("#endTotalCoins").val((endPenniesCount + endNickelsCount + endDimesCount + endQuartersCount).toFixed(0));
    $("#endTotalCoinsValue").val((endPenniesCountValue + endNickelsCountValue + endDimesCountValue + endQuartersCountValue).toFixed(2));

    //The total of everything for the ending
    $("#endTotalCountAll").val(endTotalCount.toFixed(0));
    $("#endTotalValueAll").val(endTotalCountValue.toFixed(2));

    updateSales();
  }

  function updateNames() {
    console.log("Updating names");

    if ($("#periodInput").val() !== lastPeriod) {

      lastPeriod = $("#periodInput").val();
      $.get("/getstudents", {period: $("#periodInput").val()}, function (data) {
        var json = $.parseJSON(data);
        console.log(data);

        $("#namesTBody").fadeOut(500, function () {
          $(this).empty();

          for (var i = 0; i < json.length; i++) {

            var tr = document.createElement("tr");

            var td = document.createElement("td");
            td.innerHTML = "<div class='checkbox'><label><input id='" + json[i].name + "' class='nameCheck' type='checkbox'>" + json[i].name + "</label></div>";

            tr.appendChild(td);

            $("#namesTBody").append($(tr));
          }

          $(this).fadeIn(500);
        });
      });
    }
  }

  document.addEventListener("DOMContentLoaded", function() {
    $(".form-control").change(inputChanged);
    $(".form-control").keyup(inputChanged);

    $("#periodInput").change(updateNames);
    $("#periodInput").keyup(updateNames);
    $("#periodInput").scroll(updateNames);
  });

  document.getElementById("submitButton").onclick = submit;
</script>

</body>
</html>
