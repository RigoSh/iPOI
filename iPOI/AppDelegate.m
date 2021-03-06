//
//  AppDelegate.m
//  iPOI
//
//  Created by Rigo on 03/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreData/CoreData.h>
#import <UIApplication+SimulatorRemoteNotifications.h>

static NSString *const kImageAllExpired = @"AllExpired";

@interface AppDelegate (){
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    NSString *googleAPIKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GoogleAPIKey"];
    
    [GMSServices provideAPIKey:googleAPIKey];    
    [GMSPlacesClient provideAPIKey:googleAPIKey];
    
    [self deleteExpiredData];
    
#if DEBUG
    application.remoteNotificationsPort = 9930;     // optional
    [application listenForRemoteNotifications];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - remote notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device token = \"%@\"", [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [[NSException exceptionWithName:@"MethodShouldNotHaveBeenCalledException"
                             reason:@"application:didReceiveRemoteNotification: was called instead of application:didReceiveRemoteNotification:fetchCompletionHandler:"
                           userInfo:nil] raise];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    
    NSLog(@"Remote notification = %@", userInfo);
    
    if (application.applicationState == UIApplicationStateActive)
    {
        
        if (application.applicationState == UIApplicationStateActive)
        {
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"Remote notification received"
                                                message:[NSString stringWithFormat:@"application:didReceiveRemoteNotification:fetchCompletionHandler:\n%@", [userInfo description]]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"принято!"
                                                                           style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:okAction];
            
            [self.window.rootViewController presentViewController:alertController
                                                         animated:YES
                                                       completion:nil];
        }
        
    } else {
        // app is background, do background stuff
        NSLog(@"Remote notification received while in background");
    }
    
    handler(UIBackgroundFetchResultNoData);
}

#pragma mark - CoreData

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iPOI" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iPOI.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - DataBase func

- (void)deleteExpiredData
{
    NSDate *expireDate = [[NSDate date] dateByAddingTimeInterval: -60*60*24*30];    // 30 days

    NSDictionary *subs = @{@"DATE" : expireDate};
    NSFetchRequest *request = [self.managedObjectModel fetchRequestFromTemplateWithName:kImageAllExpired substitutionVariables:subs];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request
                                                                error:&error];
    if(error == nil)
    {
        for (NSManagedObject *object in results)
        {
            [self.managedObjectContext deleteObject:object];
        }
        
        [self saveContext];
    }
    else
    {
        NSLog(@"Error fetch request: %@", [error localizedDescription]);
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
