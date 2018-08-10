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

<body>
 

<form action="${ tempparams.action }" method="post" name="payuForm">
	  <input type="hidden" name="key" value="${ tempparams.key }" />
      <input type="hidden" name="hash" value="${ tempparams.hash }"/>
      <input type="hidden" name="hashString" value="${ tempparams.hashString }"/>
      <input type="hidden" name="txnid" value="${ tempparams.txnid }" />
      <input type="hidden" name="udf2" value="${ tempparams.txnid }" />
	  <input type="hidden" name="service_provider" value="payu_paisa" />
      <table>
        <tr>
          <td><b>Mandatory Parameters</b></td>
        </tr>
        <tr>
          <td>Amount: </td>
          <td><input type="hidden" name="amount" value="${ tempparams.amount }" /></td>
          <td>First Name: </td>
          <td><input name="firstname" id="firstname" value="${ tempparams.firstname }" /></td>
        </tr>
        <tr>
          <td>Email: </td>
          <td><input name="email" id="email" value="${ tempparams.email }" /></td>
          <td>Phone: </td>
          <td><input name="phone" value="${ tempparams.phone }" /></td>
        </tr>
        <tr>
          <td>Product Info: </td>
          <td colspan="3"><input type="hidden" name="productinfo" value="${ tempparams.productinfo }" size="64" /></td>
        </tr>
        <tr>
          <td>Success URI: </td>
          <td colspan="3"><input type="hidden" name="surl" value="${ tempparams.surl }" size="64" /></td>
        </tr>
        <tr>
          <td>Failure URI: </td>
          <td colspan="3"><input type="hidden" name="furl" value="${ tempparams.furl }" size="64" /></td>
        </tr>
        <tr>
          <td><b>Optional Parameters</b></td>
        </tr>
        <tr>
          <td>Last Name: </td>
          <td><input name="lastname" id="lastname" value="${ tempparams.lastname }" /></td>
          <td>Cancel URI: </td>
          <td><input type="hidden" name="curl" value="${ tempparams.curl }" /></td>
        </tr>
        <tr>
          <td>Address1: </td>
          <td><input name="address1" value="${ tempparams.address1 }" /></td>
          <td>Address2: </td>
          <td><input name="address2" value="${ tempparams.address2 }" /></td>
        </tr>
        <tr>
          <td>City: </td>
          <td><input name="city" value="${ tempparams.city }" /></td>
          <td>State: </td>
          <td><input name="state" value="${ tempparams.state }" /></td>
        </tr>
        <tr>
          <td>Country: </td>
          <td><input name="country" value="${ tempparams.country }" /></td>
          <td>Zipcode: </td>
          <td><input name="zipcode" value="${ tempparams.zipcode }" /></td>
        </tr>
        <tr>
          <td>UDF1: </td>
          <td><input type="hidden" name="udf1" value="${ tempparams.udf1 }" /></td>
          
        <tr>
          <td>UDF3: </td>
          <td><input type="hidden" name="udf3" value="${ tempparams.udf3 }" /></td>
          <td>UDF4: </td>
          <td><input type="hidden" name="udf4" value="${ tempparams.udf4 }" /></td>
        </tr>
        <tr>
          <td>UDF5: </td>
          <td><input type="hidden" name="udf5" value="${ tempparams.udf5 }" /></td>
          <td>PG: </td>
          <td><input type="hidden" name="pg" value="${ tempparams.pg }" /></td>
        </tr>
        <tr>
          <g:if test='${tempparams.hash}'>
            <td colspan="4"><input type="submit" value="Submit" /></td>
          </g:if>
        </tr>
      </table>
    </form>


</body>
</html>