public with sharing class SubscriptionManagementViewModel {
	
    private Account__c account;
    private List<Subscription__c> subscriptions;
    private List<Subscription__c> originalSubscriptions;
    public String currentEditRowId {get; set;} // input 收件人版面
    public String currentUseRowId {get; set;}
    public String currentCancelRowId {get; set;}
    public String subIdForUpdateCredit {get; set;}

    public Boolean updatedCreditcard {get; set;}  
    
    public SubscriptionManagementViewModel(String userId) {
        if (userId != null) {
            subscriptions = SubscriptionModel.getSubscriptionsByUserId(userId);
            account = AccountModel.getAccountById(userId);
        }
    }

    public Account__c getAccount() {
        return account;
    }

    public List<Subscription__c> getSubscriptions() {
        return subscriptions;
    }

    //在原本PaymentPanel上點選停止自動續訂commanLink
    public PageReference stopAutoOrderPanel(){
        return null;
    }
    
    //在stopAutoOrderPanel上點選停止自動續訂commanButton
    public PageReference stopAutoOrderService(){
        updatedCreditcard = false;
        currentCancelRowId = '';
        
        update subscriptions;
        
        return null;
    }
    
    //在原本PaymentPanel上點選使用自動續訂commanLink
    public PageReference useAutoOrderPanel(){
        return null;
    }
    
    //在useAutoOrderPanel上點選使用自動續訂commanButton
    public PageReference useAutoOrderService(){
        subIdForUpdateCredit = currentUseRowId;
        currentUseRowId = '';
        
        PageReference page = new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/UpdateCreditcardPage');
        page.getParameters().put('subscriptionId',subIdForUpdateCredit);
      	return page;
    }
    
    public PageReference cancelReturn(){
        currentUseRowId = '';
        return null;
    }
    
    public Boolean submit() {
        //TODO 必填檢查?
        
        List<Database.UpsertResult> results = Database.upsert(subscriptions);
        Boolean updateResult = true;
        for(Database.UpsertResult result : results)
        {
            if (result.isSuccess() == false) {
                updateResult = false;
            }
        }
        
        currentEditRowId = '';

        return updateResult;
    }
    
    public PageReference changeRecipientInfo(){
        originalSubscriptions = subscriptions.deepClone(true);
        return null;
    }
    
    public PageReference cancelChange(){        
        currentEditRowId = '';
        rollbackSubscription();
        return null;
    }

    public Pagereference afterSubmit() {
        subscriptions = SubscriptionModel.getSubscriptionsByUserId(account.Id);
        return null;
    }

    private void rollbackSubscription() {
        for (Subscription__c subscription : subscriptions) {
            for (Subscription__c originalSubscription : originalSubscriptions) {
                if (subscription.Id == originalSubscription.Id) {
                    subscription.Recipient__c = originalSubscription.Recipient__c;
                    subscription.City_pickList__c = originalSubscription.City_pickList__c;
                    subscription.Address__c = originalSubscription.Address__c;
                    subscription.Area_pickList__c = originalSubscription.Area_pickList__c;
                    subscription.Tel__c = originalSubscription.Tel__c;
                }
            }
        }
    }
}