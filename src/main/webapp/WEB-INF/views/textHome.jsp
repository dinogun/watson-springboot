<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Text To Speech</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body background="resources/textbg.jpg">
	<br>
	<br>

	<div class="container-fluid">
		<div class="row">
			<div class="col-sm-3 col-md-3"></div>
			<div class="col-sm-6 col-md-6">
				<img src="resources/TTStag.png">
			</div>
			<div class="col-sm-3 col-md-3"></div>
		</div>

		<div class="row">

			<div class="col-sm-1 col-md-1"></div>
			<div class="col-sm-4 col-md-4">
				<div class="panel  panel-primary">
					<div class="panel-heading" style="background: #800080;">
						<h4>Enter The Text</h4>
					</div>
					<div class="panel-body">
						<form:form class="form-inline" method="post">
							<div class="form-group">
								<form:textarea path="text" rows="10" cols="49"
									class="form-control" />
							</div>
						</form:form>
						<br>
						<div align="center">
							<button class="btn btn-primary btn-lg speak-button">
								<span class="glyphicon glyphicon-volume-up"></span> Speak
							</button>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<button class="btn btn-primary btn-lg download-button">
								<span class="glyphicon glyphicon-download-alt"></span> Download
							</button>
						</div>
					</div>
				</div>
			</div>
			<div class="col-sm-3 col-md-3">
				<img src="resources/speaker.png" height="300" width="300">
			</div>
			<div class="col-sm-3 col-md-3">
				<div class="panel  panel-primary">
					<div class="panel-heading" style="background: #800080;">
						<h4>Output</h4>
					</div>
					<div class="panel-body">
						<div style="display: none" class=" audiodiv">
							<audio autoplay type="audio/wav" preload="auto" autobuffer
								controls class="audio"></audio>
						</div>
						<div style="display: none" class=" error">
							<div class="form-group row">
								<p class="errorMsg">Error processing the request.</p>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
		<div class="row">
			<div class="col-sm-6 col-md-6"></div>
			<div class="col-sm-1 col-md-1">
				<a href="./" class="btn btn-primary btn-lg" role="button"><span class="glyphicon glyphicon-home"></span><b> Home</b></a>
			</div>
			<div class="col-sm-5 col-md-5"></div>

		</div>
	</div>

	<script>
		$(document).ready(
				function() {
					var audio = $('.audio').get(0);

					$('.speak-button').click(
							function() {
								$('.error').hide();
								if($('#text').val().length!=0){
								$('.audiodiv').show();
								audio.setAttribute('src', 'textprocess' + '?&'
										+ $('form').serialize());
							}
							});

					$('.download-button').click(
							function() {
								$('.error').hide();
								if($('#text').val().length!=0){
								window.location.href = 'textprocess'
										+ '?download=true&'
										+ $('form').serialize();
								}
							});

					$('.audio').on('error', function() {
						$('.audio').hide();
						$('.errorMgs').text('Error processing the request.');
						$('.errorMsg').css('color', 'red');
						$('.error').show();
					});

				});
	</script>
</body>
</html>