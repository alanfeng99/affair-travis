public with sharing class ChangePasswordViewModel {
    
    public Account__c account {get; set;}
    public Account__c accountVerify {get; set;}    
    private String errorMessage {get; set;}


    public ChangePasswordViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
        account.Password__c = '';
        accountVerify = new Account__c();
        accountVerify.Password__c = account.Password__c;
        
    }

    public Boolean submit() {
        if (checkPassword() == true) {
            account.Active__c = true;
            Database.SaveResult result = Database.update(account);
            return result.isSuccess();
        }  
        return false; 
    }

    public Boolean checkPassword() {
        Boolean result = true;
        String password = account.Password__c;
        if (PasswordUtility.checkPasswordHasEnglish(password) == false) {
            clearPassword();
            errorMessage = '密碼長度需8~12碼，且至少需要一個數字和英文';
            result = false;
        } else if (password.equals(accountVerify.Password__c) == false) {
            clearPassword();
            errorMessage = '密碼與驗證密碼不相符';
            result = false;            
        }
        return result;
    }
    
    private void clearPassword() {
        account.Password__c = '';
        accountVerify.Password__c = '';
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
}