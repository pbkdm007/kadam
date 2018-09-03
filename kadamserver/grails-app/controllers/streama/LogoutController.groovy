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
import org.springframework.security.core.context.SecurityContext
import org.springframework.security.web.WebAttributes
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler

import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

@Secured('permitAll')
class LogoutController {

  /** Dependency injection for the authenticationTrustResolver. */
  AuthenticationTrustResolver authenticationTrustResolver

  /** Dependency injection for the springSecurityService. */
  def springSecurityService

  /** Dependency injection for the settingsService. */
  def settingsService

  def login() {
    SecurityContextHolder.clearContext();

      HttpSession session = request.getSession(false);
      if (session != null) {
        session.invalidate();
      }

    def conf = getConf()

    if (springSecurityService.isLoggedIn()) {
      redirect uri: conf.successHandler.defaultTargetUrl
      return
    }

    String postUrl = request.contextPath + conf.apf.filterProcessesUrl
    render view: 'auth', model: [postUrl: postUrl,
                                 rememberMeParameter: conf.rememberMe.parameter,
                                 usernameParameter: conf.apf.usernameParameter,
                                 passwordParameter: conf.apf.passwordParameter,
                                 gspLayout: conf.gsp.layoutAuth]

  }

  /** Default action; redirects to 'defaultTargetUrl' if logged in, /login/auth otherwise. */
  def index() {

		/*HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}*/

		SecurityContext context = SecurityContextHolder.getContext();
		//context.setAuthentication(null);

		//SecurityContextHolder.clearContext();
		
		Authentication auth = context.getAuthentication();
	    if (auth != null){    
	        new SecurityContextLogoutHandler().logout(request, response, auth);
	    }
		
		//redirect action: 'auth', controller: 'login'
  }

  protected Authentication getAuthentication() {
    SecurityContextHolder.context?.authentication
  }

  protected ConfigObject getConf() {
    SpringSecurityUtils.securityConfig
  }
}
