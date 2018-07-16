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

        String creationError = AccountModel.createAccountByEmail(account.Email__c);
        if (creationError == null) {
            if (EmailUtility.sendEmail(account.Email__c, 'AccountActivation') == true) {
                return true;
            } 
            errorMessage = '電子郵件寄送失敗';   
        }
        errorMessage = creationError;
        return false;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
}