public with sharing class NewSubscriptionController  extends ApexBaseController {

    public NewSubscriptionViewModel viewModel {get; set;} 
    public  List<SelectOption> year {get; set;}
    private String accountId {get; set;}
    public String salesForceIP {get; set;}
    
    public NewSubscriptionController() {

        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
            viewModel = new NewSubscriptionViewModel(accountId);
        }
    }
    
    public List<SelectOption> getPaymentOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Schema.Subscription__c.fields.Payment_method__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }

    public Pagereference submitForm() {
        if (viewModel.submit() == true) {
            addMessage(ApexPages.Severity.INFO, '訂閱新增成功');
            PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/SubscriptionManagementPage');
            page.getParameters().put('orderSucceed','true');
            page.setRedirect(true);
            
        	return page;
        } else {
            addMessage(ApexPages.Severity.INFO, viewModel.errorMessage);
        }
        
        return null;
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
}