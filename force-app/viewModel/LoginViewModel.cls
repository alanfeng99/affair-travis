public with sharing class LoginViewModel {

    public Account account {get; set;}
    public String sessionString {get; set;}
    
    public LoginViewModel() {
        account = new Account();
    }   
}