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
                saveLoginCookies(viewModel.account);
                return ApexUtility.toPage('SummaryPage');
            }
        }
        return null;
    }

    public Pagereference checkAutoLogin() {
        Cookie authToken = ApexPages.currentPage().getCookies().get(Label.COOKIE_AUTH_TOKEN);
        Cookie accountId = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        if (authToken != null && accountId != null) {
            return ApexUtility.toPage('SummaryPage');
        }
        return null;
    }

    public void saveLoginCookies(Account__c realAccount) {
        String token = AccountModel.saveToken(realAccount);
        Cookie authToken = new Cookie(Label.COOKIE_AUTH_TOKEN, token, null, Constants.COOKIE_DURATION, false);
        Cookie accountId = new Cookie(label.COOKIE_ACCOUNT_ID, realAccount.Id, null, Constants.COOKIE_DURATION, false);
        ApexPages.currentPage().setCookies(new Cookie[]{authToken, accountId});
    }

    private Boolean checkPassword() {
        if (!PasswordUtility.checkPasswordFormat(viewModel.account.Password__c)) {
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