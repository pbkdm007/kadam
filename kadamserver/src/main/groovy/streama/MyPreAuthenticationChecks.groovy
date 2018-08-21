package streama

import grails.plugin.springsecurity.userdetails.DefaultPreAuthenticationChecks
import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.LockedException
import org.springframework.security.core.userdetails.UserDetails;
import javax.servlet.http.Cookie

class MyPreAuthenticationChecks extends DefaultPreAuthenticationChecks {

   void check(UserDetails user) {

      // do the standard checks
      super.check user

      // then the custom check(s)
      if (user.deleted) {
         log.debug 'User account is deleted'
         throw new LockedException()
      }
      
      User userinstance = User.findByUsername(user.username)
      
      Date now = new Date()
  	  if(userinstance.expiryDate==null||userinstance.expiryDate.after(now)) {
  	  	Cookie cookie = new Cookie("myLoginCookie",username)
		cookie.maxAge = -1
		response.addCookie(cookie)
  	  	throw new AccountExpiredException()
  	  }
   }

}
