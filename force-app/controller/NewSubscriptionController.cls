public with sharing class NewSubscriptionController extends ApexBaseController {
    public NewSubscriptionViewModel viewModel {get; set;} 
    public Subscription__c subscriptionToInsert {get; set;}
    public List<SubscriptionRecipient__c> tempSubscriptions {get; set;}
    public List<SelectOption> year {get; set;}
    
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

    private String accountId {get; set;}
    
    public NewSubscriptionController() {

        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
            viewModel = new NewSubscriptionViewModel(accountId);
            tempSubscriptions = new List<SubscriptionRecipient__c>();

            subscriptionToInsert = new Subscription__c(CustomAccount__c = accountId);
            
            SubscriptionRecipient__c recipient = new SubscriptionRecipient__c();
            recipient.Index__c = 1;
            tempSubscriptions.add(recipient);

            viewModel.creditCardBean.cvc = '';
            calculateSize();
        }
        pageInit();
    }

    private void pageInit() {
        isChooseCreditcard = false;
        showProgramResult = false;
        showErrorForNullProgram = false;
    }

    public PageReference newSubscription() {
        if (programId == null) {
            showErrorForNullProgram = true;
            return null;
        }
        SubscriptionRecipient__c recipient = new SubscriptionRecipient__c();
        recipient.Index__c = tempSubscriptions.size() + 1;
        tempSubscriptions.add(recipient);
        calculateSize();
        programPriceDecide();
        return null;
    }

    public PageReference deleteSubscription() {
        Integer indexForRemove;
        
        for (Integer i=0; i<tempSubscriptions.size(); i++) 
            if (tempSubscriptions.get(i).Index__c == deleteRowId) 
               indexForRemove = i;
            
        tempSubscriptions.remove(indexForRemove);
        
        for (Integer i=0; i<tempSubscriptions.size(); i++) 
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

     public List<Product2> getProgramInfo() {
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
        
        if (!checkField()) 
            return null;
        
        insertSubscriptionPriceAndProgram();
        if (viewModel.newSubscription(subscriptionToInsert)) {
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
        if (subscriptionToInsert.Start_period__c != null)  
       		subscriptionToInsert.End_period__c = subscriptionToInsert.Start_period__c + subscriptionToInsert.Program__r.Order_Period__c;     
    }

   private void insertSubscriptionPriceAndProgram() {
        List<SubscriptionProgram__c> programs = SubscriptionModel.getProgramById(programId);

        subscriptionToInsert.Start_period__c = startPeriod;
        subscriptionToInsert.End_period__c = startPeriod + programs.get(0).Order_Period__c - 1;
        subscriptionToInsert.Amount__c = programPrice;      
        subscriptionToInsert.Program__c = programs.get(0).id;
        subscriptionToInsert.CustomAccount__c = viewModel.account.Id;
        
    }

    private Boolean checkField() {
        if (startPeriod == null) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_PeriodEmpty);
            return false;
        }
        
        for (SubscriptionRecipient__c recipient : tempSubscriptions) {
            if (recipient.Recipient__c == null || recipient.City_picklist__c == null || recipient.Area_picklist__c == null || 
                    recipient.Address__c == null || recipient.Tel__c == null ) {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_RecipientInfoEmpty);
                return false;
            }

            if (!checkPhoneFormat(recipient.Tel__c)){
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_PhoneFormat);
                return false;
            }
            
            if (subscriptionToInsert.Payment_method__c == null) {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_PaymentEmpty);
                return false;
            }
                
            if (subscriptionToInsert.Payment_method__c == '信用卡') 
                return isFieldFilledWhenChoosenCard();   
        }
        return true; 
    }

    private Boolean isFieldFilledWhenChoosenCard() {
        if (subscriptionToInsert.Payment_method__c == '信用卡' && viewModel.account.credit_card_number__c == null) {
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
}