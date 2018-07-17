public with sharing class UpdateCreditCardController extends ApexBaseController {
    public UpdateCreditCardViewModel viewModel {get; set;}
    private Account__c tempAccount {get; set;}
    public List<SelectOption> year {get; set;}
    public String subscriptionId {get; set;} 

    public UpdateCreditCardController() {
		Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	subscriptionId = ApexPages.currentpage().getparameters().get('subscriptionId');
            viewModel = new UpdateCreditCardViewModel(accountId);  
            tempAccount = viewModel.account.clone();
        }    
    }

    public Pagereference updateCreditcard() {
        if (checkField()) {
            if (viewModel.cc != null && !String.isBlank(viewModel.cc))
                viewModel.account.credit_card_number__c = viewModel.cc.substring(0,4) + '****' + viewModel.cc.substring(viewModel.cc.length()-4, viewModel.cc.length());

            if(viewModel.updateAccount()) 
                if(updateReplenish()) {
                    addMessage(ApexPages.Severity.INFO, System.Label.Msg_UpdateCompleted);
                    PageReference page = ApexUtility.toPage('SubscriptionManagementPage');
                    page.getParameters().put('updateCreditcard','true');
                    return page;    
                }     
        }      
        return null;
    }

    public Pagereference cancel() {
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

    public List<SelectOption> getCreditcard_Month() {
        List<SelectOption> months = new List<SelectOption>();
        months.add(new SelectOption('','--None--'));
        for (Integer i=1; i<13; i++)
            months.add(new SelectOption(String.valueOf(i),String.valueOf(i)));   

        return months;
    }

    private Boolean checkField() {
        if (viewModel.cc == null || viewModel.expireMonth == null ||
                viewModel.expireYear == null || viewModel.expireYear == '' ||
                viewModel.expireMonth == '' || viewModel.cvc == null){
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckAll);
            return false;
        } 

        if (!CreditcardUtility.isCreditCardPattenMatching(viewModel.cc)) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckNumber);
            return false;
        } 

        if (!CreditcardUtility.isCVCPattenMatching(viewModel.cvc)) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckCVC);
            return false;
        }

        return true;
    }
    
    private boolean updateReplenish() {
        for(Subscription__c sub : viewModel.subscriptions) {
            if(sub.id == subscriptionId) {
                sub.isReplenish__c = true;
                if(!viewModel.updateSubscription(sub))
                    return false; 
            }
        }
        return true;
    }
}