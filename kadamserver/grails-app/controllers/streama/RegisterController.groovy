package streama


import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityUtils
import org.springframework.security.access.annotation.Secured
import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.AuthenticationTrustResolver
import org.springframework.security.authentication.CredentialsExpiredException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
import org.springframework.security.core.Authentication
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.WebAttributes

import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession
import javax.servlet.http.Cookie

import java.util.Map
import java.util.Random
import java.util.Enumeration
import java.util.HashMap
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

@Secured('permitAll')
class RegisterController {

  /** Dependency injection for the authenticationTrustResolver. */
  AuthenticationTrustResolver authenticationTrustResolver

  /** Dependency injection for the springSecurityService. */
  def springSecurityService

  /** Dependency injection for the settingsService. */
  def settingsService
  
  def error

  def register() {
	def username = params.username
    def isInvite = true
    def result = [:]

    if (User.findByUsername(username)) {
      String message = "Username already exists."
      String usernamespanclass = "ion-close form-control-feedback"
      String postUrl = request.contextPath + '/register/register'
      render view: 'registration', model: [postUrl: postUrl, message: message, 
      usernamespanclass: usernamespanclass]
    } else {
    	if (params.password != params.password2) {
                String message = "Passwords do not match"
                String passwordspanclass = "ion-close form-control-feedback"
                String password2spanclass = "ion-close form-control-feedback"
                String postUrl = request.contextPath + '/register/register'
    			render view: 'registration', model: [postUrl: postUrl, message: message, 
    			passwordspanclass: passwordspanclass, password2spanclass: password2spanclass]
            }
            else {
            	String usernamespanclass = "ion-checkmark form-control-feedback"
            	String passwordspanclass = "ion-checkmark form-control-feedback"
            	String password2spanclass = "ion-checkmark form-control-feedback"
            	User user = new User(
                        username: params.username,
                        password: params.password,
                        fullName: params.firstname
                )
                user.validate()
			    if (user.hasErrors()) {
			      render status: NOT_ACCEPTABLE
			      return
			    }
			
			    user.save flush: true
			
			    UserRole.removeAll(user)
			    
			    Cookie cookie = new Cookie("myCookie",username)
				cookie.maxAge = 100
				response.addCookie(cookie)
			    
			    response.setHeader 'Authorization' , 'D2GolFkwmvomSHkZ9GAVMQq2soPOtBixMj2E3Sb5IxI='
			    
			    pay(request, response)
			    /** redirect(url: "https://www.payumoney.com/sandbox/paybypayumoney/#/898B9046B7F1201205DA2DBCC4083632")
			     redirect(url: "https://www.payumoney.com/paybypayumoney/#/0777B13D79F428A2793B1D81AAD66355") */
            }
    }
  }
  
  public boolean empty(String s) {
        if (s == null || s.trim().equals("")) {
            return true;
        } else {
            return false;
        }
    }

    public String hashCal(String type, String str) {
        byte[] hashseq = str.getBytes();
        StringBuffer hexString = new StringBuffer();
        try {
            MessageDigest algorithm = MessageDigest.getInstance(type);
            algorithm.reset();
            algorithm.update(hashseq);
            byte messageDigest[] = algorithm.digest();
            for (int i = 0; i < messageDigest.length; i++) {
                String hex = Integer.toHexString(0xFF & messageDigest[i]);
                if (hex.length() == 1) {
                    hexString.append("0");
                }
                hexString.append(hex);
            }

        } catch (NoSuchAlgorithmException nsae) {
        }
        return hexString.toString();
    }

    public Map<String, String> hashCalMethod(HttpServletRequest request, HttpServletResponse response)
            {
        response.setContentType("text/html;charset=UTF-8");
		String key = "";
        String salt = "haqtx6QnvO";
        String action1 = "";
        String base_url = "https://sandboxsecure.payu.in";
        error = 0;
        String hashString = "";
        Enumeration paramNames = request.getParameterNames();
        Map<String, String> tempparams = new HashMap<String, String>();
        Map<String, String> urlParams = new HashMap<String, String>();
        while (paramNames.hasMoreElements()) {
            String paramName = (String) paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            tempparams.put(paramName, paramValue);
        }
        String txnid = "";
        if (empty(tempparams.get("txnid"))) {
            Random rand = new Random();
            String rndm = Integer.toString(rand.nextInt()) + (System.currentTimeMillis() / 1000L);
            txnid = rndm;
            tempparams.remove("txnid");
            tempparams.put("txnid", txnid);
            txnid = hashCal("SHA-256", rndm).substring(0, 20);
        } else {
            txnid = tempparams.get("txnid");
        }
        
        String amount = tempparams.get("amount")
        
        if("100".equals(amount)) {
        tempparams.put("productinfo", "1 month plan")
        } else if("500".equals(amount)) {
        tempparams.put("productinfo", "6 month plan")
        } else if("1000".equals(amount)) {
        tempparams.put("productinfo", "1 year plan")
        }
        
        tempparams.put("email", params.username)
        
        String txn = "abcd";
        String hash = "";
        String otherPostParamSeq = "phone|surl|furl|lastname|curl|address1|address2|city|state|country|zipcode|pg";
        String hashSequence = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10";
        if (empty(tempparams.get("hash")) && tempparams.size() > 0) {
            if (empty(tempparams.get("key")) || empty(txnid) || empty(tempparams.get("amount")) || empty(tempparams.get("firstname")) || empty(tempparams.get("email")) || empty(tempparams.get("phone")) || empty(tempparams.get("productinfo")) || empty(tempparams.get("surl")) || empty(tempparams.get("furl")) || empty(tempparams.get("service_provider"))) {
                error = 1;
            } else {
                
                String[] hashVarSeq = hashSequence.split("\\|");
                for (String part : hashVarSeq) {
                    if (part.equals("txnid")) {
                        hashString = hashString + txnid;
                        urlParams.put("txnid", txnid);
                    } else {
                        hashString = (empty(tempparams.get(part))) ? hashString.concat("") : hashString.concat(tempparams.get(part).trim());
                        urlParams.put(part, empty(tempparams.get(part)) ? "" : tempparams.get(part).trim());
                    }
                    hashString = hashString.concat("|");
                }
                hashString = hashString.concat(salt);
                hash = hashCal("SHA-512", hashString);
                action1 = base_url.concat("/_payment");
                String[] otherPostParamVarSeq = otherPostParamSeq.split("\\|");
                for (String part : otherPostParamVarSeq) {
                    urlParams.put(part, empty(tempparams.get(part)) ? "" : tempparams.get(part).trim());
                }

            }
        } else if (!empty(tempparams.get("hash"))) {
            hash = tempparams.get("hash");
            action1 = base_url.concat("/_payment");
        }

        urlParams.put("hash", hash);
        urlParams.put("action", action1);
        urlParams.put("hashString", hashString);
        return urlParams;
    }
    
    def pay(HttpServletRequest request, HttpServletResponse response) {
    	Map<String, String> values = hashCalMethod(request, response);
        PrintWriter writer = response.getWriter();
// build HTML code
        String htmlResponse = "<html> <body> \n"
                + "      \n"
                + "  \n"
                + "  <h1>PayUForm </h1>\n"
                + "  \n" + "<div>"
                + "        <form id=\"payuform\" action=\"" + values.get("action") + "\"  name=\"payuform\" method=POST >\n"
                + "      <input type=\"hidden\" name=\"key\" value=" + values.get("key").trim() + ">"
                + "      <input type=\"hidden\" name=\"hash\" value=" + values.get("hash").trim() + ">"
                + "      <input type=\"hidden\" name=\"txnid\" value=" + values.get("txnid").trim() + ">"
                + "      <table>\n"
                + "        <tr>\n"
                + "          <td><b>Mandatory Parameters</b></td>\n"
                + "        </tr>\n"
                + "        <tr>\n"
                + "         <td>Amount: </td>\n"
                + "          <td><input name=\"amount\" value=" + values.get("amount").trim() + " /></td>\n"
                + "          <td>First Name: </td>\n"
                + "          <td><input name=\"firstname\" id=\"firstname\" value=" + values.get("firstname").trim() + " /></td>\n"
                + "        <tr>\n"
                + "          <td>Email: </td>\n"
                + "          <td><input name=\"email\" id=\"email\" value=" + values.get("email").trim() + " /></td>\n"
                + "          <td>Phone: </td>\n"
                + "          <td><input name=\"phone\" value=" + values.get("phone") + " ></td>\n"
                + "        </tr>\n"
                + "        <tr>\n"
                + "          <td>Product Info: </td>\n"
                + "<td><input name=\"productinfo\" value=" + values.get("productinfo").trim() + " ></td>\n"
                + "        </tr>\n"
                + "        <tr>\n"
                + "          <td>Success URI: </td>\n"
                + "          <td colspan=\"3\"><input name=\"surl\"  size=\"64\" value=" + values.get("surl") + "></td>\n"
                + "        </tr>\n"
                + "        <tr>\n"
                + "          <td>Failure URI: </td>\n"
                + "          <td colspan=\"3\"><input name=\"furl\" value=" + values.get("furl") + " size=\"64\" ></td>\n"
                + "        </tr>\n"
                + "\n"
                + "        <tr>\n"
                + "          <td colspan=\"3\"><input type=\"hidden\" name=\"service_provider\" value=\"payu_paisa\" /></td>\n"
                + "        </tr>\n"
                + "             <tr>\n"
                + "          <td><b>Optional Parameters</b></td>\n"
                + "        </tr>\n"
                + "        <tr>\n"
                + "          <td>Last Name: </td>\n"
                + "          <td><input name=\"lastname\" id=\"lastname\" value=" + values.get("lastname") + " ></td>\n"
                + "          <td>Cancel URI: </td>\n"
                + "          <td><input name=\"curl\" value=" + values.get("curl") + " ></td>\n"
                + "        </tr>\n"
                + "        <tr>\n"
                + "          <td>Address1: </td>\n"
                + "          <td><input name=\"address1\" value=" + values.get("address1") + " ></td>\n"
                + "          <td>Address2: </td>\n"
                + "          <td><input name=\"address2\" value=" + values.get("address2") + " ></td>\n"
                + "        </tr>\n"
                + "        <tr>\n"
                + "          <td>City: </td>\n"
                + "          <td><input name=\"city\" value=" + values.get("city") + "></td>\n"
                + "          <td>State: </td>\n"
                + "          <td><input name=\"state\" value=" + values.get("state") + "></td>\n"
                + "        </tr>\n"
                + "        <tr>\n"
                + "          <td>Country: </td>\n"
                + "          <td><input name=\"country\" value=" + values.get("country") + " ></td>\n"
                + "          <td>Zipcode: </td>\n"
                + "          <td><input name=\"zipcode\" value=" + values.get("zipcode") + " ></td>\n"
                + "        </tr>\n"
                + "          <td>UDF1: </td>\n"
                + "          <td><input name=\"udf1\" value=" + values.get("udf1") + "></td>\n"
                + "          <td>UDF2: </td>\n"
                + "          <td><input name=\"udf2\" value=" + values.get("udf2") + "></td>\n"
                + " <td><input name=\"hashString\" value=" + values.get("hashString") + "></td>\n"
                + "          <td>UDF3: </td>\n"
                + "          <td><input name=\"udf3\" value=" + values.get("udf3") + " ></td>\n"
                + "          <td>UDF4: </td>\n"
                + "          <td><input name=\"udf4\" value=" + values.get("udf4") + " ></td>\n"
                + "          <td>UDF5: </td>\n"
               + "          <td><input name=\"udf5\" value=" + values.get("udf5") + " ></td>\n"
                 + "          <td>PG: </td>\n"
               + "          <td><input name=\"pg\" value=" + values.get("pg") + " ></td>\n"
                + "        <td colspan=\"4\"><input type=\"submit\" value=\"Submit\"  /></td>\n"
                + "      \n"
                + "    \n"
                + "      </table>\n"
                + "    </form>\n"
                + " <script> "
                + " document.getElementById(\"payuform\").submit(); "
                + " </script> "
                + "       </div>   "
                + "  \n"
                + "  </body>\n"
                + "</html>";
// return response
        writer.println(htmlResponse);
    }
  
  /** Show the login page. */
  def show() {

    /** Check if anonymous access is enabled, to avoid login 
    User anonymous = User.findByUsername("anonymous")
    springSecurityService.reauthenticate(anonymous.username,anonymous.password) **/

    def conf = getConf()

    def planMap = [:]
	planMap.put(200, '1 month - 200')
	planMap.put(1000, '6 month - 1000')
	planMap.put(2000, '1 year - 2000')

	String postUrl = request.contextPath + '/register/register'
    render view: 'registration', model: [postUrl: postUrl]
    
    /** redirect(uri: '/#/register') */
  }
  
  def success() {

    def conf = getConf()
    
    String username = g.cookie(name: 'myCookie')

	flash.message = username
    redirect action: 'auth', params: params
  }
  
  def error() {

    def conf = getConf()
    
    String username = g.cookie(name: 'myCookie')

	String postUrl = request.contextPath + '/register/register'
    render view: 'registration', model: [postUrl: postUrl, message: username]
  }

  /** The redirect action for Ajax requests. */
  def authAjax() {
    response.setHeader 'Location', conf.auth.ajaxLoginFormUrl
    render(status: HttpServletResponse.SC_UNAUTHORIZED, text: 'Unauthorized')
  }

  /** Show denied page. */
  def denied() {
    if (springSecurityService.isLoggedIn() && authenticationTrustResolver.isRememberMe(authentication)) {
      // have cookie but the page is guarded with IS_AUTHENTICATED_FULLY (or the equivalent expression)
      redirect action: 'full', params: params
      return
    }

    [gspLayout: conf.gsp.layoutDenied]
  }

  /** Login page for users with a remember-me cookie but accessing a IS_AUTHENTICATED_FULLY page. */
  def full() {
    def conf = getConf()
    render view: 'auth', params: params,
      model: [hasCookie: authenticationTrustResolver.isRememberMe(authentication),
              postUrl: request.contextPath + conf.apf.filterProcessesUrl,
              rememberMeParameter: conf.rememberMe.parameter,
              usernameParameter: conf.apf.usernameParameter,
              passwordParameter: conf.apf.passwordParameter,
              gspLayout: conf.gsp.layoutAuth]
  }

  /** Callback after a failed login. Redirects to the auth page with a warning message. */
  def authfail() {

    String msg = ''
    def exception = session[WebAttributes.AUTHENTICATION_EXCEPTION]
    if (exception) {
      if (exception instanceof AccountExpiredException) {
        msg = message(code: 'springSecurity.errors.login.expired')
      }
      else if (exception instanceof CredentialsExpiredException) {
        msg = message(code: 'springSecurity.errors.login.passwordExpired')
      }
      else if (exception instanceof DisabledException) {
        msg = message(code: 'springSecurity.errors.login.disabled')
      }
      else if (exception instanceof LockedException) {
        msg = message(code: 'springSecurity.errors.login.locked')
      }
      else {
        msg = message(code: 'springSecurity.errors.login.fail')
      }
    }

    if (springSecurityService.isAjax(request)) {
      render([error: msg] as JSON)
    }
    else {
      flash.message = msg
      redirect action: 'auth', params: params
    }
  }

  /** The Ajax success redirect url. */
  def ajaxSuccess() {
    render([success: true, username: authentication.name] as JSON)
  }

  /** The Ajax denied redirect url. */
  def ajaxDenied() {
    render([error: 'access denied'] as JSON)
  }

  protected Authentication getAuthentication() {
    SecurityContextHolder.context?.authentication
  }

  protected ConfigObject getConf() {
    SpringSecurityUtils.securityConfig
  }
}
