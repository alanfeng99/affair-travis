@isTest
public with sharing class TestAccountModel {
    public static testMethod void testGetAccountById() {
            Account__c account = new Account__c(LastName__c = 'Alan', Email__c = 'alan@gmail.com');
            insert account;
            Account__c accountVerify = AccountModel.getAccountById(account.Id);
            System.assertEquals('Alan', accountVerify.LastName__c);
    }

    public static testMethod void testGetAccountByEmail_notfound() {
        Account__c account = AccountModel.getAccountByEmail('xxxx@gmail.com');
        System.assertEquals(null, account);
    }

    public static testMethod void testGetAccountByEmail_found() {
        Account__c account = new Account__c(LastName__c = 'Alan', Email__c = 'alan@gmail.com');
        insert account;
        Account__c accountToVerify = AccountModel.getAccountByEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testGetAccountByGoogleEmail_notfound() {
        Account__c account = AccountModel.getAccountByGoogleEmail('xxxx@gmail.com');
        System.assertEquals(null, account);
    }

    public static testMethod void testGetAccountByGoogleEmail_Both_found() {
        Account__c account = new Account__c(Email__c = 'alan@gmail.com', GoogleEmail__c= 'alan@gmail.com');
        insert account;
        Account__c accountToVerify = AccountModel.getAccountByGoogleEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testGetAccountByGoogleEmail_OnlyEmail_found() {
        Account__c account = new Account__c(Email__c = 'alan@gmail.com');
        insert account;
        Account__c accountToVerify = AccountModel.getAccountByGoogleEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testGetAccountByFacebookEmail_notfound() {
        Account__c account = AccountModel.getAccountByFacebookEmail('xxxx@gmail.com');
        System.assertEquals(null, account);
    }

    public static testMethod void testGetAccountByFacebookEmail_Both_found() {
        Account__c account = new Account__c(Email__c = 'alan@gmail.com',FacebookEmail__c= 'alan@gmail.com');
        insert account;
        Account__c accountToVerify = AccountModel.getAccountByFacebookEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testGetAccountByFacebookEmail_OnlyEmail_found() {
        Account__c account = new Account__c(Email__c = 'alan@gmail.com');
        insert account;
        Account__c accountToVerify = AccountModel.getAccountByFacebookEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testAccountLockedForThreeTime() {
        Account__c account = new Account__c(Email__c = 'xxx@gmail.com');
        insert account;
        AccountModel.lockAccountForThreeTimes(account);

        System.assertEquals(true, account.Locked__c);
    }

    public static testMethod void testAccountSaveToken() {
        Account__c account = new Account__c(Email__c = 'xx@gmail.com');
        insert account;
        String token = AccountModel.saveToken(account);
        System.assertEquals(token, account.Token__c);
    }

    public static testMethod void testAccountUpdate() {
        Account__c account = new Account__c(Email__c = 'rr@gmail.com', LastName__c = 'Jin');
        insert account;
        account.LastName__c = 'Eva';
        Boolean accountResult = AccountModel.updateAccount(account);
        System.assertEquals('Eva', account.LastName__c);
        System.assertEquals(true, accountResult);     
    }

    public static testMethod void testCreateAccountByEmail_AccountExist_ReturnNull() {
        Account__c account = new Account__c(Email__c = 'jin@4idps.com');
        insert account;
        Account__c newAccount = AccountModel.createAccountByEmail('jin@4idps.com');
        System.assertEquals(null, newAccount);
    }

    public static testMethod void testCreateAccountByEmail() {
        Account__c newAccount = AccountModel.createAccountByEmail('22@gmail.com');
        System.assertNotEquals(null,newAccount);
    }

    public static testMethod void testCreateAccountByFacebook_AccountExist_ReturnNull() {
        Account__c account = new Account__c(Email__c = 'jin@gmail.com');
        insert account;
        Account__c newAccount = AccountModel.createAccountByFacebook('jin@gmail.com','jin');
        System.assertEquals(null, newAccount);
    }

    public static testMethod void testCreateAccountByFacebook() {
        Account__c newAccount = AccountModel.createAccountByFacebook('jin@gmail.com','jin');
        System.assertNotEquals(null, newAccount);
    }

    public static testMethod void testCreateAccountByGoogle_AccountExist_ReturnNull() {
        Account__c account = new Account__c(Email__c = 'jin@gmail.com');
        insert account;
        Account__c newAccount = AccountModel.createAccountByGoogle('jin@gmail.com','jin');
        System.assertEquals(null, newAccount);
    }

    public static testMethod void testCreateAccountByGoogle() {
        Account__c newAccount = AccountModel.createAccountByGoogle('jin@gmail.com','jin');
        System.assertNotEquals(null, newAccount);
    }
}
