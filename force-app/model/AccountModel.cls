public with sharing class AccountModel {
    public static Account getAccountById(String userId) {
        return [Select Active__c, Account_ID__c, Locked__c, PersonEmail, PasswordRetry__c, AccountNumber, LastName, Password__c, JoinDate__c, GoogleEmail__c, FacebookEmail__c, credit_card_number__c from Account where Id = :userId];
    }

    public static Account getAccountByEmail(String email) {
        List<Account> accounts = [Select Id, PasswordRetry__c, Account_ID__c, Locked__c, AccountNumber, Active__c, PersonEmail, LastName, Password__c, GoogleEmail__c, FacebookEmail__c from Account where PersonEmail = :email];
        if (accounts.size() == 1) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static Account getAccountByGoogleEmail(String googleEmail) {
        List<Account> accounts = [Select Id, PasswordRetry__c, Account_ID__c, Locked__c, AccountNumber, Active__c, PersonEmail, LastName, Password__c, GoogleEmail__c, FacebookEmail__c from Account where GoogleEmail__c = :googleEmail OR PersonEmail = :googleEmail];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static Account getAccountByFacebookEmail(String facebookEmail) {
        List<Account> accounts = [Select Id, PasswordRetry__c, Account_ID__c, Locked__c, AccountNumber, Active__c, PersonEmail, LastName, Password__c, GoogleEmail__c, FacebookEmail__c from Account where FacebookEmail__c = :facebookEmail OR PersonEmail = :facebookEmail];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static Account getAccountByOnlyGoogleEmail(String googleEmail) {
        List<Account> accounts = [Select Id, PasswordRetry__c, Account_ID__c, Locked__c, AccountNumber, Active__c, PersonEmail, LastName, Password__c, GoogleEmail__c, FacebookEmail__c from Account where GoogleEmail__c = :googleEmail];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static Account getAccountByOnlyFacebookEmail(String facebookEmail) {
        List<Account> accounts = [Select Id, PasswordRetry__c, Account_ID__c, Locked__c, AccountNumber, Active__c, PersonEmail, LastName, Password__c, GoogleEmail__c, FacebookEmail__c from Account where FacebookEmail__c = :facebookEmail];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static void lockAccountForThreeTimes(Account account) {
        account.Locked__c = true;
        account.PasswordRetry__c = 0;
        update account;
    }

    public static String saveToken(Account account) {
        String token = AuthUtility.generateToken();
        account.Token__c = token;
        update account;
        return token;
    }

    public static Boolean updateAccount(Account account) {
        Database.SaveResult result = Database.update(account); 
        return result.isSuccess();
    }

    public static Account createAccountByEmail(String email) {
        List<Account> accounts = [Select Id from Account where PersonEmail = :email];
        if (accounts.size() > 0)
            return null;

        Account account = new Account(PersonEmail = email, LastName = email);
        insert account;
        
        return account;
    }

    public static Account createAccountByFacebook(String email, String lastName) {
        List<Account> accounts = [Select Id from Account where FacebookEmail__c = :email OR PersonEmail = :email];
        if (accounts.size() > 0)
            return null;
        
        Account account = new Account(PersonEmail = email, LastName = lastName, FacebookEmail__c = email, Active__c = true);
        insert account;

        return account;
    }

    public static Account createAccountByGoogle(String email, String lastName) {
        List<Account> accounts = [Select Id from Account where GoogleEmail__c = :email OR PersonEmail = :email];
        if (accounts.size() > 0)
            return null;
        
        Account account = new Account(PersonEmail = email, LastName = lastName, GoogleEmail__c = email, Active__c = true);
        insert account;

        return account;
    }
}