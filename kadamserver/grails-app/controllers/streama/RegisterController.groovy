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

@Secured('permitAll')
class RegisterController {

  /** Dependency injection for the authenticationTrustResolver. */
  AuthenticationTrustResolver authenticationTrustResolver

  /** Dependency injection for the springSecurityService. */
  def springSecurityService

  /** Dependency injection for the settingsService. */
  def settingsService

  def register() {
	def username = params.username
    def isInvite = true
    def result = [:]

    if (User.findByUsername(username)) {
      flash.message = "Username already exists."
      usernamespanclass = "ion-close form-control-feedback"
      redirect(action:'show')
    } else {
    	if (params.password != params.password2) {
                flash.message = "Passwords do not match"
                passwordspanclass = "ion-close form-control-feedback"
                password2spanclass = "ion-close form-control-feedback"
                redirect(action:'show')
            }
            else {
            usernamespanclass = "ion-checkmark form-control-feedback"
            passwordspanclass = "ion-checkmark form-control-feedback"
            password2spanclass = "ion-checkmark form-control-feedback"
            	User user = new User(
                        username: params.username,
                        password: params.password
                )
                user.validate()
			    if (user.hasErrors()) {
			      render status: NOT_ACCEPTABLE
			      return
			    }
			
			    user.save flush: true
			
			    UserRole.removeAll(user)
			    
			    render view: 'auth'
            }
    }
  }
  
  /** Show the login page. */
  def show() {

    /** Check if anonymous access is enabled, to avoid login **/
    User anonymous = User.findByUsername("anonymous")
    springSecurityService.reauthenticate(anonymous.username,anonymous.password)

    def conf = getConf()

    def planMap = [:]
	planMap.put(200, '1 month - 200')
	planMap.put(1000, '6 month - 1000')
	planMap.put(2000, '1 year - 2000')

	String postUrl = request.contextPath + '/register/register'
    render view: 'registration', model: [postUrl: postUrl]
    
    /** redirect(uri: '/#/register') */
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
