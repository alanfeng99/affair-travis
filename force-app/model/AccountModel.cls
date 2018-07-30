public with sharing class AccountModel {
    public static Account__c getAccountById(String userId) {
        return [Select Active__c, Locked__c, Email__c, PasswordRetry__c, Name, LastName__c, Password__c, JoinDate__c, GoogleEmail__c, FacebookEmail__c, credit_card_number__c from Account__c where Id = :userId];
    }

    public static Account__c getAccountByEmail(String email) {
        List<Account__c> accounts = [Select Id, PasswordRetry__c, Locked__c, Name, Active__c, Email__c, LastName__c, Password__c, GoogleEmail__c, FacebookEmail__c from Account__c where Email__c = :email];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static Account__c getAccountByGoogleEmail(String googleEmail) {
        List<Account__c> accounts = [Select Id, PasswordRetry__c, Locked__c, Name, Active__c, Email__c, LastName__c, Password__c, GoogleEmail__c, FacebookEmail__c from Account__c where GoogleEmail__c = :googleEmail OR Email__c = :googleEmail];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static Account__c getAccountByFacebookEmail(String facebookEmail) {
        List<Account__c> accounts = [Select Id, PasswordRetry__c, Locked__c, Name, Active__c, Email__c, LastName__c, Password__c, GoogleEmail__c, FacebookEmail__c from Account__c where FacebookEmail__c = :facebookEmail OR Email__c = :facebookEmail];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static void lockAccountForThreeTimes(Account__c account) {
        account.Locked__c = true;
        account.PasswordRetry__c = 0;
        update account;
    }

    public static String saveToken(Account__c account) {
        String token = AuthUtility.generateToken();
        account.Token__c = token;
        update account;
        return token;
    }

    public static Boolean updateAccount(Account__c account) {
        Database.SaveResult result = Database.update(account); 
        return result.isSuccess();
    }

    public static Account__c createAccountByEmail(String email) {
        List<Account__c> accounts = [Select Id from Account__c where Email__c = :email];
        if (accounts.size() > 0)
            return null;

        Account__c account = new Account__c(Email__c = email, LastName__c = email);
        insert account;
        
        return account;
    }

    public static Account__c createAccountByFacebook(String email, String lastName) {
        List<Account__c> accounts = [Select Id from Account__c where FacebookEmail__c = :email OR Email__c = :email];
        if (accounts.size() > 0)
            return null;
        
        Account__c account = new Account__c(Email__c = email, LastName__c = lastName, FacebookEmail__c = email);
        insert account;

        return account;
    }

    public static Account__c createAccountByGoogle(String email, String lastName) {
        List<Account__c> accounts = [Select Id from Account__c where GoogleEmail__c = :email OR Email__c = :email];
        if (accounts.size() > 0)
            return null;
        
        Account__c account = new Account__c(Email__c = email, LastName__c = lastName, GoogleEmail__c = email);
        insert account;

        return account;
    }
}