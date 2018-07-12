public with sharing class ChangePasswordController extends ApexBaseController {
    public ChangePasswordViewModel viewModel {get; set;}
    public Account__c accountVerify {get; set;} 

    public ChangePasswordController() {
        String accountId = ApexPages.currentpage().getparameters().get('id');
        viewModel = new ChangePasswordViewModel(accountId);
        
        viewModel.account.Password__c = '';
        accountVerify = new Account__c();
        accountVerify.Password__c = viewModel.account.Password__c;
    }

    public PageReference changePassword() {
        if(checkPassword()) {
            if(viewModel.submit()) {
                addMessage(ApexPages.Severity.INFO, '密碼更新成功');
                return AuthUtility.logOut();
            }
        }
        return null;
    }

    private Boolean checkPassword() {
        if (!PasswordUtility.checkPasswordHasEnglish(viewModel.account.Password__c)) {
            clearPassword();
            addMessage(ApexPages.Severity.ERROR, '密碼長度需8~12碼，且至少需要一個數字和英文');
            return false;
        } 
        
        if (!viewModel.account.Password__c.equals(accountVerify.Password__c)) {
            clearPassword();
            addMessage(ApexPages.Severity.ERROR, '密碼與驗證密碼不相符');
            return false;           
        }
        return true;
    }   

    private void clearPassword() {
        viewModel.account.Password__c = '';
        accountVerify.Password__c = '';
    }
}