public with sharing class SubscriptionManagementViewModel {
    public Account__c account {get; set;}
    public List<Subscription__c> subscriptions {get; set;}
    public Map<String, List<SubscriptionRecipient__c>> mapRecipients {get; set;}
    
    public SubscriptionManagementViewModel(String userId) {
        if (userId != null) {
            mapRecipients = new Map<String,List<SubscriptionRecipient__c>>();
            subscriptions = SubscriptionModel.getSubscriptionsByUserId(userId);
            for (Subscription__c subscription : subscriptions) {
                List<SubscriptionRecipient__c> recipients = [SELECT Tel__c, Address__c, Area_picklist__c, City_picklist__c, Postal_code__c, Recipient__c FROM SubscriptionRecipient__c WHERE ParentSubscription__c  = :subscription.Id];
                mapRecipients.put(subscription.Id, recipients);
            }
            account = AccountModel.getAccountById(userId);
        }
    }

    public Boolean submit() {
        List<Database.UpsertResult> results = Database.upsert(subscriptions);
        for (Database.UpsertResult result : results)
            if (!result.isSuccess())
                return false;

        return true;
    }
}