public with sharing class SummaryController extends ApexBaseController  {

    public SummaryViewModel viewModel {get; set;}
    public String greetingWord {get; set;}
    public Cookie accountIdCookie {get; set;}

    public SummaryController() {
        accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new SummaryViewModel(accountId);
            Account__c account = viewModel.getAccount();   
            greetingChange();
        }    
    }

    public SummaryController(Cookie cookie) {
        accountIdCookie = cookie;
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new SummaryViewModel(accountId);
            Account__c account = viewModel.getAccount();   
            greetingChange();
        }
    }

    public Account__c getAccount() {
        return viewModel.getAccount();
    }

    public List<Subscription__c> getSubscriptions() {
        return viewModel.getSubscriptions();
    }

    public void greetingChange() {
        Integer timeForGreeting = Integer.valueOf(System.now().format('k'));
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