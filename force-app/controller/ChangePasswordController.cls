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
                addMessage(ApexPages.Severity.INFO, System.Label.Msg_UpdateCompleted);
                return AuthUtility.logOut();
            }
        }
        return null;
    }

    private Boolean checkPassword() {
        if (!PasswordUtility.checkPasswordHasEnglish(viewModel.account.Password__c)) {
            clearPassword();
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_PasswordFormat);
            return false;
        } 
        
        if (!viewModel.account.Password__c.equals(accountVerify.Password__c)) {
            clearPassword();
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Password_Inconsistent);
            return false;           
        }
        return true;
    }   

    private void clearPassword() {
        viewModel.account.Password__c = '';
        accountVerify.Password__c = '';
    }
}