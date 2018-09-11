<html>
<head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>

<!-- this meta viewport is required for BOLT //-->
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" >
<!-- BOLT Sandbox/test //-->
<script id="bolt" src="https://sboxcheckout-static.citruspay.com/bolt/run/bolt.min.js" bolt-
color="e34524" bolt-logo="http://boltiswatching.com/wp-content/uploads/2015/09/Bolt-Logo-e14421724859591.png"></script>
<!-- BOLT Production/Live //-->
<!--// script id="bolt" src="https://checkout-static.citruspay.com/bolt/run/bolt.min.js" bolt-color="e34524" bolt-logo="http://boltiswatching.com/wp-content/uploads/2015/09/Bolt-Logo-e14421724859591.png"></script //-->

</head>

<body>
 

<form action="#" id="payment_form">
	  <input type="hidden" name="key" value="${ tempparams.key }" />
      <input type="hidden" name="hash" value="${ tempparams.hash }"/>
      <input type="hidden" name="hashString" value="${ tempparams.hashString }"/>
      <input type="hidden" name="txnid" value="${ tempparams.txnid }" />
      <input type="hidden" name="udf2" value="${ tempparams.txnid }" />
	  <input type="hidden" name="service_provider" value="payu_paisa" />
      <table>
        <tr>
        </tr>
        <tr>
          <td><input type="hidden" name="amount" value="${ tempparams.amount }" /></td>
          <td><input type="hidden" name="firstname" id="firstname" value="${ tempparams.firstname }" /></td>
        </tr>
        <tr>
          <td><input type="hidden" name="email" id="email" value="${ tempparams.email }" /></td>
          <td><input type="hidden" name="phone" value="${ tempparams.phone }" /></td>
        </tr>
        <tr>
          <td colspan="3"><input type="hidden" name="productinfo" value="${ tempparams.productinfo }" size="64" /></td>
        </tr>
        <tr>
          <td colspan="3"><input type="hidden" name="surl" value="${ tempparams.surl }" size="64" /></td>
        </tr>
        <tr>
          <td colspan="3"><input type="hidden" name="furl" value="${ tempparams.furl }" size="64" /></td>
        </tr>
        <tr>
        </tr>
        <tr>
          <td><input type="hidden" name="lastname" id="lastname" value="${ tempparams.lastname }" /></td>
          <td><input type="hidden" name="curl" value="${ tempparams.curl }" /></td>
        </tr>
        <tr>
          <td><input type="hidden" name="address1" value="${ tempparams.address1 }" /></td>
          <td><input type="hidden" name="address2" value="${ tempparams.address2 }" /></td>
        </tr>
        <tr>
          <td><input type="hidden" name="city" value="${ tempparams.city }" /></td>
          <td><input type="hidden" name="state" value="${ tempparams.state }" /></td>
        </tr>
        <tr>
          <td><input type="hidden" name="country" value="${ tempparams.country }" /></td>
          <td><input type="hidden" name="zipcode" value="${ tempparams.zipcode }" /></td>
        </tr>
        <tr>
          <td><input type="hidden" name="udf1" value="${ tempparams.udf1 }" /></td>
          
        <tr>
          <td><input type="hidden" name="udf3" value="${ tempparams.udf3 }" /></td>
          <td><input type="hidden" name="udf4" value="${ tempparams.udf4 }" /></td>
        </tr>
        <tr>
          <td><input type="hidden" name="udf5" value="${ tempparams.udf5 }" /></td>
          <td><input type="hidden" name="pg" value="${ tempparams.pg }" /></td>
        </tr>
        <tr>
          <g:if test='${tempparams.hash}'>
            <td colspan="4"><input type="submit" value="Submit" style="display:none;"/></td>
          </g:if>
        </tr>
      </table>
    </form>

<div class="spinner big" ng-show="loading">
    <div class="bounce1"></div>
    <div class="bounce2"></div>
    <div class="bounce3"></div>
  </div>

<script type="text/javascript"><!--
$('#payment_form').bind('keyup blur', function(){
	$.ajax({
          url: 'index.php',
          type: 'post',
          data: JSON.stringify({ 
            key: $('#key').val(),
			salt: $('#salt').val(),
			txnid: $('#txnid').val(),
			amount: $('#amount').val(),
		    pinfo: $('#pinfo').val(),
            fname: $('#fname').val(),
			email: $('#email').val(),
			mobile: $('#mobile').val(),
			udf5: $('#udf5').val()
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
	firstname: $('#fname').val(),
	email: $('#email').val(),
	phone: $('#mobile').val(),
	productinfo: $('#pinfo').val(),
	udf5: $('#udf5').val(),
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
		'<input type=\"hidden\" name=\"udf5\" value=\"'+BOLT.response.udf5+'\" />' +
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