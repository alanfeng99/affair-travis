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
        if (checkField()) {
            if (viewModel.submit()) {
                currentEditRowId = '';
                addMessage(ApexPages.Severity.INFO, System.label.Msg_SaveSuccess);
            } else {
                addMessage(ApexPages.Severity.ERROR, System.label.Msg_SaveFail);
            }
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
        
        for(Subscription__c sub : viewModel.subscriptions) 
            if (sub.id  == subIdForUpdateCredit) {
                sub.isReplenish__c = true;
                viewModel.submit(sub);
            }
        
        return null;
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
        if (checkField())
            viewModel.subscriptions = SubscriptionModel.getSubscriptionsByUserId(viewModel.account.Id);
        return null;
    }

    private Boolean checkField() {
        for (Subscription__c sub : viewModel.subscriptions) {
            if (sub.Recipient__c == null || sub.City_picklist__c == null || sub.Area_picklist__c == null || 
                    sub.Address__c == null || sub.Email__c == null ) {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_RecipientInfoEmpty);
                return false;
            }

            if (sub.Tel__c != null)
                if (!ApexUtility.checkPhoneFormat(sub.Tel__c)){
                    addMessage(ApexPages.Severity.ERROR, System.Label.Msg_PhoneFormat);
                    return false;
                } 
        }

        return true;
    }

    private void rollbackSubscription() {
        for (Subscription__c subscription : viewModel.subscriptions) 
            for (Subscription__c originalSubscription : originalSubscriptions) 
                if (subscription.Id == originalSubscription.Id) {
                    subscription.Recipient__c = originalSubscription.Recipient__c;
                    subscription.City_pickList__c = originalSubscription.City_pickList__c;
                    subscription.Address__c = originalSubscription.Address__c;
                    subscription.Area_pickList__c = originalSubscription.Area_pickList__c;
                    if (subscription.Tel__c != null)
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