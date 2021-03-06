//
//  AnswerTableViewController.m
//  iDialJesus
//
//  Created by Teresa Rios-Van Dusen on 4/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AnswerViewController.h"
#import "CrownViewController.h"

@implementation AnswerViewController
//@synthesize index, player;
//@synthesize scrollTextView, webView;
//@synthesize answer, topic;
//@synthesize muted;
//@synthesize circularCounter;
//@synthesize waitAwhile;


#pragma mark -
#pragma mark View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:@"AnswerViewController" bundle:nibBundleOrNil]) {
       // NsLog(@"Init  answer view from nib"); 
    }
    return self;
}


- (void)viewDidLoad {
    // NsLog(@"Load  answer view");
    [super viewDidLoad];
    if (isIPAD) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"JesusRevBW.png"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
	
	// initial values for global variables
	self.circularCounter = 0;
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Custom initialization
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController setToolbarHidden:NO animated:YES];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.navigationItem.prompt = [self.answer objectForKey:@"question"];//The controller loads its own title.
	self.muted = [defaults boolForKey:@"muted"];
    [self configureToolbarItems];
    
	/**/ 
	NSMutableString *noBlanksTopic = [[NSMutableString alloc] initWithCapacity:[self.topic length]];
	for (int i = 0; i < [self.topic length]; i++) {
		//NSLog(@"character from topic: %C", [self.topic characterAtIndex:i]);
		if ([ [NSCharacterSet letterCharacterSet] characterIsMember:[self.topic characterAtIndex:i] ])
		{
			[noBlanksTopic appendFormat:@"%C", [self.topic characterAtIndex:i] ];
		}//if character is a letter
	}//for all characters in topic
    
    self.scrollTextView.font = [UIFont fontWithName:@"STHeitiK-Medium" size:16];
	//webView.backgroundColor = [UIColor clearColor];
    //scrollTextView.backgroundColor = [UIColor whiteColor];
}//- (void)viewDidLoad

- (void)configureToolbarItems
{
	//It may be called a button, but it is really the space between buttons.
	UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] 
												initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
												target:nil action:nil];
	
	UIBarButtonItem *actionButtonBar = [[UIBarButtonItem alloc]	
										initWithBarButtonSystemItem:UIBarButtonSystemItemAction
										target:self action:@selector(styleAction:)];
    
    UIImage *img = [UIImage imageNamed:@"left_arrow-32.png"];
	
	UIBarButtonItem *backButtonBar = [[UIBarButtonItem alloc]
                                      initWithImage:img 
                                      style:UIBarButtonItemStylePlain 
                                      target:self 
                                      action:@selector(previousPage:)];
	
    img = [UIImage imageNamed:@"right_arrow-32.png"];
	
	UIBarButtonItem *nextButtonBar = [[UIBarButtonItem alloc]
                                      initWithImage:img 
                                      style:UIBarButtonItemStylePlain 
                                      target:self
                                      action:@selector(nextPage:)];
	
    img = _muted?[UIImage imageNamed:@"Mute-32.png"]:[UIImage imageNamed:@"Sound-32.png"];
    
	UIBarButtonItem *muteButtonBar = [[UIBarButtonItem alloc]
									  initWithImage:img
                                      style:UIBarButtonItemStylePlain
									  target:self action: @selector(toggleSound:)];
	
  	// Set our toolbar items
	backButtonBar.tag = 0;
	flexibleSpaceButtonItem.tag = 1;
	actionButtonBar.tag = 2;
	//flexibleSpaceButtonItem,
	muteButtonBar.tag = 3;
	flexibleSpaceButtonItem.tag = 4;
	nextButtonBar.tag = 5;
	//fbButton.tag = 6;
	
	[self setToolbarItems:[NSArray arrayWithObjects:
						   backButtonBar,
						   flexibleSpaceButtonItem,
						   actionButtonBar,	
                           flexibleSpaceButtonItem,
						   muteButtonBar,
						   flexibleSpaceButtonItem,
						   nextButtonBar,
						   nil] animated: YES];	
    [self showQuote];
	//as in case 0 of showCurrentPage, back button is disabled
	UIBarButtonItem *back = [self.toolbarItems objectAtIndex:0];
	back.enabled = NO;
}//- (void)configureToolbarItems

-(IBAction)nextPage:(id)sender
{
	self.circularCounter += 1;
	if (self.circularCounter > 3)
	{
		self.circularCounter = 3;
	}
	[self showCurrentPage];
}

-(IBAction)previousPage:(id)sender
{
	self.circularCounter -=1;
	if(self.circularCounter < 0)
	{
	    self.circularCounter = 0;
	}
	[self showCurrentPage];
}	


- (IBAction)showCurrentPage {
    NSInteger lastIndex = [self.toolbarItems count] -1;
	UIBarButtonItem *back = [self.toolbarItems objectAtIndex:0];
	UIBarButtonItem *next = [self.toolbarItems objectAtIndex:lastIndex];
    // NsLog(@"Current page: %d", self.circularCounter);
    switch (_circularCounter) {
        case 0:
            [self showQuote];
			//first case: back disdabled, next enabled
			back.enabled = NO;
			//next.enabled = YES;
            break;
        case 1:
            [self showExplanation];
			//middle case: back endabled, next enabled
			back.enabled = YES;
			//next.enabled = YES;
            break;
        case 2:
            [self showGetReal];
			//last case: back endabled, next disabled
			//back.enabled = YES;
			next.enabled = YES;
            break;			
        case 3:
            [self showLinks];
			//middle case: back endabled, next enabled
			//back.enabled = YES;
			next.enabled = NO;
            break;
        default:
			// NsLog(@"Current page: %d, circular counter must be wrong", self.circularCounter);
            break;
    }//switch (circularCounter)
}//- (IBAction)showCurrentPage

//the following 4 methods are called by - (IBAction)showCurrentPage; as needed
- (void) showQuote
{
	self.navigationItem.title = @"Bible Quote";
    _scrollTextView.text = [_answer objectForKey:@"bible quote"];
	_webView.hidden = YES;
	_scrollTextView.hidden = NO;
	NSMutableString *noBlanksTopic = [[NSMutableString alloc] initWithCapacity:[self.topic length]];
	for (int i = 0; i < [self.topic length]; i++) {
		//NSLog(@"character from topic: %C", [self.topic characterAtIndex:i]);
		if ([ [NSCharacterSet letterCharacterSet] characterIsMember:[self.topic characterAtIndex:i] ])
		{
			[noBlanksTopic appendFormat:@"%C", [self.topic characterAtIndex:i] ];
		}//if character is a letter
	}//for all characters in topic
	/**/
	NSString *filename = [[NSString alloc] initWithFormat:@"%@%ld", (NSString *)noBlanksTopic , (long)self.index];
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: filename ofType: @"mp3"];
    //[noBlanksTopic release];
	if (soundFilePath != nil) {
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
		if (self.player == nil) {
			//NSLog(@"Creating new player");
			AVAudioPlayer *newPlayer = [AVAudioPlayer alloc];
			self.player = newPlayer;
		} else {
			//NSLog(@"Reusing player");
			[self.player stop];
		}//else (player not nil)
        [self.player initWithContentsOfURL:fileURL error:nil];
	}//if (soundFilePath not nil)
	
    if (self.player != nil) {
        [self.player stop];
        [self.player prepareToPlay];
        [self.player setVolume: 1.0];
        
        if (_muted) {
            [self.player pause];
        } else {
            [self.player play];
        }//if muted or else
    }//if player exists
}//showQuote

- (void) showExplanation
{   
	self.navigationItem.title = @"Explanation";
	_scrollTextView.text = [_answer objectForKey:@"explanation"];
	_webView.hidden = YES;
	_scrollTextView.hidden = NO;
	[self.player pause];
}

- (void) showGetReal
{
	//UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"prize" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    //[self.navigationItem setRightBarButtonItem:done];
	//[done release];
	self.navigationItem.title = @"Keep it Real";
	_scrollTextView.text = [_answer objectForKey:@"examples"];
	_webView.hidden = YES;
	_scrollTextView.hidden = NO;
	[self.player pause];
	
	// only create timer to wait for reading on the first time this page is visited
	if (self.waitAwhile == nil) {
		self.waitAwhile = [NSTimer scheduledTimerWithTimeInterval:8 target:self 
														 selector:@selector(jewelFireMethod:)
														 userInfo:nil repeats:YES];		
	}
}

- (void) showLinks
{
	self.navigationItem.title = @"Links";
	//scrollTextView.text = [[answer objectForKey:@"links"] description];
	_webView.hidden = NO;
	_scrollTextView.hidden = YES;
	_webView.backgroundColor = [UIColor clearColor];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"LINKS" ofType:@"html"];
	NSString *resourcePath = [[NSBundle mainBundle] bundlePath];
	NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	NSString *htmlString = [[NSString alloc] initWithData: 
							[readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
	
	// to make html content transparent to its parent view -
	// 1) set the webview's backgroundColor property to [UIColor clearColor]
	// 2) use the content in the html: <body style="background-color: transparent">
	// 3) opaque property set to NO
	//
	//aboutPage.opaque = NO;
	//webView.backgroundColor = [UIColor clearColor];
	//scrollTextView.backgroundColor = [UIColor clearColor];
	[self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:resourcePath]];
	[self.view sendSubviewToBack:_scrollTextView];
	[self.player pause];
}
//the previous 4 methods are called by - (IBAction)showCurrentPage; as needed

- (IBAction)done:(id)sender {
	
	// Navigation logic may go here. Create and push another view controller.
    self.hidesBottomBarWhenPushed = YES;
	[self.navigationController setToolbarHidden:YES animated:YES];
	CrownViewController *crownViewController = [[CrownViewController alloc] initWithNibName:@"CrownViewController" bundle:nil];
	// Pass the selected object to the answerViewController.
	UIBarButtonItem *customBack = [[UIBarButtonItem alloc] initWithTitle:@"iDialJesus" 
																   style:UIBarButtonItemStyleDone 
																  target:nil action:NULL ];
	self.navigationController.navigationItem.backBarButtonItem = customBack;
	
    [self.navigationController pushViewController:crownViewController animated:YES];
}


- (void)jewelFireMethod:(NSTimer*)theTimer
{    
	//timer no longer needed
    //NSLog(@"Killing timer");
	[theTimer invalidate];
	theTimer = nil;
	//show done button
//	UIBarButtonItem *doneButtonBar = [[UIBarButtonItem alloc]
//									  initWithTitle:@"Prize"
//									  style:UIBarButtonItemStyleDone
//									  target:self
//									  action:@selector(done:)];
//
    UIImage *prizeImage = [UIImage imageNamed:@"crwon31.png"];
    UIBarButtonItem *doneButtonBar = [[UIBarButtonItem alloc]
                                      initWithImage:prizeImage
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(done:)];
    
	self.navigationItem.rightBarButtonItem = doneButtonBar;
    //play magic wand sound
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"Magic Wand Noise" ofType: @"mp3"];
	if (soundFilePath != nil) {
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
		AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
																		  error: nil];
		//self.player = newPlayer;
        newPlayer.numberOfLoops = 0;
		newPlayer.delegate = self;
		//[newPlayer prepareToPlay];
		[newPlayer setVolume: 0.4];
		if(!_muted){
            [newPlayer play];
        }//if we are not muted 
         //[newPlayer release];
    }//if sound file was found
	//[theTimer invalidate];
}//jewel fire method

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[self.player stop];
}
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -
#pragma mark UIResponder

//Override this method in the controller class.
// Hide cut/copy/paste menu

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
	
	if ( [UIMenuController sharedMenuController] )
	{
		[UIMenuController sharedMenuController].menuVisible = NO;
	}
	return NO;
	
}

- (IBAction)toggleSound:(id)sender
{
   	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	_muted = !_muted;
	[defaults setBool:_muted forKey:@"muted"];
	
	if(!_muted) {
		[self.player play];
	}
	else       {
		[self.player stop];
	}
	
	[self configureToolbarItems];
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Change the navigation bar style, also make the status bar match with it
	switch (buttonIndex)
	{
		case 0:
		{
            [self actionMail];
			break;
		}
		case 1:
		{
            [self actionMusic];
			break;
		}
		case 2:
		{
            [self actionFaceBook];
			break;
		}
    /*
		case 3:
		{
            [self actionTwitter];
			break;
		}
    */
	}//Action button seletion
}//clickedButtonAtIndex

//the following 4 methods are called by (void)clickedButtonAtIndex; as needed
- (void) actionMail
{
    // send this answer as an email
    //NSLog(@"Send email");
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

- (void) actionFaceBook
{
    // post this answer on Facebook
    //NSLog(@"post on FB");
//    __session = [FBSession sessionForApplication:@"99d9523b9c944dc7fc25c979a461dd28" secret:@"bad4f5bcd1db752bb9955a267ecd9913" delegate:self];
}

- (void) actionTwitter
{
    // bookmark this answer
    //NSLog(@"Twitter");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *twitterId = [defaults valueForKey:@"twitterID"];
    NSString *twitterPwd = [defaults valueForKey:@"twitterPwd"];
    
    if ((twitterId == nil) || (twitterPwd == nil)) {
        [self loginTwitterId:twitterId withPwd:twitterPwd];
    }
}

- (void) actionMusic
{
    // show music page
    //NSLog(@"Show Music page and play song");
    self.navigationItem.title = @"Music";
    NSString *htmlString = @"<html><bodystyle=\"background-color: transparent\">Go To www.cdbaby.com/cd/shafer to download the featured song, Renewal, on this app from artist Drew Shafer's CD entitled Sincerely Jesus.</body></html>";
    _webView.hidden = NO;
    _scrollTextView.hidden = YES;
    _webView.backgroundColor = [UIColor clearColor];
    
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    [self.view sendSubviewToBack:_scrollTextView];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"Renewal" ofType: @"mp3"];
    if (soundFilePath != nil) {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        if (self.player != nil) {
            [self.player stop];	
            [self.player initWithContentsOfURL: fileURL error: nil];
            self.player.numberOfLoops = 0;
            [self.player prepareToPlay];
            [self.player setVolume: 0.8];
            if(!_muted){
                [self.player play];
            }//if we are not muted 
        }//if player has been initialised
    }//if sound file was found
}
//The previous 4 methods are called by (void)clickedButtonAtIndex; as needed

-(void) loginTwitterId: (NSString *)twitterId withPwd: (NSString *)twitterPwd
{
    // show Twitter login screen.
//    TwitterLoginViewController *tweet = [[TwitterLoginViewController alloc] initWithNibName:@"TwitterLoginViewController" bundle:nil];
//    [self.navigationController presentViewController:tweet animated:YES completion:nil];
}


#pragma mark -
#pragma mark API

- (IBAction)styleAction:(id)sender
{
	UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:@"Share this answer with others:"
															delegate:self cancelButtonTitle:@"Cancel"
											  destructiveButtonTitle:nil
												   otherButtonTitles:	@"email",
								 @"music",
								 @"Facebook",
								 //@"Twitter",
								 nil];
	
	// use the same style as the nav bar
    styleAlert.actionSheetStyle = UIActionSheetStyleAutomatic;
	[styleAlert showInView:self.view.window];
}

#pragma mark -
#pragma mark AVAudioPlayer delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)mPlayer successfully:(BOOL)flag{
    //NSLog(@"Player stopped");
}

#pragma mark -
#pragma mark FB

- (void)sessionDidLogout:(FBSession*)session {
    // _label.text = @"";
    //_permissionButton.hidden = YES;
    //_feedButton.hidden = YES;
    NSLog(@"FBSession Logged out");
}

///////////////////////////////////////////////////////////////////////////////////////////////////



#pragma mark -
#pragma mark MFMailComposeViewController
// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    NSString *question = [_answer objectForKey:@"question"];
	[picker setSubject:question];
	
    
	// Set up recipients
	NSArray *toRecipients = nil; 
	
	[picker setToRecipients:toRecipients];
	
	// Attach an image to the email
	NSString *path = [[NSBundle mainBundle] pathForResource:@"JesusRevIcon" ofType:@"png"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = [_answer objectForKey:@"bible quote"];
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker animated:YES completion:nil];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	//message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			//message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			//message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			//message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			//message.text = @"Result: failed";
			break;
		default:
			//message.text = @"Result: not sent";
			break;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:%20&subject=Hello from California!";
	NSString *body = [_answer objectForKey:@"bible quote"];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    //NSLog(@"Received Memory Warning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[self.player stop];
}

#pragma mark UISplitViewController delegate methods
- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
	{
        barButtonItem.title = NSLocalizedString(@"iDialJesus", @"iDialJesus");
        self.navigationItem.prompt = [self.answer objectForKey:@"question"];
          [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
 
    }

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    self.navigationItem.prompt = nil;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[AnswerViewController class]] && ([(AnswerViewController *)[(UINavigationController *)secondaryViewController topViewController] answer] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark QuestionDelegate

-(void) didSelectQuestion:(NSDictionary *) answerDict {
    // NsLog(@"Calling Question Delegate");
    self.answer = answerDict;
    [self viewDidLoad];
}

@end

