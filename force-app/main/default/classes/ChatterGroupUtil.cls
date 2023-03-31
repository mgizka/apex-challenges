public class ChatterGroupUtil {

    @future
    public static void addMembers(String groupName, Set<Id> users) {

        List<CollaborationGroup> chatterGroup = [SELECT Id FROM CollaborationGroup where Name=:groupName];

        if (chatterGroup.isEmpty())
            throw new AdminsGroupException(groupName+' Collaboration Group doesn\'t exists');

        List<CollaborationGroupMember> groupMembers = new List<CollaborationGroupMember>();

        for(Id userId : users){
            groupMembers.add(new CollaborationGroupMember(MemberId=userId, CollaborationGroupId=chatterGroup[0].Id, CollaborationRole='Standard'));
        }

        if(!groupMembers.isEmpty())
                insert groupMembers;

        List<FeedItem> feedItems = new List<FeedItem>();

        for(User user : [SELECT Name FROM User WHERE Id= :users ]){
            feedItems.add(new FeedItem(ParentId=chatterGroup[0].Id, Body = 'Hello '+user.Name));
        }

        if (!feedItems.isEmpty())
            insert feedItems;
    }
}