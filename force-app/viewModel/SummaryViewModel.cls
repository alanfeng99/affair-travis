public with sharing class SummaryViewModel {
    private Account__c account;
    private List<Subscription__c> subscriptions;
    
    public String year {get; set;}
    public String month {get; set;}
    public String day {get; set;}
    private Integer sumOfSubscription {get; set;}
    
    public SummaryViewModel(String userId) {
        account = AccountModel.getAccountById(userId);
        subscriptions = SubscriptionModel.getSubscriptionsByUserId(userId);
        
        Datetime joinDate = (Datetime)account.JoinDate__c;
        year = joinDate.format('Y');
        month = joinDate.format('M');
        day = joinDate.format('d');

    }
    
    public Account__c getAccount() {
        return account;
    }

    public List<Subscription__c> getSubscriptions() {
        return subscriptions;
    }
    
    public Integer getSumOfSubscription(){
        sumOfSubscription = 0;
        for(Subscription__c sub : subscriptions){
            sumOfSubscription ++;
        }
        
        return sumOfSubscription;
    }
}