@IsTest
public with sharing class AuthUtilityTestCases {
    
    public static testMethod void testCheckPasswordCorrect() {
        Boolean actual = AuthUtility.checkPassword('test@test.com', 'password', 'password');
        System.assertEquals(true, actual);
    }

    public static testMethod void testGenerateTokenLength() {
        String actual = AuthUtility.generateToken();

        System.assertEquals(28, actual.length());
    }
}