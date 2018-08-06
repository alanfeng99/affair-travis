global class ScheduledCron implements Schedulable {
    global static String scheduleIt(String name, String cronExpr) {
        ScheduledCron job = new ScheduledCron();
        return System.schedule(name, cronExpr, job);
    }

    global void execute(SchedulableContext SC) {
        List<Product2> lastestProduct = [SELECT id, ProductCode, Name, StartDate__c, EndDate__c FROM Product2 ORDER BY ProductCode DESC];
        String productCode = String.valueOf(Integer.valueOf(lastestProduct.get(0).ProductCode) +1);
        Date originalStartDate = lastestProduct.get(0).StartDate__c.addMonths(1);
        String configDate = '10';
        Date startDate = date.newInstance(originalStartDate.year(), originalStartDate.month(), Integer.valueOf(configDate));
        Date endDate = date.newInstance(originalStartDate.year(), originalStartDate.addMonths(1).month(), Integer.valueOf(configDate)-1);
        Product2 product = new Product2(ProductCode = productCode, Name = '第'+ productCode +'期', StartDate__c = startDate, EndDate__c = endDate);   
        insert product;
    }
}