@IsTest
public class ShippingNavigatorControllerTest {
    @testSetup 
    static void setup() {
        Account a = new Account(Name = 'Test');
        insert a;
        Contract c = new Contract(
        	Status = 'Draft',
            AccountId = a.Id,
            StartDate = Date.today(),
            ContractTerm = 5
        );
        insert c;
        c.Status = 'Activated';
        update c;
        Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;        
        List<Order> orders = new List<Order>();
        for(Integer i = 0; i < 5; i++) {
            orders.add(new Order(
                AccountId = a.Id,
                ContractId = c.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pricebookId,
                ShippingCity = 'Tets city'
            ));
        }
        insert orders;
        List<OrderItem> oi = new List<OrderItem>();
        for(Order order : orders) {
            oi.add(new OrderItem(
            	Product2Id = prod.Id,
                OrderId = order.Id,
                PricebookEntryId = standardPrice.Id,
                Quantity = 50.0,
                UnitPrice = 15000
            ));
            order.ShippingCity = 'Tets city1';
            order.StatusCode = 'A';
            order.ShippingLatitude = 15.15;
            order.ShippingLongitude = 15.15;
			order.Status = 'Activated';
        }
        insert oi;
        update orders;
        
        insert new StockLocations__c(Name = 'Test', Street__c = 'test', Sity__c = 'Test', Latitude__c = 15.15, Longitude__c = 15.15);
    }
    @IsTest
    public static void testGetOrders() {
        ShippingNavigatorController.LocationWrapper[] orders = ShippingNavigatorController.getOrders('order');
        System.assertEquals(6, orders.size());
        ShippingNavigatorController.LocationWrapper[] accs = ShippingNavigatorController.getOrders('account');
        System.assertEquals(0, accs.size());
    }
    
    @IsTest
    public static void testGetLocation() {
        ShippingNavigatorController controller = new ShippingNavigatorController();
        List<Double> coord = controller.getLocation();
        System.assertEquals(15.15, coord[0]);
    }
}