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
      <g:imgSetting class="auth-logo"  setting="${Settings.findByName('logo').value}" alt="${streama.Settings.findByName('title').value} Logo"></g:imgSetting>
			<div class='inner'>

      <g:if test='${message}'>
			  <div class='login_message'>${message}</div>
			</g:if>

        <form action='${postUrl}' method='POST' id='registrationForm' class='cssform form-horizontal' autocomplete='off'>

          <div class="form-group">
            <div class="col-lg-12">
              <input type="text" name="username" class="form-control" placeholder="{{'LOGIN.USERNAME' | translate}}">
              <span class="${usernamespanclass}" aria-hidden="true"></span>
            </div>
          </div>

          <div class="form-group">
            <div class="col-lg-12">
              <input type="password" name='password' class="form-control" placeholder="{{'LOGIN.PASSWORD' | translate}}">
              <span class="${passwordspanclass}" aria-hidden="true"></span>
            </div>
          </div>
          
          <div class="form-group">
            <div class="col-lg-12">
              <input type="password" name='password2' class="form-control" placeholder="{{'PROFIlE.REPEAT_PASS' | translate}}">
              <span class="${password2spanclass}" aria-hidden="true"></span>
            </div>
          </div>
          
          <div class="form-group">
            <div class="col-lg-12">
              <input type="text" name='fullname' class="form-control" placeholder="{{'PROFIlE.FULL_NAME' | translate}}">
            </div>
          </div>
          
          <span>

            <button class="btn btn-primary pull-right">{{'REGISTER.SUBMIT' | translate}} &nbsp; <i class="ion-chevron-right"></i></button></span>
        </form>
      </div>
    </div>
    <div class="page-container-push"></div>
  </div>

  <g:render template="/templates/footer"></g:render>


	<asset:javascript src="vendor.js" />
	<asset:javascript src="/streama/streama.translations.js" />

  <script type='text/javascript'>
    <!--
    (function() {
      document.forms['registrationForm'].elements['username'].focus();
    })();

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
