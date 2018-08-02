public with sharing class RegisterViewModel {
    public Account account {get; set;}
    public String email {get; set;}

    public enum RegisterType {
        Email,
        Facebook,
        Google
    }

    public RegisterViewModel() {
        account = new Account();
    }
}