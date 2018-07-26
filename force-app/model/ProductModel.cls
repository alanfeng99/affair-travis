public with sharing class ProductModel {
    public static List<Product2> getProduct() {
        Date now = Date.valueOf(System.now().format('yyyy-MM-dd'));
        List<Product2> currentProducts = [SELECT id, Name, ProductCode, PicturePath__c, StartDate__c, EndDate__c FROM Product2 WHERE StartDate__c <= :now and EndDate__c >= :now];
        if (currentProducts.size() <= 0)
            return null;
        
        List<Product2> productShow = new List<Product2>();
        Product2 currentProduct = currentProducts.get(0);
        productShow.add(currentProduct);

        String nextProduct_Code = String.valueOf(Integer.valueOf(currentProduct.ProductCode)+1);
        List<Product2> nextProducts = [SELECT id, Name, ProductCode, PicturePath__c FROM Product2 WHERE ProductCode = :nextProduct_Code];
        if (nextProducts.size() <= 0)
            return null;

        Product2 nextProduct = nextProducts.get(0);
        productShow.add(nextProduct);
        
        return productShow;
    }
}