public with sharing class RegisterViewModel {

    public Account__c account {get; set;}
    private String errorMessage {get; set;} 

    public enum RegisterType {
        Email,
        Facebook,
        Google
    }

    public RegisterViewModel() {
        account = new Account__c();
    }

    public Boolean registerByEmail() {
        if (!EmailUtility.emailFormatValidation(account.Email__c)) {
            errorMessage = '電子郵件格式不符';   
            return false;
        }
        
        if(createAccountByEmail(account.Email__c))
            EmailUtility.sendEmail(account.Email__c, 'AccountActivation');
        
        return true;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
   
    private Boolean createAccountByEmail(String email) {
        List<Account__c> accounts = [Select Id from Account__c where Email__c = :email];
        if (accounts.size() > 0) {
            errorMessage = '帳號已存在';
            return false;
        }
        account.LastName__c = account.Email__c;
        insert account;
        return true;
    }

}