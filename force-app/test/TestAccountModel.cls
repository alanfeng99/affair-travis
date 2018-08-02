@isTest
public with sharing class TestAccountModel {
    public static testMethod void testGetAccountById() {
            Account account = new Account(LastName = 'Alan', PersonEmail = 'alan@gmail.com');
            preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
            insert account;
            Account accountVerify = AccountModel.getAccountById(account.Id);
            System.assertEquals('Alan', accountVerify.LastName);
    }

    public static testMethod void testGetAccountByEmail_notfound() {
        Account account = AccountModel.getAccountByEmail('xxxx@gmail.com');
        System.assertEquals(null, account);
    }

    public static testMethod void testGetAccountByEmail_found() {
        Account account = new Account(LastName = 'Alan', PersonEmail = 'alan@gmail.com');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        Account accountToVerify = AccountModel.getAccountByEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testGetAccountByGoogleEmail_notfound() {
        Account account = AccountModel.getAccountByGoogleEmail('xxxx@gmail.com');
        System.assertEquals(null, account);
    }

    public static testMethod void testGetAccountByGoogleEmail_Both_found() {
        Account account = new Account(PersonEmail = 'alan@gmail.com', GoogleEmail__c = 'alan@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        Account accountToVerify = AccountModel.getAccountByGoogleEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testGetAccountByGoogleEmail_OnlyEmail_found() {
        Account account = new Account(PersonEmail = 'alan@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        Account accountToVerify = AccountModel.getAccountByGoogleEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testGetAccountByFacebookEmail_notfound() {
        Account account = AccountModel.getAccountByFacebookEmail('xxxx@gmail.com');
        System.assertEquals(null, account);
    }

    public static testMethod void testGetAccountByFacebookEmail_Both_found() {
        Account account = new Account(PersonEmail = 'alan@gmail.com',FacebookEmail__c = 'alan@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        Account accountToVerify = AccountModel.getAccountByFacebookEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testGetAccountByFacebookEmail_OnlyEmail_found() {
        Account account = new Account(PersonEmail = 'alan@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        Account accountToVerify = AccountModel.getAccountByFacebookEmail('alan@gmail.com');
        System.assertNotEquals(null, accountToVerify);
    }

    public static testMethod void testAccountLockedForThreeTime() {
        Account account = new Account(PersonEmail = 'xxx@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        AccountModel.lockAccountForThreeTimes(account);

        System.assertEquals(true, account.Locked__c);
    }

    public static testMethod void testAccountSaveToken() {
        Account account = new Account(PersonEmail = 'xx@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        String token = AccountModel.saveToken(account);
        System.assertEquals(token, account.Token__c);
    }

    public static testMethod void testAccountUpdate() {
        Account account = new Account(PersonEmail = 'rr@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        account.LastName = 'Eva';
        Boolean accountResult = AccountModel.updateAccount(account);
        System.assertEquals('Eva', account.LastName);
        System.assertEquals(true, accountResult);     
    }

    public static testMethod void testCreateAccountByEmail_AccountExist_ReturnNull() {
        Account account = new Account(PersonEmail = 'jin@4idps.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        Account newAccount = AccountModel.createAccountByEmail('jin@4idps.com');
        System.assertEquals(null, newAccount);
    }

    public static testMethod void testCreateAccountByEmail() {
        Account newAccount = AccountModel.createAccountByEmail('22@gmail.com');
        System.assertNotEquals(null,newAccount);
    }

    public static testMethod void testCreateAccountByFacebook_AccountExist_ReturnNull() {
        Account account = new Account(PersonEmail = 'jin@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        Account newAccount = AccountModel.createAccountByFacebook('jin@gmail.com','jin');
        System.assertEquals(null, newAccount);
    }

    public static testMethod void testCreateAccountByFacebook() {
        Account newAccount = AccountModel.createAccountByFacebook('jin@gmail.com','jin');
        System.assertNotEquals(null, newAccount);
    }

    public static testMethod void testCreateAccountByGoogle_AccountExist_ReturnNull() {
        Account account = new Account(PersonEmail = 'jin@gmail.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        Account newAccount = AccountModel.createAccountByGoogle('jin@gmail.com','jin');
        System.assertEquals(null, newAccount);
    }

    public static testMethod void testCreateAccountByGoogle() {
        Account newAccount = AccountModel.createAccountByGoogle('jin@gmail.com','jin');
        System.assertNotEquals(null, newAccount);
    }
}
