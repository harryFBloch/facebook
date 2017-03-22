//
//  ViewController.m
//  simpleFaceBook
//
//  Created by harry bloch on 3/31/16.
//  Copyright © 2016 harry bloch. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = CGPointMake(self.view.center.x, (self.view.bounds.size.height * .8));
    
    
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    [self.view addSubview:loginButton];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:) name:FBSDKProfileDidChangeNotification object:nil];
   FBSDKProfile *currentProfile = [FBSDKProfile currentProfile];
    if (currentProfile.userID) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email" forKey:@"fields"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user %@ and email: %@",result,result[@"email"]);
                 self.nameLabel.text = result[@"name"];
                 NSString *tempEmail = result[@"email"];
                 self.emailLabel.text = tempEmail;
                 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",result[@"id"]]];
                 NSData  *data = [NSData dataWithContentsOfURL:url];
                 self.profilePic.image = [UIImage imageWithData:data];
             }
         }];
    }
}

-(void)receiveNotification:(NSNotification *) notification{
    NSLog(@"%@",[FBSDKProfile currentProfile]);
   
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
  [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
   startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
       if (!error) {
           NSLog(@"fetched user %@ and email: %@",result,result[@"email"]);
           self.nameLabel.text = result[@"name"];
           self.emailLabel.text = result[@"email"];
           NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",result[@"id"]]];
           NSData  *data = [NSData dataWithContentsOfURL:url];
           self.profilePic.image = [UIImage imageWithData:data];
       }
   }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)photoUpload:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.profilePic.image = image;
    
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    photo.caption = @"add caption";
    
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    shareButton.center = self.view.center;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view addSubview:shareButton];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end









































