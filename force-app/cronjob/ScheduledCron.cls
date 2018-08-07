global class ScheduledCron implements Schedulable {
    global static String scheduleIt(String name, String cronExpr) {
        ScheduledCron job = new ScheduledCron();
        return System.schedule(name, cronExpr, job);
    }

    global void execute(SchedulableContext SC) {
        Product2 lastestProduct = [SELECT id, ProductCode, Name, StartDate__c, EndDate__c FROM Product2 ORDER BY StartDate__c DESC LIMIT 1];
        Integer lastestProductCode = Integer.valueOf(lastestProduct.ProductCode);   

        String productCode = String.valueOf(lastestProductCode + 1);
        Date originalStartDate = lastestProduct.StartDate__c.addMonths(1);
        String configDate = System.Label.Msg_ProductStartDate;
        Date startDate = date.newInstance(originalStartDate.year(), originalStartDate.month(), Integer.valueOf(configDate));
        Date endDate = date.newInstance(originalStartDate.year(), originalStartDate.addMonths(1).month(), Integer.valueOf(configDate)-1);
        Product2 product = new Product2(ProductCode = productCode, Name = '第'+ productCode +'期', StartDate__c = startDate, EndDate__c = endDate);   
        insert product;
    }
}