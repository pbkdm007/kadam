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

import javax.servlet.http.HttpServletRequest
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
	String username = params.username
    def isInvite = true
    def result = [:]
    
    if(empty(username))
    {
      String message = "Please enter valid username."
      String usernamespanclass = "ion-close form-control-feedback"
      String hasusernameclass = "has-error has-feedback"
      String postUrl = request.contextPath + '/register/register'
      render view: 'registration', model: [postUrl: postUrl, message: message, 
      usernamespanclass: usernamespanclass, hasusernameclass: hasusernameclass]
      return
    }

    if (User.findByUsername(username)) {
      String message = "Username already exists."
      String usernamespanclass = "ion-close form-control-feedback"
      String hasusernameclass = "has-error has-feedback"
      String postUrl = request.contextPath + '/register/register'
      render view: 'registration', model: [postUrl: postUrl, message: message, 
      usernamespanclass: usernamespanclass, hasusernameclass: hasusernameclass]
    } else {
    String hasusernameclass = "has-success has-feedback"
    		if (empty(params.password) || empty(params.password2)) {
    			String message = "The password can not be empty"
    			String passwordspanclass = "ion-close form-control-feedback"
                String password2spanclass = "ion-close form-control-feedback"
                String haspasswordclass = "has-error has-feedback"
                String postUrl = request.contextPath + '/register/register'
    			render view: 'registration', model: [postUrl: postUrl, message: message, 
    			passwordspanclass: passwordspanclass, password2spanclass: password2spanclass, 
    			hasusernameclass: hasusernameclass, haspasswordclass: haspasswordclass]
    		}
    		else if (params.password.size() < 6) {
    			String message = "The password must be at least 6 characters long"
    			String passwordspanclass = "ion-close form-control-feedback"
                String password2spanclass = "ion-close form-control-feedback"
                String haspasswordclass = "has-error has-feedback"
                String postUrl = request.contextPath + '/register/register'
    			render view: 'registration', model: [postUrl: postUrl, message: message, 
    			passwordspanclass: passwordspanclass, password2spanclass: password2spanclass, 
    			hasusernameclass: hasusernameclass, haspasswordclass: haspasswordclass]
    		}
    		else if (params.password != params.password2) {
                String message = "The passwords need to match"
                String passwordspanclass = "ion-close form-control-feedback"
                String password2spanclass = "ion-close form-control-feedback"
                String haspasswordclass = "has-error has-feedback"
                String postUrl = request.contextPath + '/register/register'
    			render view: 'registration', model: [postUrl: postUrl, message: message, 
    			passwordspanclass: passwordspanclass, password2spanclass: password2spanclass, 
    			hasusernameclass: hasusernameclass, haspasswordclass: haspasswordclass]
            }
            else if(!"100".equals(params.amount) && !"500".equals(params.amount) && !"1000".equals(params.amount)) {
            	String message = "The selected plan is invalid"
            	String postUrl = request.contextPath + '/register/register'
    			render view: 'registration', model: [postUrl: postUrl, message: message]
            }
            else {
            	String usernamespanclass = "ion-checkmark form-control-feedback"
            	String passwordspanclass = "ion-checkmark form-control-feedback"
            	String password2spanclass = "ion-checkmark form-control-feedback"
            	String haspasswordclass = "has-success has-feedback"
            	User user = new User(
                        username: params.username,
                        password: params.password,
                        fullName: params.firstname,
                        phone: params.phone
                )
                user.validate()
			    if (user.hasErrors()) {
			      render status: NOT_ACCEPTABLE
			      return
			    }
			
			    user.save flush: true
			
			    UserRole.removeAll(user)
			    
			    Cookie cookie = new Cookie("myCookie",username)
				cookie.maxAge = -1
				response.addCookie(cookie)
			    
			    //response.setHeader 'Authorization' , 'D2GolFkwmvomSHkZ9GAVMQq2soPOtBixMj2E3Sb5IxI='
			    
			    pay()
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

    public String hashCal(String type,String str){
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
		
		return hexString.toString();

	}

    public Map<String, String> hashCalMethod()
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
            txnid = hashCal("SHA-256", rndm).substring(0, 20);
            tempparams.put("txnid", txnid);
        } else {
            txnid = tempparams.get("txnid");
        }
        
        tempparams.put("udf2", txnid);
        String amount = tempparams.get("amount")
        
        if("100".equals(amount)) {
        tempparams.put("productinfo", "1 month plan")
        } else if("500".equals(amount)) {
        tempparams.put("productinfo", "6 month plan")
        } else if("1000".equals(amount)) {
        tempparams.put("productinfo", "1 year plan")
        }
        
        tempparams.put("email", params.username)
        
        String hash = "";
        String otherPostParamSeq = "phone|surl|furl|lastname|curl|address1|address2|city|state|country|zipcode|pg";
        String hashSequence = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5";
        if (empty(tempparams.get("hash")) && tempparams.size() > 0) {
            if (empty(tempparams.get("key")) || empty(txnid) || empty(tempparams.get("amount")) || empty(tempparams.get("firstname")) || empty(tempparams.get("email")) || empty(tempparams.get("phone")) || empty(tempparams.get("productinfo")) || empty(tempparams.get("surl")) || empty(tempparams.get("furl")) || empty(tempparams.get("service_provider"))) {
                error = 1;
            } else {
                
                String[] hashVarSeq = hashSequence.split("\\|");
                for (String part : hashVarSeq) {
                    hashString = (empty(tempparams.get(part))) ? hashString.concat("") : hashString.concat(tempparams.get(part).trim());
                    hashString = hashString.concat("|");
                    urlParams.put(part, empty(tempparams.get(part)) ? "" : tempparams.get(part).trim());
                }
                hashString = hashString.concat("|||||");
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

		urlParams.put("key","dKqf7Mff")
		urlParams.put("txnid", txnid);
        urlParams.put("hash", hash);
        urlParams.put("action", action1);
        urlParams.put("hashString", hashString);
        return urlParams;
    }
    
    def pay() {
    	Map<String, String> values = hashCalMethod();
    	render view: 'payuform', model: [tempparams: values]
    }
  
  /** Show the register page. */
  def show() {

    /** Check if anonymous access is enabled, to avoid login 
    User anonymous = User.findByUsername("anonymous")
    springSecurityService.reauthenticate(anonymous.username,anonymous.password) **/

    def conf = getConf()

	String postUrl = request.contextPath + '/register/register'
    render view: 'registrationbolt', model: [postUrl: postUrl]
    
    /** redirect(uri: '/#/register') */
  }
  
  def payorrenew() {
  	if(!"100".equals(params.amount) && !"500".equals(params.amount) && !"1000".equals(params.amount)) {
       String message = "The selected plan is invalid"
       String postUrl = request.contextPath + '/register/register'
       render view: 'registration', model: [postUrl: postUrl, message: message]
    }
  	def username = params.username
    Cookie cookie = new Cookie("myCookie",username)
	cookie.maxAge = -1
	response.addCookie(cookie)
	pay()
  }
  
  def success() {

    def conf = getConf()
    
    if(params!=null && params.email!=null) {
    String username = params.email

	User userInstance = User.findByUsername(username)
	
	userInstance.enabled = true
	
	String amount = params.amount
	
	Calendar now = Calendar.getInstance()
	
	if("100.00".equals(amount)) {
		now.add(Calendar.MONTH,1)
	} else if("500.00".equals(amount)) {
		now.add(Calendar.MONTH,6)
	} else if("1000.00".equals(amount)) {
		now.add(Calendar.MONTH,12)
	} else {
		userInstance.enabled = false
	}
	
	Date expiryDate = now.getTime()
	
	userInstance.expiryDate = expiryDate
	userInstance.amountPaid = amount
	userInstance.accountExpired = false
	userInstance.enabled = true
	
	userInstance.save flush: true
	}
	
    render view: 'success'
  }
  
  def error() {

    def conf = getConf()
    
	String postUrl = request.contextPath + '/register/register'
    render view: 'registration', model: [postUrl: postUrl, message: "Error"]
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
