public class OrderRepositiry {
    public static List<Order> getOrders() {
        return [SELECT Id, TotalAmount, ShippingStreet, ShippingLongitude, ShippingLatitude, ShippingCity, OrderNumber, Status, Contract.Account.Name
                FROM Order
                WHERE Status = 'Activated' LIMIT 10000];
    }
}