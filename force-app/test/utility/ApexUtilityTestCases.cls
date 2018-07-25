@isTest
public with sharing class ApexUtilityTestCases {

    public static testMethod void testGenerateRandomAlphaNumeric() {
        String actual = ApexUtility.generateRandomAlphaNumeric(0);
        System.assertEquals('', actual);
    }

    public static testMethod void testGenerateRandomNumeric() {

        String actual = ApexUtility.generateRandomNumeric(0);
        System.assertEquals('', actual);
    }
}