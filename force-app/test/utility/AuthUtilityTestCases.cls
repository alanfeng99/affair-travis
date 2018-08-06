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

    public static testMethod void testDeleteAuthCoookies() {
        Account realAccount = new Account(LastName = 'jin');
        insert realAccount;
        String token = AccountModel.saveToken(realAccount);
        Cookie authToken = new Cookie(Label.COOKIE_AUTH_TOKEN, token, null, Constants.COOKIE_DURATION, false);
        Cookie accountId = new Cookie(label.COOKIE_ACCOUNT_ID, realAccount.Id, null, Constants.COOKIE_DURATION, false);
        ApexPages.currentPage().setCookies(new Cookie[]{authToken, accountId}); 
        AuthUtility.deleteAuthCookies();
        Pagereference currentPage = ApexPages.currentPage();
        System.assertNotEquals(currentPage.getCookies().get(Label.COOKIE_AUTH_TOKEN), authToken);
    }
}