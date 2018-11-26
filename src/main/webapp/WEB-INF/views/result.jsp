<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ page isELIgnored="false" %>
  <title>Face Result</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body background="resources/crowd.jpg">
 
<div class="container">
<br><br><br><br>  
<!-- <br><br><br><br> -->
<div class="row">
<div class="col-md-4">
<img src="resources/fr.png" >
<img src="resources/watson.png" >
<br>
<br><br>

<a href="./" class="btn btn-primary btn-lg" role="button"><span class="glyphicon glyphicon-home"></span> Home</a>
&nbsp;&nbsp;
<a href="/image" class="btn btn-primary btn-lg" role="button" style="float:right"> <span class="glyphicon glyphicon-picture"> </span> Try Another Image</a>

</div>
<div class="col-md-1"></div>
<div class="col-md-7">
 <div class="panel panel-primary">
    <div class="panel-heading"><h2>Name: ${img.name} </h2></div>
    <div class="panel-body" style="background:#ced9ea;">
     <div class="row">
  
  <div class="col-sm-5">
  <div class="row">
  <h3>  &nbsp Gender : ${img.gender}</h3>
  </div>
  <div class="row">
  <h3>  &nbsp Max Age : ${img.max_age}</h3>
  </div>
  <div class="row">
  <h3>  &nbsp Min Age : ${img.min_age}</h3>
  </div>
<!--   bf<br>asf<br>fedf -->
  </div>
  <div class="col-sm-4"><img src="${img.url}" style="width:304px;height:304px"></div>
  </div>
</div>

</div>
    

	</div>
  </div>
</div>

</body>
</html>
