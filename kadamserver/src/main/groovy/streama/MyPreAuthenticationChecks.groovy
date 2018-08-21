package streama

import grails.plugin.springsecurity.userdetails.DefaultPreAuthenticationChecks
import org.springframework.security.authentication.AccountStatusException
import org.springframework.security.authentication.AccountExpiredException
import javax.servlet.http.Cookie

class MyPreAuthenticationChecks extends DefaultPreAuthenticationChecks {

   private static final EXCEPTION = new DeletedException()

   void check(UserDetails user) {

      // do the standard checks
      super.check user

      // then the custom check(s)
      if (user.deleted) {
         log.debug 'User account is deleted'
         throw EXCEPTION
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

   static class DeletedException extends AccountStatusException {
      LockedException() {
         super('User account is deleted')
      }

      // avoid the unnnecessary cost
      Throwable fillInStackTrace() {
         this
      }
   }
}
