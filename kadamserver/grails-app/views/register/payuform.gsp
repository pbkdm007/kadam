<html>

<script>
var hash='${ tempparams.hash }';
function submitPayuForm() {
	
	if (hash == '')
		return;

      var payuForm = document.forms.payuForm;
      payuForm.submit();
    }
</script>

<body onload="submitPayuForm();">
 

<form action="${ tempparams.action }" method="post" name="payuForm">
	  <input type="hidden" name="key" value="${ tempparams.key }" />
      <input type="hidden" name="hash" value="${ tempparams.hash }"/>
      <input type="hidden" name="hashString" value="${ tempparams.hashString }"/>
      <input type="hidden" name="txnid" value="${ tempparams.txnid }" />
      <input type="hidden" name="udf2" value="${ tempparams.txnid }" />
	  <input type="hidden" name="service_provider" value="PayUPaisa" />
	  <input type="hidden" name="vendor_id" value="5434077">
	  <input type="hidden" name="user_credentials" value="PayUPaisa:15674909">
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

</body>
</html>