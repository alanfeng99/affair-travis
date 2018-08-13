global class CheckPaymentJob implements Schedulable {

    global static String scheduleIt(String name, String cronExpr) {
        CheckPaymentJob job = new CheckPaymentJob();
        return System.schedule(name, cronExpr, job);
    }
  
    global void execute(SchedulableContext sc) {
        System.debug('Cron executed at ' + Datetime.now().format('yyyyMMddHHmmss'));
        checkPayment();
    }

    public void checkPayment() {
        List<Subscription__c> subscriptions = 
            [SELECT Id
            FROM Subscription__c 
            WHERE Payment_method__c != :Constants.PAYMENT_METHOD_CREDIT_CARD
            AND Payment_Status__c = :Constants.PAYMENT_STATUS_PENDING
            LIMIT 10];
        
        if (subscriptions.size() <= 0)
            return;

        List<Id> subIds = new List<Id>();
        for (Subscription__c sub : subscriptions)
            subIds.add(sub.Id);

        List<SubscriptionGMOPaymentBean__c> subGmoPaymentBeans = [SELECT SubscriptionId__c, GMOPaymentBeanId__c 
                                                                FROM SubscriptionGMOPaymentBean__c 
                                                                WHERE SubscriptionId__c in :subIds];

        List<Id> gmoPaymentBeanIds = new List<Id>();
        for (SubscriptionGMOPaymentBean__c subGmoPaymentBean : subGmoPaymentBeans)
            gmoPaymentBeanIds.add(subGmoPaymentBean.GMOPaymentBeanId__c);

        List<GMOPaymentBean__c> gmoPaymentBeans = [SELECT trans_code__c
                                                FROM GMOPaymentBean__c
                                                WHERE Id in :gmoPaymentBeanIds];
        
        for (Subscription__c subscription : subscriptions) {
            Id gmoPaymentBeanId = findGMOPaymentBeanIdGivenSubscription(subGmoPaymentBeans, subscription.Id);
            GMOPaymentBean__c gmoPaymentBean = findGMOPaymentBeanObject(gmoPaymentBeans, gmoPaymentBeanId);

            CheckPaymentBatchJob job = new CheckPaymentBatchJob(subscription, gmoPaymentBean.trans_code__c);
            Database.executeBatch(job);
        }    
    }

    public Id findGMOPaymentBeanIdGivenSubscription(List<SubscriptionGMOPaymentBean__c> subGmoPaymentBeans, Id subscriptionId) {
        for (SubscriptionGMOPaymentBean__c subGmoPaymentBean : subGmoPaymentBeans)
            if (subGmoPaymentBean.SubscriptionId__c == subscriptionId)
                return subGmoPaymentBean.GMOPaymentBeanId__c;
        return null;
    }

    public GMOPaymentBean__c findGMOPaymentBeanObject(List<GMOPaymentBean__c> gmoPaymentBeans, Id gmoPaymentBeanId) {
        for (GMOPaymentBean__c gmoPaymentBean : gmoPaymentBeans)
            if (gmoPaymentBean.Id == gmoPaymentBeanId)
                return gmoPaymentBean;
        return null;
    }
}
