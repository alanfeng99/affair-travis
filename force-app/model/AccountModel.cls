public with sharing class AccountModel {
    public static Account__c getAccountById(String userId) {
        return [Select Active__c, Locked__c, Email__c, PasswordRetry__c, LastName__c, Password__c, JoinDate__c from Account__c where Id = :userId];
    }

    public static Account__c getAccountByEmail(String email) {
        List<Account__c> accounts = [Select Id, PasswordRetry__c, Locked__c, Active__c, Email__c, LastName__c, Password__c from Account__c where Email__c = :email];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static void lockAccountForThreeTimes(Account__c account) {
        account.Locked__c = true;
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

    public static Account__c createAccountByEmail(String email, String lastName) {
        List<Account__c> accounts = [Select Id from Account__c where Email__c = :email];
        if (accounts.size() > 0)
            return null;
        
        Account__c account = new Account__c(Email__c = email, LastName__c = lastName);
        insert account;

        return account;
    }
}