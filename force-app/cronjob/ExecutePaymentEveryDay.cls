global class ExecutePaymentEveryDay implements Schedulable {

    global static String scheduleIt(String name, String cronExpr) {
        ExecutePaymentEveryDay job = new ExecutePaymentEveryDay();
        return System.schedule(name, cronExpr, job);
    }
  
    global void execute(SchedulableContext sc) {
        System.debug('Cron executed at ' + Datetime.now().format('yyyyMMddHHmmss'));
        checkDailyPaymentForEveryUsers();
    }

    public void checkDailyPaymentForEveryUsers() {
        List<Product2> products = [SELECT ProductCode FROM Product2 where EndDate__c <= TODAY];
        List<Decimal> productCodes = new List<Decimal>();

        for (Product2 product : products)
            productCodes.add(Decimal.valueOf(product.ProductCode));

        List<Subscription__c> subscriptions = 
            [SELECT Payment_method__c, Start_period__c, End_period__c, Program__c, Amount__c, AccountStandard__c
            FROM Subscription__c 
            WHERE Payment_method__c = :Constants.PAYMENT_METHOD_CREDIT_CARD
            AND isReplenish__c = true 
            AND End_period__c in :productCodes
            LIMIT 10];
        
        List<Id> accountIds = new List<Id>();
        for (Subscription__c sub : subscriptions)
            accountIds.add(sub.AccountStandard__c);

        List<Account> accounts = [SELECT LastName, PersonEmail FROM Account WHERE Id in :accountIds];
        
        List<SubscriptionProgram__c> programs = [SELECT Order_Period__c, ProgramId__c, Name FROM SubscriptionProgram__c];

        List<Subscription__c> subscriptionsToUpdate = new List<Subscription__c>();
        List<GMOPaymentBean__c> gmoPaymentBeansToInsert = new List<GMOPaymentBean__c>();
        
        if (subscriptions.size() <= 0)
            return;
        
        for (Subscription__c subscription : subscriptions) {
            Account account = findAccount(accounts, subscription.AccountStandard__c);
            SubscriptionProgram__c program = findProgram(programs, subscription.Program__c);
            Order order = new Order();
            order.paymentMethod = subscription.Payment_method__c;
            order.itemCode = program.ProgramId__c;
            order.itemName = program.Name;
            order.totalPrice = String.valueOf(subscription.Amount__c);
            
            PaymentCallBatchJob job = new PaymentCallBatchJob(account, order);
            Database.executeBatch(job);
            
            subscription.Start_period__c = subscription.End_period__c + 1;
            subscription.End_period__c += program.Order_Period__c;
            subscriptionsToUpdate.add(subscription);
        }
        Database.update(subscriptionsToUpdate);
    }

    public Product2 findEndSubscriptionProduct(List<Product2> products, String endPeriod) {
        for (Product2 product : products)
            if (product.ProductCode == endPeriod)
                return product;
        return null;
    }

    public SubscriptionProgram__c findProgram(List<SubscriptionProgram__c> programs, String programId) {
        for (SubscriptionProgram__c program : programs)
            if (program.Id == programId)
                return program;
        return null;
    }

    public Account findAccount(List<Account> accounts, String accountId) {
        for (Account account : accounts)
            if (account.Id == accountId)
                return account;
        return null;
    }
}
