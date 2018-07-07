public with sharing class AccountSettingController extends ApexBaseController {
    
    public AccountSettingViewModel viewModel {get; set;}
    
    public AccountSettingController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new AccountSettingViewModel(accountId); 
        }        
    }

    public Pagereference submitPassword() {
        if (viewModel.updatePasswordAccount() == true) {
            addMessage(Apexpages.Severity.INFO, '更新成功');
            viewModel.showView('Main');
        } else {
            addMessage(Apexpages.Severity.ERROR, viewModel.errorMessage);
        }
        return null;
    }

    public Pagereference submitName() {
        if (viewModel.updateName() == true) {
            addMessage(Apexpages.Severity.INFO, '更新成功');
            viewModel.showView('Main');
        } else {
            addMessage(Apexpages.Severity.ERROR, viewModel.errorMessage);
        }
        
        return null;
    }

    public Pagereference submitEmail() {
        if (viewModel.updateEmail() == true) {
            addMessage(Apexpages.Severity.INFO, '更新成功');
            viewModel.showView('Main');
            EmailUtility.sendEmail(viewModel.account.Email__c, 'AccountActivation');
            return ApexUtility.toPage('RegisterResultPage');
        } else {
            addMessage(Apexpages.Severity.ERROR, viewModel.errorMessage);
        }
        
        return null;
    }
    
    public PageReference toSummaryPage(){
        return ApexUtility.toPage('SummaryPage');
    }
    
    public PageReference toAccountSettingPage(){
    	return ApexUtility.toPage('AccountSettingPage');
    }
    
    public PageReference toSubscriptionManagementPage(){
    	return ApexUtility.toPage('SubscriptionManagementPage');
    }
    
    public PageReference logOut() {  
        return AuthUtility.logOut();
    }

}