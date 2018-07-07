public with sharing class ProductModel {
    public ProductModel() {

    }

    public static List<Product2> getProduct() {
        Date now = Date.valueOf(System.now());
        Product2 currentProduct = [SELECT id, Name, ProductCode, PicturePath__c, StartDate__c, EndDate__c FROM Product2 WHERE StartDate__c <= :now and EndDate__c >= :now];
        //Product2 currentProduct = products.get(0);
        String nextProduct_Code = String.valueOf(Integer.valueOf(currentProduct.ProductCode)+1);
        Product2 nextProduct = [SELECT id, Name, ProductCode, PicturePath__c FROM Product2 WHERE ProductCode = :nextProduct_Code];
        
        List<Product2> productShow = new List<Product2>();
        productShow.add(currentProduct);
        productShow.add(nextProduct);
        
        return productShow;
    }
}