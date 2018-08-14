<%@ page import="grails.converters.JSON" %>
<%@ page import="streama.Settings" %>
<!doctype html>
<html lang="en" class="no-js">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<title>${Settings.findByName('title').value}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1"/>

	<style type="text/css">
	[ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
		display: none !important;
	}
	
	.center {
    margin: auto;
    width: 60%;
    border: 3px solid #73AD21;
    padding: 10px;
}
	</style>

	<asset:stylesheet src="vendor.css"/>
	<asset:stylesheet src="application.css"/>

  <g:linkRelIconSetting setting="${Settings.findByName('favicon').value}"></g:linkRelIconSetting>

	<script type="text/javascript">
		window.contextPath = "${request.contextPath}";
	</script>
</head>

<body >
  <g:cssBackgroundSetting selector=".login-page" setting="${Settings.findByName('loginBackground').value}"></g:cssBackgroundSetting>
	<div class="page-container login-page">
    <div id='register' ng-app="streama.translations" class="ng-cloak" ng-controller="authController">
      <g:imgSetting class="auth-logo center"  setting="${Settings.findByName('logo').value}" alt="${streama.Settings.findByName('title').value} Logo"></g:imgSetting>
			<div class='inner center'>
		Registration Successful!
		<g:link controller="login" action="auth">Login & Enjoy</g:link>
      </div>
    </div>
    <div class="page-container-push"></div>
  </div>

  <g:render template="/templates/footer"></g:render>


	<asset:javascript src="vendor.js" />
	<asset:javascript src="/streama/streama.translations.js" />

  <script type='text/javascript'>
    <!--

    angular.module('streama.translations').controller('authController', function ($translate) {
      var sessionExpired = ${params.sessionExpired?"true":"false"};
      if(sessionExpired){
        alertify.log($translate.instant('LOGIN.SESSION_EXPIRED'));
      }
    })
    // -->
  </script>

</body>
</html>
