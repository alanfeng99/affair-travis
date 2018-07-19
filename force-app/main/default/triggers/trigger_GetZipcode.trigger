trigger trigger_GetZipcode on Subscription__c (before insert, before update) {
    /*for(Subscription__c subscription : Trigger.new) {    
        String city = subscription.City_pickList__c;
        String area = subscription.Area_pickList__c; 
        subscription.Postal_code__c = AddressModel.getZipCodeByArea(city, area);   
    }*/
}