public with sharing class NewSubscriptionViewModel {
    private Account__c account {get; set;}
    public Subscription__c firstSubscription {get; set;}
    public List<Subscription__c> tempSubscriptions {get; set;}
    public List<Subscription__c> subscriptionInsertList {get; set;}
    
    
    public String errorMessage {get; set;}
    public Decimal deleteRowId {get; set;}
    public String programId {get; set;}
    public Integer startPeriod {get; set;}
    public Integer subscriptionSize {get; set;}
    public Decimal programTotalPrice {get; set;}
    public Decimal programPrice {get; set;}
    public Boolean showProgramResult {get; set;}
    public Boolean showErrorForNullProgram {get; set;}
    public String programName {get; set;}

    public NewSubscriptionViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
        tempSubscriptions = new List<Subscription__c>();

        firstSubscription = new Subscription__c(CustomAccount__c = accountId);
        firstSubscription.Index__c = 1;
        tempSubscriptions.add(firstSubscription);
        calculateSize();
        showProgramResult = false;
        showErrorForNullProgram = false;

        account.CVC__c = '';
    }

    public Account__c getAccount() {
        return account;
    }

    public PageReference newSubscription() {
        if(programId == null) {
            showErrorForNullProgram = true;
            return null;
        }

        Subscription__c subscription = new Subscription__c(CustomAccount__c = account.Id);
        subscription.Index__c = tempSubscriptions.size() + 1;
      
        tempSubscriptions.add(subscription);
        calculateSize();
        programPriceDecide();
        return null;
    }
    
    public PageReference deleteSubscription() {
        Integer indexForRemove ;
        
        for(Integer i=0; i<tempSubscriptions.size(); i++) {
            if(tempSubscriptions.get(i).Index__c == deleteRowId) {
               indexForRemove = i;
            }
        }
        
        tempSubscriptions.remove(indexForRemove);
        
        for(Integer i=0; i<tempSubscriptions.size(); i++) {
            tempSubscriptions.get(i).Index__c = i+1;
        }

        calculateSize();
        programPriceDecide();
        return null;
    }
        
    public Boolean submit() {
        try {
            newSubscriptionInsertList();
            if(programId != null){
                if( checkField() == false) {
                    return false;
                }
                insertSubscriptionPriceAndProgram();
                
                account.credit_card_number__c = EncryptionUtility.encrypt(account.credit_card_number__c);

                List<Database.SaveResult> results = Database.insert(subscriptionInsertList);
                Boolean updateResult = true;
                for(Database.SaveResult result : results) {
                    if (result.isSuccess() == false) {
                        updateResult = false;
                    } 
                }
                if(updateResult)
                    update account;
                return updateResult;
            } else {
                errorMessage = '請選擇訂閱方案';
                return false;
            }
            
        } catch (DmlException ex) {
            errorMessage = ex.getMessage();
            return false;
        }
    }

    public List<SelectOption> getProgramSelection() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--- 請選擇 ---'));
        for(SubscriptionProgram__c program : SubscriptionModel.getProgram()) {
            options.add(new SelectOption(program.ProgramId__c, program.ProgramName__c));
        }
        
        return options;
    }

    public Pagereference programPriceDecide() {
        List<SubscriptionProgram__c> programs = SubscriptionModel.getProgram(programId);
        
        programPrice = programs.get(0).Price__c;   
        programName = programs.get(0).ProgramName__c;
        programTotalPrice = programPrice * subscriptionSize;
        showProgramResult = true;
        showErrorForNullProgram = false;
        return null;
    }
    
    public List<Product2> getProgramInfo() {
        return ProductModel.getProduct(); 
    }
    
    public List<SelectOption> getProductRadioButton() {
        List<SelectOption> options = new List<SelectOption>();
        List<Product2> products = ProductModel.getProduct();
        for(Product2 product : products) {
        	options.add(new SelectOption(product.ProductCode, product.Name));    
        }
        
        return options;
    }

    private void newSubscriptionInsertList() {
        subscriptionInsertList = new List<Subscription__c>();

        for(Subscription__c sub : tempSubscriptions) {
            Subscription__c clone_Subscription = firstSubscription.clone();
            clone_Subscription.Recipient__c = sub.Recipient__c;
            clone_Subscription.Address__c = sub.Address__c;
            clone_Subscription.Area_pickList__c = sub.Area_pickList__c;
            clone_Subscription.Postal_code__c = sub.Postal_code__c;
            clone_Subscription.City_pickList__c = sub.City_pickList__c;
            clone_Subscription.Tel__c = sub.Tel__c;

            subscriptionInsertList.add(clone_Subscription);
        }
    }
    
    private Boolean checkField() {
        Boolean result = false;
        for(Subscription__c sub : subscriptionInsertList) {
            if(startPeriod == null) {
                errorMessage = '請點選欲開始的週刊期數';
            } else if (sub.Recipient__c == null) {
                errorMessage = '請填寫收件人';  
            } else if (sub.City_picklist__c == null || sub.Area_picklist__c == null || sub.Address__c == null) {
                errorMessage = '請填寫地址';
            } else if (sub.Tel__c == null) {
                errorMessage = '請填寫電話';
            } else if (sub.Payment_method__c == null) {
                errorMessage = '請選擇付款方式';
            } else if (!isFieldFilledWhenChoosenCard()) {
                
            } else {
                result = true;
            }
        }

        return result; 
    }

    private boolean isCreditCardPattenMatching(String str){
        Pattern MyPattern = Pattern.compile('^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$');
        Matcher MyMatcher = MyPattern.matcher(str);

        return MyMatcher.matches();
    }

    private Boolean isFieldFilledWhenChoosenCard() {
        Boolean result = true;
        for(Subscription__c sub : subscriptionInsertList) {
            if(sub.Payment_method__c == '信用卡') {
                if(account.credit_card_number__c == null || account.Expiration_Year_text__c == null || 
                    account.Expiration_month__c == null || account.CVC__c == null) {
                    errorMessage = '如要使用信用卡付款，請填寫完整信用卡資訊';
                    result = false;
                } else if(!isCVCPattenMatching(account.CVC__c)) {
                    errorMessage = 'CVC需3碼(數字)';
                    result = false;
                } else if(!isCreditCardPattenMatching(account.credit_card_number__c)) {
                    errorMessage = '請檢查信用卡號是否正確';
                    result = false;
                }
            }
        }

        return result;
    }

    private boolean isCVCPattenMatching(String str){
        Pattern MyPattern = Pattern.compile('[1-9][0-9]{2}');
        Matcher MyMatcher = MyPattern.matcher(str);

        return MyMatcher.matches();
    }

    private void calculateSize() {
        subscriptionSize = tempSubscriptions.size();
    }

    private void calculatePeriod() {
        if(firstSubscription.Start_period__c != null) {
            
       		firstSubscription.End_period__c = firstSubscription.Start_period__c + firstSubscription.Program__r.Order_Period__c;    
        }
    }

    private void insertSubscriptionPriceAndProgram() {
        List<SubscriptionProgram__c> programs = SubscriptionModel.getProgram(programId);
        
        for(Subscription__c sub : subscriptionInsertList) {
            sub.Start_period__c = startPeriod;
            sub.End_period__c = startPeriod + programs.get(0).Order_Period__c;
            sub.Amount__c = programPrice;      
            sub.Program__c = programs.get(0).id;
            sub.CustomAccount__c = account.Id;
        }
        
    }
}