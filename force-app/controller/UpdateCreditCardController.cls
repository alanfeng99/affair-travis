public with sharing class UpdateCreditCardController extends ApexBaseController {

    private UpdateCreditCardViewModel viewModel;
    public List<SelectOption> year {get; set;}
    public String subscriptionId {get; set;} 


    public UpdateCreditCardController() {
		Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	subscriptionId = ApexPages.currentpage().getparameters().get('subscriptionId');
            viewModel = new UpdateCreditCardViewModel(accountId);  
        }    
    }

    public Account__c getAccount() {
        return viewModel.getAccount();
    }

    public Pagereference submit() {
        if (viewModel.updateAccount() == true) {
            if(updateReplenish()) {
                addMessage(ApexPages.Severity.INFO, '更新成功');
                //  ApexUtility.toPage('UpdateCreditcardPage');
                PageReference page = ApexUtility.toPage('SubscriptionManagementPage');
                page.getParameters().put('updateCreditcard','true');
                return page;    
            }
        } else {
            addMessage(ApexPages.Severity.ERROR, viewModel.errorMessage);
        }
        
        return null;
    }

    public Pagereference cancel() {
        viewModel.rollbackAccount(); 
        
        return ApexUtility.toPage('SubscriptionManagementPage');
    }
    
    public List<SelectOption> getCreditcard_Year (){
        year = new List<SelectOption>();
        Integer yearFornow = Integer.valueOf(System.now().format('Y'));
        year.add(new SelectOption('','--None--'));
        for(Integer i=0; i<13; i++){
            year.add(new SelectOption(String.valueOf(yearFornow + i),String.valueOf(yearFornow + i)));
            
        }

        return year;
    }
    
    private boolean updateReplenish() {
        Boolean result = true;
        for(Subscription__c sub : viewModel.subscriptions) {
            if(sub.id == subscriptionId) {
                sub.isReplenish__c = true;
                Database.SaveResult databaseResult = Database.update(sub);
                if (!databaseResult.isSuccess())
                    result = false;    
            }
        }
        return result;
    }
    
}