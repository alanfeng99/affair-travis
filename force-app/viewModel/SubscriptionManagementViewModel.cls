public with sharing class SubscriptionManagementViewModel {
    public Account__c account {get; set;}
    public List<Subscription__c> subscriptions {get; set;}
    
    public SubscriptionManagementViewModel(String userId) {
        if (userId != null) {
            subscriptions = SubscriptionModel.getSubscriptionsByUserId(userId);
            
            account = AccountModel.getAccountById(userId);
        }
    }
    
    public Boolean submit(Subscription__c subscription) {
        Database.UpsertResult result = Database.upsert(subscription);
        if (!result.isSuccess())
            return false;

        return true;
    }

    public Boolean submit() {
        List<Database.UpsertResult> results = Database.upsert(subscriptions);
        for (Database.UpsertResult result : results)
            if (!result.isSuccess())
                return false;

        return true;
    }
}