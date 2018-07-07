public with sharing class SummaryController extends ApexBaseController  {

    public SummaryViewModel viewModel {get; set;}

    public SummaryController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new SummaryViewModel(accountId);
            Account__c account = viewModel.getAccount();   
        }
        
    }

    public Account__c getAccount() {
        return viewModel.getAccount();
    }

    public List<Subscription__c> getSubscriptions() {
        return viewModel.getSubscriptions();
    }
    
    public PageReference toNewSubscriptionPage(){
        return ApexUtility.toPage('NewSubscriptionPage');
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