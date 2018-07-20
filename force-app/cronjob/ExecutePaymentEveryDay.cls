global class ExecutePaymentEveryDay implements Schedulable {

    // Every 1 hour cause Salesforce does not execute more often than hour even if trick possible
    public static String CRON_EXPR = '0 0 0/1 1/1 * ? *';
    /*
    0 0 0 ? * * *	at 12:00 AM every day
0 0 10 ? * *	at 10.00 AM every day
0 0 10 * * ?	at 10.00 AM every day
0 0 10 * * ? *	at 10.00 AM every day
0 0 15 ? * * *	at 3:00 PM every day
0 0-5 15 * * ?	Every minute starting at 3:00 PM and ending at 3:05 PM, every day
0 15 17 ? * MON-FRI	at 5:15 PM every Monday, Tuesday, Wednesday, Thursday and Friday
0 15 10 15 * ?	at 5:15 PM on the 15th day of every month
0 15 17 ? * 6#3	at 5:15 PM on the third Friday of every month
0 0 18 ? * 6L	runs the last Friday of every month at 6:00 PM.
‘0 30 * * * *’;	every 30 minutes
0 0 12 * * ?	at 12:00 PM every day
0 0 23 * * ? 2016	runs every day at 11:00 PM during the year 2016.*/
   
    global static String scheduleIt() {
        ExecutePaymentEveryDay job = new ExecutePaymentEveryDay();
        return System.schedule('Execute daily payment', CRON_EXPR, job);
    }
  
    global void execute(SchedulableContext sc) {
        System.debug('Cron executed at ' + Datetime.now().format('yyyyMMddHHmmss'));
        checkDailyPaymentForEveryUsers();
    }

    public void checkDailyPaymentForEveryUsers() {
        List<Account__c> accounts = [SELECT Id, LastName__c, Email__c FROM Account__c];
        if (accounts.size() <= 0)
            return;

        for (Account__c account : accounts) {
            List<Subscription__c> subscriptions = [SELECT ID, Start_period__c, End_period__c, Program__c, Amount__c FROM Subscription__c WHERE CustomAccount__c = :account.Id];
            if (subscriptions.size() > 0) {
                for (Subscription__c subscription : subscriptions) {
                    if (subscription.Payment_method__c == '信用卡') {
                        List<Product2> products = [SELECT Id, EndDate__c FROM Product2 WHERE ProductCode = :String.valueOf(subscription.End_period__c)];
                        if (products.size() == 1) {
                            Date dateNow = Date.today();
                            Date productEndDate = Date.valueOf(products.get(0).EndDate__c);
                            if (dateNow >= productEndDate) {
                                GMOPaymentBean__c gmoPaymentBean = ApexUtility.generateGMOPaymentBean(account, subscription);
                                GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);
                                gmoPaymentAPI.executePayment();
                                
                                SubscriptionProgram__c program = [SELECT Order_Period__c FROM SubscriptionProgram__c WHERE ID = :subscription.Program__c];
                                subscription.Start_period__c = subscription.End_period__c + 1;
                                subscription.End_period__c += program.Order_Period__c;
                                update subscription;
                            }
                        }
                    }
                }
            }
        }
    }
}
