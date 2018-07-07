public with sharing class SubscriptionManagementController extends ApexBaseController {

    public SubscriptionManagementViewModel viewModel {get; set;}

    private String page {get; set;}
    public Boolean orderSucceed {get; set;}

    public SubscriptionManagementController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new SubscriptionManagementViewModel(accountId);  
            orderSucceed = ApexPages.currentPage().getParameters().get('orderSucceed') == 'true';
            viewModel.updatedCreditcard =  ApexPages.currentpage().getparameters().get('updateCreditcard') == 'true';
        }
    }
    
    public Account__c getAccount() {
        return viewModel.getAccount();
    }

    public List<Subscription__c> getSubscriptions() {
        return viewModel.getSubscriptions();
    }

    public Pagereference submitForm() {
        if (viewModel.submit() == true) {
            addMessage(ApexPages.Severity.INFO, '儲存成功');
        } else {
            addMessage(ApexPages.Severity.ERROR, '儲存失敗');
        }
        return null;
    }
    
    public Pagereference toUpdateCreditcardPage() {    
      	return ApexUtility.toPage('UpdateCreditcardPage');
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