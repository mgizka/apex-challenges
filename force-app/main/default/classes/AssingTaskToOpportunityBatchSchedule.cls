global class AssingTaskToOpportunityBatchSchedule implements Schedulable {
git 
    global void execute(SchedulableContext ctx){

        AssingTaskToOpportunityBatch b = new AssingTaskToOpportunityBatch(); 
        Database.executeBatch(b);    
    }
 
}