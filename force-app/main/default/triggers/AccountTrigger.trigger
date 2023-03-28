trigger AccountTrigger on Account (before insert) {
    System.debug('test');
}