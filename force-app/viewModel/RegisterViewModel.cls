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
        if (AccountModel.getAccountByEmail(account.Email__c) != null) {
            errorMessage = '帳號已存在';   
            return false;
        }

        Account__c accountCreated = AccountModel.createAccountByEmail(account.Email__c);
        if (accountCreated == null) {
            errorMessage = '帳號已存在';
            return false;
        }

        if (EmailUtility.sendEmail(account.Email__c, 'AccountActivation'))
            return true;
        
        errorMessage = '電子郵件寄送失敗';   
        return false;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
}