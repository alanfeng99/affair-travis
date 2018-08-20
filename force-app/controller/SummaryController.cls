public with sharing class SummaryController extends ApexBaseController  {

    public SummaryViewModel viewModel {get; set;}
    public String greetingWord {get; set;}
    
    public SummaryController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new SummaryViewModel(accountId);
            Account account = viewModel.getAccount();
            Integer timeForGreeting = Integer.valueOf(Datetime.now().format('HH', 'Asia/Taipei'));  
            greetingChange(timeForGreeting);
        }
    }

    public SummaryController(String accountId) {
        viewModel = new SummaryViewModel(accountId);
        Account account = viewModel.getAccount();
        Integer timeForGreeting = Integer.valueOf(Datetime.now().format('HH', 'Asia/Taipei'));
        greetingChange(timeForGreeting);
    }

    public Account getAccount() {
        return viewModel.getAccount();
    }

    public List<Subscription__c> getSubscriptions() {
        return viewModel.getSubscriptions();
    }

    public void greetingChange(Integer timeForGreeting) {
        if(6 < timeForGreeting && timeForGreeting < 12) 
            greetingWord = System.Label.GREET_MORNING;
        else if (12 <  timeForGreeting && timeForGreeting < 18)
            greetingWord = System.Label.GREET_AFTERNOON;
        else 
            greetingWord = System.Label.GREET_NIGHT;
        
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