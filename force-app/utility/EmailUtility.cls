public with sharing class EmailUtility {
    
    public static Boolean emailFormatValidation(String email) { 
        Boolean res = true;
	    String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
	    Pattern emailPattern = Pattern.compile(emailRegex);
	    Matcher emailMatcher = emailPattern.matcher(email);
        return emailMatcher.matches();
    }

    public static Boolean sendEmail(String email, String name) {
        Account__c account = AccountModel.getAccountByEmail(email);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        EmailTemplate emailTemp = [SELECT id, HtmlValue, Name, Body FROM EmailTemplate WHERE developerName = :name];
        User currentUser = [Select email, firstName, lastName from User where username = :UserInfo.getUserName() limit 1];
       	
        Contact tempContact = new Contact(email = currentUser.email, firstName = currentUser.firstName, lastName = currentUser.lastName);
  		upsert tempContact;
        
       	message.toAddresses = new String[] { email };
        message.setSenderDisplayName('Affairs 編集者新聞社有限公司');
        message.setTemplateId(emailTemp.id);
        message.setWhatId(account.Id);
        message.setTargetObjectId(tempContact.id); 
        message.setSaveAsActivity(false); 
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        delete tempContact;

        if (results[0].success) {
            System.debug('The email was sent successfully.');
            return true;
        }
        
        System.debug('The email failed to send: ' + results[0].errors[0].message);
        return false;
    }    
}