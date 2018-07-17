public with sharing class AddressModel {
    public AddressModel() {

    }
      
    public static String getZipCodeByArea(String city, String area) {
        Address__c zipCode = new Address__c();
        zipCode = [SELECT id, City__c, Area__c, Zipcode__c FROM Address__c WHERE City__c =:city AND Area__c =: area LIMIT 1];

        if (zipCode == null) 
            return null;
        
        return zipCode.Zipcode__c;
    }

    
}