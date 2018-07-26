public with sharing class NewSubscriptionController extends ApexBaseController {
    public NewSubscriptionViewModel viewModel {get; set;} 
    public List<Subscription__c> subscriptionInsertList {get; set;}
    public List<Subscription__c> tempSubscriptions {get; set;}
    public List<SelectOption> year {get; set;}
    public Subscription__c firstSubscription {get; set;}
    public Subscription__c newSubscription;
    public String salesForceIP {get; set;}
    public String programId {get; set;}
    public String paymentMethod {get; set;}
    public String programName {get; set;}
    public Integer subscriptionSize {get; set;}
    public Integer startPeriod {get; set;}
    public Decimal programTotalPrice {get; set;}
    public Decimal programPrice {get; set;}
    public Decimal deleteRowId {get; set;}
    public Boolean isChooseCreditcard {get; set;}
    public Boolean showProgramResult {get; set;}
    public Boolean showErrorForNullProgram {get; set;}
    
    public NewSubscriptionController() {

        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
            viewModel = new NewSubscriptionViewModel(accountId);
            tempSubscriptions = new List<Subscription__c>();
            
            firstSubscription = new Subscription__c(CustomAccount__c = accountId);
            firstSubscription.Index__c = 1;
            tempSubscriptions.add(firstSubscription);

            viewModel.creditCardBean.cvc = '';
            calculateSize();
        }
        pageInit();
    }

    public NewSubscriptionController(String accountId) {
        viewModel = new NewSubscriptionViewModel(accountId);
        tempSubscriptions = new List<Subscription__c>();
        
        firstSubscription = new Subscription__c(CustomAccount__c = accountId);
        firstSubscription.Index__c = 1;
        tempSubscriptions.add(firstSubscription);

        viewModel.creditCardBean.cvc = '';
        calculateSize();
    
        pageInit();
    }

    private void pageInit() {
        isChooseCreditcard = false;
        showProgramResult = false;
        showErrorForNullProgram = false;
        subscriptionInsertList = new List<Subscription__c>();
    }

    public PageReference newSubscription() {
        if (programId == null) {
            showErrorForNullProgram = true;
            return null;
        }
        newSubscription = new Subscription__c(CustomAccount__c = viewModel.account.Id);
        newSubscription.Index__c = tempSubscriptions.size() + 1;
        tempSubscriptions.add(newSubscription);
        
        calculateSize();
        programPriceDecide();
        return null;
    }

    public PageReference deleteSubscription() {
        Integer indexForRemove;
        
        for (Integer i = 0; i < tempSubscriptions.size(); i++) 
            if (tempSubscriptions.get(i).Index__c == deleteRowId) 
               indexForRemove = i;
            
        tempSubscriptions.remove(indexForRemove);
        
        for (Integer i = 0; i < tempSubscriptions.size(); i++) 
            tempSubscriptions.get(i).Index__c = i+1;
        
        calculateSize();
        programPriceDecide();
        return null;
    }
        
    public Pagereference programPriceDecide() {
        List<SubscriptionProgram__c> programs = SubscriptionModel.getProgramById(programId);
        if (programId != null) {
            programPrice = programs.get(0).Price__c;   
            programName = programs.get(0).ProgramName__c;
            programTotalPrice = programPrice * subscriptionSize;
            showProgramResult = true;
            showErrorForNullProgram = false;
        }   
        return null;
    }

     public List<Product2> getProductInfo() {
        return ProductModel.getProduct(); 
    }
    
    public List<SelectOption> getProductRadioButton() {
        List<SelectOption> options = new List<SelectOption>();
        List<Product2> products = ProductModel.getProduct();
        if (products == null) {
            options.add(new SelectOption('No product', 'No product'));
            return options;
        }
        
        for (Product2 product : products) 
        	options.add(new SelectOption(product.ProductCode, product.Name));    

        return options;
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

    public List<SelectOption> getCreditcard_Year() {
        year = new List<SelectOption>();
        Integer yearFornow = Integer.valueOf(System.now().format('Y'));
        year.add(new SelectOption('','--None--'));
        for (Integer i=0; i<13; i++)
            year.add(new SelectOption(String.valueOf(yearFornow + i),String.valueOf(yearFornow + i)));   

        return year;
    }

    public List<SelectOption> getCreditcard_Month() {
        List<SelectOption> months = new List<SelectOption>();
        months.add(new SelectOption('','--None--'));
        for (Integer i=1; i<13; i++)
            months.add(new SelectOption(String.valueOf(i),String.valueOf(i)));   

        return months;
    } 

    public List<SelectOption> getProgramSelection() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--- 請選擇 ---'));
        for (SubscriptionProgram__c program : SubscriptionModel.getProgram()) 
            options.add(new SelectOption(program.ProgramId__c, program.ProgramName__c));
        
        return options;
    }

    public Pagereference chooseCreditCard() {
        if (paymentMethod == '信用卡')
            isChooseCreditcard = true;
        else 
            isChooseCreditcard = false;
       
        return null;
    }

    public Pagereference submitForm() {
        if (programId == null) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_ProgramEmpty);
            return null;
        }
        firstSubscription.Payment_method__c = paymentMethod;
        
        newSubscriptionInsertList();
        

        if (!checkField()) 
            return null;
        
        insertSubscriptionPriceAndProgram();
        if (viewModel.newSubscription(subscriptionInsertList, programId)) {
            PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/SubscriptionManagementPage');
            page.getParameters().put('orderSucceed','true');
            page.setRedirect(true);
        	return page;
        } else {
            addMessage(ApexPages.Severity.INFO, viewModel.errorMessage);
        }
        
        return null;
    }

    private void calculateSize() {
        subscriptionSize = tempSubscriptions.size();
    }

    private void calculatePeriod() {
        if (firstSubscription.Start_period__c != null)  
       		firstSubscription.End_period__c = firstSubscription.Start_period__c + firstSubscription.Program__r.Order_Period__c;     
    }

    private void newSubscriptionInsertList() {
        
        subscriptionInsertList.clear();
        
        for (Subscription__c sub : tempSubscriptions) {
            Subscription__c clone_Subscription = firstSubscription.clone();
            clone_Subscription.Recipient__c = sub.Recipient__c;
            clone_Subscription.Address__c = sub.Address__c;
            clone_Subscription.Area_pickList__c = sub.Area_pickList__c;+
            clone_Subscription.Postal_code__c = sub.Postal_code__c;
            clone_Subscription.City_pickList__c = sub.City_pickList__c;
            clone_Subscription.Tel__c = sub.Tel__c;

            subscriptionInsertList.add(clone_Subscription);
        }
    }

   private void insertSubscriptionPriceAndProgram() {
        List<SubscriptionProgram__c> programs = SubscriptionModel.getProgramById(programId);
        
        for (Subscription__c sub : subscriptionInsertList) {
            sub.Start_period__c = startPeriod;
            sub.End_period__c = startPeriod + programs.get(0).Order_Period__c - 1;
            sub.Amount__c = programs.get(0).Price__c;   
            sub.Program__c = programs.get(0).id;
            sub.CustomAccount__c = viewModel.account.Id;
        }
        
    }

    private Boolean checkField() {
        if (startPeriod == null) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_PeriodEmpty);
            return false;
        }
        
        for (Subscription__c sub : subscriptionInsertList) {
            if (sub.Recipient__c == null || sub.City_picklist__c == null || sub.Area_picklist__c == null || 
                    sub.Address__c == null || sub.Tel__c == null ) {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_RecipientInfoEmpty);
                return false;
            }

            if (!checkPhoneFormat(sub.Tel__c)){
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_PhoneFormat);
                return false;
            }
            
            if (sub.Payment_method__c == null) {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_PaymentEmpty);
                return false;
            }
                
            if (sub.Payment_method__c == '信用卡') 
                return isFieldFilledWhenChoosenCard();   
        }
        return true; 
    }

    private Boolean isFieldFilledWhenChoosenCard() {
        if (viewModel.account.credit_card_number__c == null) {
            if (viewModel.creditCardBean.cc == null || viewModel.creditCardBean.expireYear == null ||
                viewModel.creditCardBean.expireYear == '' || viewModel.creditCardBean.expireMonth == null ||
                viewModel.creditCardBean.expireMonth == '' || viewModel.creditCardBean.cvc == null) {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckAll);
                return false;
            }
            if (!CreditcardUtility.isCVCPattenMatching(viewModel.creditCardBean.cvc)) {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckCVC);
                return false;
            } 
            
            if (!CreditcardUtility.isCreditCardPattenMatching(viewModel.creditCardBean.cc)) {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_Creditcard_CheckNumber);
                return false;
            }
        }    
        
        return true;
    }

    private Boolean checkPhoneFormat(String phone) {
        Pattern MyPattern = Pattern.compile('[0-9]{8,12}');
        Matcher MyMatcher = MyPattern.matcher(phone);

        return MyMatcher.matches();
    }

    public Pagereference toUpdateCreditcardPage() {    
      	return ApexUtility.toPage('UpdateCreditcardPage');
    }

    public PageReference toSummaryPage() {
        return ApexUtility.toPage('SummaryPage');
    }
    
    public PageReference toAccountSettingPage() {
    	return ApexUtility.toPage('AccountSettingPage');
    }
    
    public PageReference toSubscriptionManagementPage() {
    	return ApexUtility.toPage('SubscriptionManagementPage');
    }
    
    public PageReference logOut() {  
        return AuthUtility.logOut();
    } 
}