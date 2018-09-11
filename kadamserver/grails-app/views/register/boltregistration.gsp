<%@ page import="grails.converters.JSON" %>
<%@ page import="streama.Settings" %>
<%@ page import="java.util.*" %>
<%@ page import="java.security.*" %>

<%

	String merchant_key="dKqf7Mff";
	String salt="haqtx6QnvO";
	String action1 ="";
	String base_url="https://sandboxsecure.payu.in";
	int error=0;
	String hashString="";




	Enumeration paramNames = request.getParameterNames();
	Map<String,String> params= new HashMap<String,String>();
    	while(paramNames.hasMoreElements())
	{
      		String paramName = (String)paramNames.nextElement();

      		String paramValue = request.getParameter(paramName);

		params.put(paramName,paramValue);
	}
	String txnid ="";
	if(params.get("txnid")== null || params.get("txnid").trim().equals("")){
		Random rand = new Random();
		String rndm = Integer.toString(rand.nextInt())+(System.currentTimeMillis() / 1000L);
		String type="SHA-256";
		String str=rndm;
		byte[] hashseq=str.getBytes();
		StringBuffer hexString = new StringBuffer();
		try{
		MessageDigest algorithm = MessageDigest.getInstance(type);
		algorithm.reset();
		algorithm.update(hashseq);
		byte[] messageDigest = algorithm.digest();

		for (int i=0;i<messageDigest.length;i++) {
			String hex=Integer.toHexString(0xFF & messageDigest[i]);
			if(hex.length()==1) hexString.append("0");
			hexString.append(hex);
		}

		}catch(NoSuchAlgorithmException nsae){ }
		
		txnid=hexString.toString().substring(0,20);
	}
	else
		txnid=params.get("txnid");
    udf2 = txnid;
    params.put("txnid",txnid);
    params.put("udf2",udf2);
	String hash="";
	String hashSequence = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10";
	println hash+" "+key+txnid+amount+firstname+email+phone+productinfo+surl+furl+service_provider
	if((params.get("hash")== null || params.get("hash").trim().equals("")) && params.size()>0)
	{
		if( (params.get("key")== null || params.get("key").trim().equals(""))
			|| (params.get("txnid")== null || params.get("txnid").trim().equals(""))
			|| (params.get("amount")== null || params.get("amount").trim().equals(""))
			|| (params.get("firstname")== null || params.get("firstname").trim().equals(""))
			|| (params.get("email")== null || params.get("email").trim().equals(""))
			|| (params.get("phone")== null || params.get("phone").trim().equals(""))
			|| (params.get("productinfo")== null || params.get("productinfo").trim().equals(""))
			|| (params.get("surl")== null || params.get("surl").trim().equals(""))
			|| (params.get("furl")== null || params.get("furl").trim().equals(""))
			|| (params.get("service_provider")== null || params.get("service_provider").trim().equals(""))
		  )

			error=1;
		else{
			String[] hashVarSeq=hashSequence.split("\\|");

			for(String part : hashVarSeq)
			{
				hashString=(params.get(part)== null || params.get(part).trim().equals(""))?hashString.concat(""):hashString.concat(params.get(part));
				hashString=hashString.concat("|");
			}
			hashString=hashString.concat(params.get("salt"));

String type="SHA-512";
		String str=hashString;

			byte[] hashseq=str.getBytes();
		StringBuffer hexString = new StringBuffer();
		try{
		MessageDigest algorithm = MessageDigest.getInstance(type);
		algorithm.reset();
		algorithm.update(hashseq);
		byte[] messageDigest = algorithm.digest();

		for (int i=0;i<messageDigest.length;i++) {
			String hex=Integer.toHexString(0xFF & messageDigest[i]);
			if(hex.length()==1) hexString.append("0");
			hexString.append(hex);
		}

		}catch(NoSuchAlgorithmException nsae){ }

			 hash=hexString.toString();
			action1=base_url.concat("/_payment");
			
			println hash+action1
		}
	}
	else if(!(params.get("hash")== null || params.get("hash").trim().equals("")))
	{
		hash=params.get("hash");
		action1=base_url.concat("/_payment");
	}


%>
<!doctype html>
<html lang="en" class="no-js">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<title>${Settings.findByName('title').value}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1"/>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>

<!-- this meta viewport is required for BOLT //-->
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" >
<!-- BOLT Sandbox/test //-->
<script id="bolt" src="https://sboxcheckout-static.citruspay.com/bolt/run/bolt.min.js" bolt-
color="e34524" bolt-logo="http://boltiswatching.com/wp-content/uploads/2015/09/Bolt-Logo-e14421724859591.png"></script>
<!-- BOLT Production/Live //-->
<!--// script id="bolt" src="https://checkout-static.citruspay.com/bolt/run/bolt.min.js" bolt-color="e34524" bolt-logo="http://boltiswatching.com/wp-content/uploads/2015/09/Bolt-Logo-e14421724859591.png"></script //-->

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

        <form action="#" id='paymentForm' class='cssform form-horizontal' autocomplete='off'>
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
              <input type="email" name="email" class="form-control" placeholder="Email" value="<%= email %>"/>
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
              <input type="text" name='firstname' class="form-control" placeholder="{{'PROFIlE.FULL_NAME' | translate}}" value="<%= firstname %>"/>
            </div>
          </div>

          <div class="form-group">
          <div class="col-sm-4">
          <label class="control-label">Phone</label>
        </div>
            <div class="col-sm-5">
              <input type="tel" name='phone' class="form-control" placeholder="Phone" value="<%= phone %>"/>
            </div>
          </div>

          <div class="form-group">
          <div class="col-sm-4">
          <label class="control-label">Select Plan</label>
        </div>
            <div class="col-sm-5">
          <select name="amount" class="form-control" value="<%= amount %>">
		  <option value="100">1 month plan - 100 Rs</option>
		  <option value="500">6 month plan - 500 Rs</option>
		  <option value="1000">1 year plan - 1000 Rs</option>
		  </select>
		  </div>
          </div>

          <input type="hidden" name="key" value="<%= merchant_key %>" />
            <input type="hidden" name="hash_string" value="<%= hashString %>" />
            <input type="hidden" name="hash" value="<%= hash %>"/>

            <input type="hidden" name="txnid" value="<%= txnid %>"/>
            <input type="hidden" name="productinfo" value="1 month plan"/>

          <input type="hidden" name="surl" value="http://www.kadam-app.in/register/show"/>
          <input type="hidden" name="furl" value="http://www.kadam-app.in/register/error"/>
          <input type="hidden" name="curl" value="http://www.kadam-app.in/register/show" />
          <input type="hidden" name="service_provider" value="payu_paisa" />

          <span>

            <button onclick="launchBOLT(); return false;" class="btn btn-primary pull-right" style="background: #f48729; border-color: #f48729; opacity: 0.53; filter: Alpha(opacity=53);">{{'REGISTER.SUBMIT' | translate}} &nbsp; <i class="ion-chevron-right"></i></button></span>
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
      document.forms['paymentForm'].elements['email'].focus();
    })();

    angular.module('streama.translations').controller('authController', function ($translate) {
      var sessionExpired = ${params.sessionExpired?"true":"false"};
      if(sessionExpired){
        alertify.log($translate.instant('LOGIN.SESSION_EXPIRED'));
      }
    })
    // -->
  </script>

  <script type="text/javascript"><!--
$('#paymentForm').bind('keyup blur', function(){
	$.ajax({
          url: 'http://www.kadam-app.in/register/show',
          type: 'post',
          data: JSON.stringify({
            key: $('input[name="key"]').val(),
			txnid: $('input[name="txnid"]').val(),
			hash: $('input[name="hash"]').val(),
			amount: $('input[name="amount"]').val(),
		    productinfo: $('input[name="productinfo"]').val(),
            firstname: $('input[name="firstname"]').val(),
			email: $('input[name="email"]').val(),
			phone: $('input[name="phone"]').val(),
			udf2: $('input[name="txnid"]').val()
          }),
		  contentType: "application/json",
          dataType: 'json',
          success: function(json) {
            if (json['error']) {
			 $('#alertinfo').html('<i class="fa fa-info-circle"></i>'+json['error']);
            }
			else if (json['success']) {
				$('#hash').val(json['success']);
            }
          }
        });
});
//-->
</script>
<script type="text/javascript"><!--
function launchBOLT()
{
	bolt.launch({
	key: $('input[name="key"]').val(),
	txnid: $('input[name="txnid"]').val(),
	hash: $('input[name="hash"]').val(),
	amount: $('input[name="amount"]').val(),
	firstname: $('input[name="firstname"]').val(),
	email: $('input[name="email"]').val(),
	phone: $('input[name="phone"]').val(),
	productinfo: $('input[name="productinfo"]').val(),
	udf2: $('input[name="txnid"]').val(),
	surl : $('input[name="surl"]').val(),
	furl: $('input[name="furl"]').val(),
	mode: 'dropout'
},{ responseHandler: function(BOLT){
	console.log( BOLT.response.txnStatus );
	if(BOLT.response.txnStatus != 'CANCEL')
	{
		//Salt is passd here for demo purpose only. For practical use keep salt at server side only.
		var fr = '<form action=\"'+$('#surl').val()+'\" method=\"post\">' +
		'<input type=\"hidden\" name=\"key\" value=\"'+BOLT.response.key+'\" />' +
		'<input type=\"hidden\" name=\"txnid\" value=\"'+BOLT.response.txnid+'\" />' +
		'<input type=\"hidden\" name=\"amount\" value=\"'+BOLT.response.amount+'\" />' +
		'<input type=\"hidden\" name=\"productinfo\" value=\"'+BOLT.response.productinfo+'\" />' +
		'<input type=\"hidden\" name=\"firstname\" value=\"'+BOLT.response.firstname+'\" />' +
		'<input type=\"hidden\" name=\"email\" value=\"'+BOLT.response.email+'\" />' +
		'<input type=\"hidden\" name=\"udf2\" value=\"'+BOLT.response.udf2+'\" />' +
		'<input type=\"hidden\" name=\"mihpayid\" value=\"'+BOLT.response.mihpayid+'\" />' +
		'<input type=\"hidden\" name=\"status\" value=\"'+BOLT.response.status+'\" />' +
		'<input type=\"hidden\" name=\"hash\" value=\"'+BOLT.response.hash+'\" />' +
		'</form>';
		var form = jQuery(fr);
		jQuery('body').append(form);
		form.submit();
	}
},
	catchException: function(BOLT){
 		alert( BOLT.message );
	}
});
}
//--
</script>

</body>
</html>
