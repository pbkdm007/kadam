package streama;

import java.util.Properties;    
import javax.mail.*;    
import javax.mail.internet.*;

public class MailTest {
	public static void main(String[] args) {    
	     //from,password,to,subject,message  
	     Mailer.send("pbkdm007@gmail.com","teggnpmpujpjxyes","pbkdm007@gmail.com","hello javatpoint","How r u?");  
	     //change from, password and to  
	 }
}

class Mailer{  
    public static void send(String from,String password,String to,String sub,String msg){  
          //Get properties object    
          Properties props = new Properties();    
          props.put("mail.smtp.host", "smtp.gmail.com");    
          props.put("mail.smtp.socketFactory.port", "465");    
          props.put("mail.smtp.socketFactory.class",    
                    "javax.net.ssl.SSLSocketFactory");    
          props.put("mail.smtp.auth", "true");    
          props.put("mail.smtp.port", "465");    
          //get Session   
          Session session = Session.getDefaultInstance(props,    
           new javax.mail.Authenticator() {    
           protected PasswordAuthentication getPasswordAuthentication() {    
           return new PasswordAuthentication(from,password);  
           }    
          });    
          //compose message    
          try {    
           MimeMessage message = new MimeMessage(session);    
           message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));    
           message.setSubject(sub);    
           message.setText(msg);
           InternetAddress[] ia = new InternetAddress[1];
           ia[0]=new InternetAddress("noreply@kadam.in");
           message.addFrom(ia);
           //send message  
           Transport.send(message);    
           System.out.println("message sent successfully");    
          } catch (MessagingException e) {throw new RuntimeException(e);}    
             
    }  
}