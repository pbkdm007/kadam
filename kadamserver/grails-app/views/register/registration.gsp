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

      <g:if test='${flash.message}'>
			  <div class='login_message'>${flash.message}</div>
			</g:if>

        <div class="modal-body">

  <form class="form-horizontal">
    <legend>
      Create User
      <div class="spinner" ng-show="loading">
        <div class="bounce1"></div>
        <div class="bounce2"></div>
        <div class="bounce3"></div>
      </div>
    </legend>

    <div class="panel panel-danger" ng-if="passwordValidationError || error">
      <div class="panel-body" ng-if="passwordValidationError">
        {{('PROFIlE.' + passwordValidationError) | translate}}
      </div>
      <div class="panel-body" ng-if="error">
        {{error}}
      </div>
    </div>

    <div ng-class="{'has-error has-feedback': error, 'has-success has-feedback': validUser}">
      <div class="form-group" >
        <div class="col-sm-3">
          <label class="control-label">Username</label>
        </div>
        <div class="col-sm-8">
          <input type="text" class="form-control" ng-model="user.username" placeholder="Username" ng-model-options="{updateOn: 'blur'}"
                 ng-change="checkAvailability(user.username)">
          <span class="ion-close form-control-feedback" ng-show="error" aria-hidden="true"></span>
          <span class="ion-checkmark form-control-feedback" ng-show="validUser" aria-hidden="true"></span>
        </div>
      </div>
    </div>

    <div ng-class="{'has-error has-feedback': !validPassword, 'has-success has-feedback': validPassword}">
      <div class="form-group" >
        <div class="col-sm-3">
          <label class="control-label">{{'PROFIlE.PASS' | translate}}</label>
        </div>
        <div class="col-sm-8">
          <input type="password" class="form-control" ng-model="user.password" placeholder="{{'PROFIlE.PASS' | translate}}"
                 ng-model-options="{updateOn: 'blur'}" ng-change="checkPassword(user.password, user.passwordRepeat)">
          <span class="ion-close form-control-feedback" ng-show="!validPassword" aria-hidden="true"></span>
          <span class="ion-checkmark form-control-feedback" ng-show="validPassword" aria-hidden="true"></span>
        </div>
      </div>
    </div>
    <div ng-class="{'has-error has-feedback': !validPassword, 'has-success has-feedback': validPassword}">
      <div class="form-group" >
        <div class="col-sm-3">
          <label class="control-label">{{'PROFIlE.REPEAT_PASS' | translate}}</label>
        </div>
        <div class="col-sm-8">
          <input type="password" class="form-control" ng-model="user.passwordRepeat" placeholder="{{'PROFIlE.REPEAT_PASS' | translate}}"
                 ng-model-options="{updateOn: 'blur'}" ng-change="checkPassword(user.password, user.passwordRepeat)">
          <span class="ion-close form-control-feedback" ng-show="!validPassword" aria-hidden="true"></span>
          <span class="ion-checkmark form-control-feedback" ng-show="validPassword" aria-hidden="true"></span>
        </div>
      </div>
    </div>


  </form>
</div>

<div class="modal-footer">
  <button ng-if="!user.id" class="btn btn-success" ng-disabled="(!validUser || !validPassword) && !user.id" ng-click="saveAndCreateUser(user)">Save & Create User</button>
</div>

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
