public with sharing class AddressModel {
    public static String getZipCodeByArea(String city, String area) {
        List<Address__c> zipCodes = [SELECT id, City__c, Area__c, Zipcode__c FROM Address__c WHERE City__c =:city AND Area__c =: area LIMIT 1];
        if (zipCodes.size() <= 0) 
            return null;
        
        return zipCodes.get(0).Zipcode__c;
    }   
}