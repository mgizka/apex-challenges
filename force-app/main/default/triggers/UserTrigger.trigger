trigger UserTrigger on User (after insert) {

    if (Trigger.isInsert) {
        if (Trigger.isAfter){

            List<GroupMember> adminsMembers = new List<GroupMember>();
            List<GroupMember> allUsersMembers = new List<GroupMember>();

            Profile adminProfile = [SELECT Id from Profile WHERE Name = 'System Administrator'];

            List<Group> adminGroup = [SELECT Id FROM Group where DeveloperName='Admins'];
            List<Group> allUsersGroup = [SELECT Id FROM Group where DeveloperName='All_Users'];
            

            if (adminGroup.isEmpty())
                throw new AdminsGroupException('Admins Public Group doesn\'t exists');

            if (allUsersGroup.isEmpty())
                throw new AdminsGroupException('all_Users Public Group doesn\'t exists');    

            for(User user : Trigger.new){

                if(user.ProfileId==adminProfile.Id && user.IsActive)
                    adminsMembers.add( new GroupMember(UserOrGroupId=user.Id, GroupId= adminGroup[0].Id));

                allUsersMembers.add( new GroupMember(UserOrGroupId=user.Id, GroupId= allUsersGroup[0].Id));
            }

            if (!adminsMembers.isEmpty())
                insert adminsMembers;
            
            if (!allUsersMembers.isEmpty())
                insert allUsersMembers;

            ChatterGroupUtil.addMembers('Users', Trigger.newMap.keySet());

        }
    }
}