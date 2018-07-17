public with sharing class UpdateCreditCardViewModel {
    public Account__c account {get; set;}
    public List<Subscription__c> subscriptions {get; set;}
    public String cc {get; set;}
    public String expireYear {get; set;}
    public String expireMonth {get; set;}
    public String cvc {get; set;}

    public UpdateCreditCardViewModel(String userId) {
        account = AccountModel.getAccountById(userId);
        subscriptions = SubscriptionModel.getSubscriptionsByUserId(userId); 
    }

    public Boolean updateAccount() {
        return AccountModel.updateAccount(account);     
    }

    public Boolean updateSubscription(Subscription__c sub) {
        Database.SaveResult databaseResult = Database.update(sub);
        if (!databaseResult.isSuccess())
            return false; 
        return true;   
    }
}