public with sharing class UpdateCreditCardController extends ApexBaseController {
    public UpdateCreditCardViewModel viewModel {get; set;}
    public List<SelectOption> year {get; set;}
    
    public UpdateCreditCardController() {
		Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new UpdateCreditCardViewModel(accountId);
        }    
    }

    public UpdateCreditCardController(String accountId) {
        viewModel = new UpdateCreditCardViewModel(accountId);   
    }

    public Pagereference updateCreditcard() {
        if (!checkField())
            return null;
            
        if(!viewModel.updateSubscription()) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_CreditcardUploadFail);
            return null; 
        }
        
        addMessage(ApexPages.Severity.INFO, System.Label.Msg_UpdateCompleted);
        PageReference page = ApexUtility.toPage('AccountSettingPage');
        page.getParameters().put('updateCreditcard', 'true');
        return page;    
    }

    public Pagereference cancel() {
        return ApexUtility.toPage('AccountSettingPage');
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
        if (viewModel.creditCardBean.cc == null || viewModel.creditCardBean.expireMonth == null ||
                viewModel.creditCardBean.expireYear == null || viewModel.creditCardBean.expireYear == '' ||
                viewModel.creditCardBean.expireMonth == '' || viewModel.creditCardBean.cvc == null){
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckAll);
            return false;
        } 

        if (!CreditcardUtility.isCreditCardPattenMatching(viewModel.creditCardBean.cc)) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckNumber);
            return false;
        } 

        if (!CreditcardUtility.isCVCPattenMatching(viewModel.creditCardBean.cvc)) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckCVC);
            return false;
        }

        return true;
    }
}