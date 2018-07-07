public with sharing class AddressModel {

    private static List<String> uniqueCities {get; set;}

    public AddressModel() {

    }
      
    public static String getZipCodeByArea(String city, String area) {
        Address__c zipCodes = new Address__c();
        zipCodes = [SELECT id, City__c, Area__c, Zipcode__c FROM Address__c WHERE City__c =:city AND Area__c =: area LIMIT 1];

        if(zipCodes == null) {
            return null;
        }
        
        return zipCodes.Zipcode__c;
    }

    
}