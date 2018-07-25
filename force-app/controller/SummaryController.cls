public with sharing class SummaryController extends ApexBaseController  {

    public SummaryViewModel viewModel {get; set;}
    public String greetingWord {get; set;}
    
    public SummaryController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new SummaryViewModel(accountId);
            Account__c account = viewModel.getAccount();
            Integer timeForGreeting = Integer.valueOf(System.now().format('k'));   
            greetingChange(timeForGreeting);
        }    
    }

    public SummaryController(String accountId) {
        viewModel = new SummaryViewModel(accountId);
        Account__c account = viewModel.getAccount();
        Integer timeForGreeting = Integer.valueOf(System.now().format('k'));
        greetingChange(timeForGreeting);
    }

    public Account__c getAccount() {
        return viewModel.getAccount();
    }

    public List<Subscription__c> getSubscriptions() {
        return viewModel.getSubscriptions();
    }

    public void greetingChange(Integer timeForGreeting) {
        if(6 < timeForGreeting && timeForGreeting < 12) 
            greetingWord = '早安';
        else if (12 <  timeForGreeting && timeForGreeting < 18)
            greetingWord = '午安';
        else 
            greetingWord = '晚安';
        
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