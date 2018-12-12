global class ShippingNavigatorController {
    @AuraEnabled
    @RemoteAction
    global static List<ShippingNavigatorController.LocationWrapper> getOrders() {
        
        List<Order> orders = OrderRepositiry.getOrders();
        
        List<LocationWrapper> locations = new List<LocationWrapper>();
        
        locations.addAll(getStocks());
        
        if (!orders.isEmpty()) {
            for (Order o : orders) {
                LocationWrapper wrap = new LocationWrapper('' + o.ShippingStreet + '\n' + o.ShippingCity + '\n' + 'Amount: ' + o.TotalAmount + UserInfo.getDefaultCurrency(), o.ShippingLatitude + '-$-' + o.ShippingLongitude);
                locations.add(wrap);
            }
        }
        
        return locations;
    }
    
    private static List<LocationWrapper> getStocks() {
        Map<String,StockLocations__c> stockMap = StockLocations__c.getAll();
        List<LocationWrapper> locations = new List<LocationWrapper>();
        if (stockMap != null) { 
            for (StockLocations__c sl : stockMap.values()) {
                LocationWrapper wrap = new LocationWrapper('__STOCK__\n' + sl.Street__c  + '\n' + sl.Sity__c, sl.Latitude__c + '-$-' + sl.Longitude__c);
                locations.add(wrap);          
            }
        }
        return locations;
    }
    
    public List<Double> getLocation() {
        Map<String,StockLocations__c> stockMap = StockLocations__c.getAll();
        List<Double> coord = new List<Double>();
        if (stockMap != null) {
            Double lat = 0;
            Double lng = 0;
            for (StockLocations__c sl : stockMap.values()) {
                lat += (Double) sl.Latitude__c;
                lng += (Double) sl.Longitude__c;
            }
            Integer stockCount = stockMap.values().size();
            
            coord.add((Double) lat/stockCount);
            coord.add((Double) lng/stockCount);
        } else {
            coord.add((Double) 41.88088500);
            coord.add((Double) -87.62652200);
        }
        
        return coord;
    }
    
    global class LocationWrapper {
        @AuraEnabled
        public String address { get; set; }
        @AuraEnabled
        public String coordinates { get; set; }
        public LocationWrapper(String address, String coordinates) {
            this.address = address;
           	this.coordinates = coordinates;
        }
    }
}