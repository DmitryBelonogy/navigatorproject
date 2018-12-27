trigger UpdateCoordinatesAccount on Account (after insert, after update) {
	if (Trigger.IsInsert) {
        System.enqueueJob(new UpdateGeoCoordinates(Trigger.newMap.keySet()));        
    }
    if (Trigger.IsUpdate) {
        Set<Id> accForUpdate = new Set<Id>();
        for (Account acc : Trigger.new) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);            
            if (acc.ShippingCity != oldAcc.ShippingCity || acc.ShippingStreet != oldAcc.ShippingStreet) {
                accForUpdate.add(acc.Id);
            }
        }
        if (!accForUpdate.isEmpty()) System.enqueueJob(new UpdateGeoCoordinates(accForUpdate));        
    }
}