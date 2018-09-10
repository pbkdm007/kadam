<%@ page import="grails.converters.JSON" %>
<%@ page import="streama.Settings" %>
<%@ page import="java.util.*" %>
<%@ page import="java.security.*" %>

<%!
public boolean empty(String s)
	{
		if(s== null || s.trim().equals(""))
			return true;
		else
			return false;
	}
%>
<%!
	public String hashCal(String type,String str){
		byte[] hashseq=str.getBytes();
		StringBuffer hexString = new StringBuffer();
		try{
		MessageDigest algorithm = MessageDigest.getInstance(type);
		algorithm.reset();
		algorithm.update(hashseq);
		byte messageDigest[] = algorithm.digest();
            
		

		for (int i=0;i<messageDigest.length;i++) {
			String hex=Integer.toHexString(0xFF & messageDigest[i]);
			if(hex.length()==1) hexString.append("0");
			hexString.append(hex);
		}
			
		}catch(NoSuchAlgorithmException nsae){ }
		
		return hexString.toString();


	}
%>
<% 	
	String merchant_key="";
	String salt="";
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
	if(empty(params.get("txnid"))){
		Random rand = new Random();
		String rndm = Integer.toString(rand.nextInt())+(System.currentTimeMillis() / 1000L);
		txnid=hashCal("SHA-256",rndm).substring(0,20);
	}
	else
		txnid=params.get("txnid");
    udf2 = txnid;
    params.put("txnid",txnid);
    params.put("udf2",udf2);
	String hash="";
	String hashSequence = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10";
	if(empty(params.get("hash")) && params.size()>0)
	{
		if( empty(params.get("key"))
			|| empty(params.get("txnid"))
			|| empty(params.get("amount"))
			|| empty(params.get("firstname"))
			|| empty(params.get("email"))
			|| empty(params.get("phone"))
			|| empty(params.get("productinfo"))
			|| empty(params.get("surl"))
			|| empty(params.get("furl"))
			|| empty(params.get("service_provider"))
	)
			
			error=1;
		else{
			String[] hashVarSeq=hashSequence.split("\\|");
			
			for(String part : hashVarSeq)
			{
				hashString= (empty(params.get(part)))?hashString.concat(""):hashString.concat(params.get(part));
				hashString=hashString.concat("|");
			}
			hashString=hashString.concat(params.get("salt"));
			

			 hash=hashCal("SHA-512",hashString);
			action1=base_url.concat("/_payment");
		}
	}
	else if(!empty(params.get("hash")))
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

        <form action="#" id='registrationForm' class='cssform form-horizontal' autocomplete='off'>
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
          
          <input type="hidden" name="key" value="gtKFFx" />
          <input type="hidden" name="salt" value="eCwWELxi" />
            <input type="hidden" name="hash_string" value="" />
            <input type="hidden" name="hash" />

            <input type="hidden" name="txnid"/>
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
  
  <script type="text/javascript"><!--
$('#registrationForm').bind('keyup blur', function(){
	$.ajax({
          url: 'index.php',
          type: 'post',
          data: JSON.stringify({ 
            key: $('#key').val(),
			salt: $('#salt').val(),
			txnid: $('#txnid').val(),
			amount: $('#amount').val(),
		    productinfo: $('#productinfo').val(),
            firstname: $('#firstname').val(),
			email: $('#email').val(),
			phone: $('#phone').val(),
			udf2: $('#udf2').val()
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
	key: $('#key').val(),
	txnid: $('#txnid').val(), 
	hash: $('#hash').val(),
	amount: $('#amount').val(),
	firstname: $('#firstname').val(),
	email: $('#email').val(),
	phone: $('#phone').val(),
	productinfo: $('#productinfo').val(),
	udf2: $('#udf2').val(),
	surl : $('#surl').val(),
	furl: $('#surl').val(),
	mode: 'dropout'	
},{ responseHandler: function(BOLT){
	console.log( BOLT.response.txnStatus );		
	if(BOLT.response.txnStatus != 'CANCEL')
	{
		//Salt is passd here for demo purpose only. For practical use keep salt at server side only.
		var fr = '<form action=\"'+$('#surl').val()+'\" method=\"post\">' +
		'<input type=\"hidden\" name=\"key\" value=\"'+BOLT.response.key+'\" />' +
		'<input type=\"hidden\" name=\"salt\" value=\"'+$('#salt').val()+'\" />' +
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
