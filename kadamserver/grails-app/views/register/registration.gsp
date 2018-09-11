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
    <div id='login' ng-app="streama.translations" class="ng-cloak" ng-controller="authController">
      <g:imgSetting class="auth-logo"  setting="${Settings.findByName('logo').value}" alt="${streama.Settings.findByName('title').value} Logo"></g:imgSetting>
			<div class='inner'>

      <g:if test='${message}'>
      <div class="panel panel-danger">
			  <div class='panel-body'><font color="#e74c3c">${message}</font></div>
			  </div>
			</g:if>

        <form action='${postUrl}' method='POST' id='registrationForm' class='cssform form-horizontal' autocomplete='off'>
	<legend>
      Register
      <div class="spinner" ng-show="loading">
        <div class="bounce1"></div>
        <div class="bounce2"></div>
        <div class="bounce3"></div>
      </div>
    </legend>
    
    <div class="${hasusernameclass}">
          <div class="form-group">
          <div class="col-sm-4">
          <label class="control-label">Username</label>
        </div>
            <div class="col-sm-5">
              <input type="email" name="username" class="form-control" placeholder="Email"/>
              <span class="${usernamespanclass}" aria-hidden="true"></span>
            </div>
          </div>
          </div>

		<div class="${haspasswordclass}">
          <div class="form-group">
          <div class="col-sm-4">
          <label class="control-label">{{'LOGIN.PASSWORD' | translate}}</label>
        </div>
            <div class="col-sm-5">
              <input type="password" name='password' class="form-control" placeholder="{{'LOGIN.PASSWORD' | translate}}"/>
              <span class="${passwordspanclass}" aria-hidden="true"></span>
            </div>
          </div>
          </div>
          
          <div class="${haspasswordclass}">
          <div class="form-group">
          <div class="col-sm-4">
          <label class="control-label">{{'PROFIlE.REPEAT_PASS' | translate}}</label>
        </div>
            <div class="col-sm-5">
              <input type="password" name='password2' class="form-control" placeholder="{{'PROFIlE.REPEAT_PASS' | translate}}"/>
              <span class="${password2spanclass}" aria-hidden="true"></span>
            </div>
          </div>
          </div>
          
          <div class="form-group">
          <div class="col-sm-4">
          <label class="control-label">{{'PROFIlE.FULL_NAME' | translate}}</label>
        </div>
            <div class="col-sm-5">
              <input type="text" name='firstname' class="form-control" placeholder="{{'PROFIlE.FULL_NAME' | translate}}"/>
            </div>
          </div>
          
          <div class="form-group">
          <div class="col-sm-4">
          <label class="control-label">Phone</label>
        </div>
            <div class="col-sm-5">
              <input type="tel" name='phone' class="form-control" placeholder="Phone"/>
            </div>
          </div>
          
          <div class="form-group">
          <div class="col-sm-4">
          <label class="control-label">Select Plan</label>
        </div>
            <div class="col-sm-5">
          <select name="amount" class="form-control">
		  <option value="100">1 month plan - 100 Rs</option>
		  <option value="500">6 month plan - 500 Rs</option>
		  <option value="1000">1 year plan - 1000 Rs</option>
		  </select>
		  </div>
          </div>
          
          <input type="hidden" name="key" value="dKqf7Mff" />
            <input type="hidden" name="hash_string" value="" />
            <input type="hidden" name="hash" />

            <input type="hidden" name="txnid"/>
          
          <input type="hidden" name="surl" value="http://www.kadam-app.in/register/success"/>
          <input type="hidden" name="furl" value="http://www.kadam-app.in/register/error"/>
          <input type="hidden" name="curl" value="http://www.kadam-app.in/register/show" />
          <input type="hidden" name="service_provider" value="payu_paisa" />
          
          <span>

            <button class="btn btn-primary pull-right" style="background: #f48729; border-color: #f48729; opacity: 0.53; filter: Alpha(opacity=53);">{{'REGISTER.SUBMIT' | translate}} &nbsp; <i class="ion-chevron-right"></i></button></span>
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
