package streama

import grails.plugin.springsecurity.userdetails.DefaultPreAuthenticationChecks
import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.LockedException
import org.springframework.security.core.userdetails.UserDetails
import javax.servlet.http.Cookie
import org.springframework.context.support.MessageSourceAccessor
import org.springframework.security.core.SpringSecurityMessageSource

class MyPreAuthenticationChecks extends DefaultPreAuthenticationChecks {

MessageSourceAccessor messages = SpringSecurityMessageSource.getAccessor()

   void check(UserDetails user) {

      // do the standard checks
      super.check user
      
      User userinstance
      
      User.withTransaction {
       userinstance = User.findByUsername(user.getUsername())

      // then the custom check(s)
      if (userinstance.deleted) {
         log.debug 'User account is deleted'
         throw new LockedException()
      }
      
      Date now = new Date()
  	  if(userinstance.expiryDate!=null && !userinstance.expiryDate.after(now)) {
  	  	if(!userinstance.accountExpired) {
  	  		userinstance.accountExpired = true
    		userinstance.save flush: true
    	}
  	  	throw new AccountExpiredException(messages.getMessage(
						"AbstractUserDetailsAuthenticationProvider.expired",
						"User account has expired"))
  	  }
  	 }
   }

}
