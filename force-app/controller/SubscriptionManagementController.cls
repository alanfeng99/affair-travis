public with sharing class SubscriptionManagementController extends ApexBaseController {

    public SubscriptionManagementViewModel viewModel {get; set;}

    public String currentEditRowId {get; set;}
    public String currentUseRowId {get; set;}
    public String currentCancelRowId {get; set;}
    public String subIdForUpdateCredit {get; set;}

    public Boolean updatedCreditcard {get; set;} 
    public Boolean orderSucceed {get; set;}
    private List<Subscription__c> originalSubscriptions;

    public SubscriptionManagementController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new SubscriptionManagementViewModel(accountId);  
            orderSucceed = ApexPages.currentPage().getParameters().get('orderSucceed') == 'true';
            updatedCreditcard = ApexPages.currentpage().getparameters().get('updateCreditcard') == 'true';
        }
    }

    public SubscriptionManagementController(String accountId) {            
        viewModel = new SubscriptionManagementViewModel(accountId);  
        orderSucceed = ApexPages.currentPage().getParameters().get('orderSucceed') == 'true';
        updatedCreditcard = ApexPages.currentpage().getparameters().get('updateCreditcard') == 'true';      
    }

    public Pagereference submitForm() {
        if (viewModel.submit()) {
            currentEditRowId = '';
            addMessage(ApexPages.Severity.INFO, System.label.Msg_SaveSuccess);
        } else {
            addMessage(ApexPages.Severity.ERROR, System.label.Msg_SaveFail);
        }
        return null;
    }

    public PageReference stopAutoOrderPanel() {
        return null;
    }
    
    public PageReference stopAutoOrderService() {
        updatedCreditcard = false;
        currentCancelRowId = '';
        update viewModel.subscriptions;
        
        return null;
    }
    
    public PageReference useAutoOrderPanel() {
        return null;
    }
    
    public PageReference useAutoOrderService() {
        subIdForUpdateCredit = currentUseRowId;
        currentUseRowId = '';
        
        PageReference page = new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/UpdateCreditcardPage');
        page.getParameters().put('subscriptionId', subIdForUpdateCredit);
      	return page;
    }

    public PageReference changeRecipientInfo(){
        originalSubscriptions = viewModel.subscriptions.deepClone(true);
        return null;
    }
    
    public PageReference cancelReturn() {
        currentUseRowId = '';
        currentCancelRowId = '';
        return null;
    }

    public PageReference cancelChange(){        
        currentEditRowId = '';
        rollbackSubscription();
        return null;
    }

    public Pagereference afterSubmit() {
        viewModel.subscriptions = SubscriptionModel.getSubscriptionsByUserId(viewModel.account.Id);
        return null;
    }

    private void rollbackSubscription() {
        
        for (Subscription__c subscription : viewModel.subscriptions) 
            for (Subscription__c originalSubscription : originalSubscriptions) 
                if (subscription.Id == originalSubscription.Id) {
                    subscription.Recipient__c = originalSubscription.Recipient__c;
                    subscription.City_pickList__c = originalSubscription.City_pickList__c;
                    subscription.Address__c = originalSubscription.Address__c;
                    subscription.Area_pickList__c = originalSubscription.Area_pickList__c;
                    subscription.Tel__c = originalSubscription.Tel__c;
                }
    }

    public Pagereference toUpdateCreditcardPage() {    
      	return ApexUtility.toPage('UpdateCreditcardPage');
    }

    public PageReference toSummaryPage() {
        return ApexUtility.toPage('SummaryPage');
    }
    
    public PageReference toAccountSettingPage() {
    	return ApexUtility.toPage('AccountSettingPage');
    }
    
    public PageReference toSubscriptionManagementPage() {
    	return ApexUtility.toPage('SubscriptionManagementPage');
    }
    
    public PageReference logOut() {  
        return AuthUtility.logOut();
    }
    
    
}