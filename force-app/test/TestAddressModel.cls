@isTest
public with sharing class TestAddressModel {
    public static testMethod void testGetZipCodeByArea_ReturnNull() {
        String zipcode = AddressModel.getZipCodeByArea('台北市','松山區' );
        System.assertEquals(null, zipcode);
    }

    public static testMethod void testGetZipCodeByArea() {
         Address__c address = new Address__c(City__c = '台北市', Area__c = '松山區', Zipcode__c = '105');
         insert address;
        String zipcode = AddressModel.getZipCodeByArea('台北市','松山區' );
        System.assertNotEquals(null, zipcode );
    }
}
