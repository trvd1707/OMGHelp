//
//  CrownViewController.h
//  iDialJesus
//
//  Created by Teresa Rios-Van Dusen on 4/23/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface CrownViewController : UIViewController <AVAudioPlayerDelegate, 
                                                   UIActionSheetDelegate>
{

	AVAudioPlayer *player;
    BOOL  muted;
    NSArray *jewelsArray;
    NSArray *songsArray;
    NSArray *jewelDictArray;
    UIButton *ruby;
    UIButton *topaz;
    UIButton *emerald;
    UIButton *turquoise;
    UIButton *sapphire;
    UIButton *amber;
    UIButton *agate;
    UIButton *amethyst;
    UIButton *beryl;
    UIButton *onyx;
    UIButton *jasper;
    UIButton *chalcedony;
    UIButton *sardonyx;
    UIButton *chrysoprase;
    UIButton *aquamarine;
    UIButton *garnet;
    UIButton *peridot;
    UIButton *opal;
    UIButton *yellowsapphire;
    UIButton *pearl;
    UIButton *whitesapphire;
    UIButton *redcoral;
    UIButton *diamond;  
    UIImageView  *crownImage;
    UIImageView  *colorCrownImage;
    UIToolbar *_playBar;
    //from avTouch
    UIImage *_playBtnBG;
    UIImage	*_pauseBtnBG;
    UIImage *crownShot;
    NSTimer	*_rewTimer;
	NSTimer *_ffwTimer;
    IBOutlet UIBarButtonItem *_playButton;
	IBOutlet UIBarButtonItem *_ffwButton;
	IBOutlet UIBarButtonItem *_rewButton;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, readwrite) BOOL muted;
@property (nonatomic, retain) NSArray *jewelsArray;
@property (nonatomic, retain) NSArray *songsArray;
@property (nonatomic, retain) NSArray *jewelDictArray;
@property (nonatomic, retain) IBOutlet UIButton *ruby;
@property (nonatomic, retain) IBOutlet UIButton *topaz;
@property (nonatomic, retain) IBOutlet UIButton *emerald;
@property (nonatomic, retain) IBOutlet UIButton *turquoise;
@property (nonatomic, retain) IBOutlet UIButton *sapphire;
@property (nonatomic, retain) IBOutlet UIButton *amber;
@property (nonatomic, retain) IBOutlet UIButton *agate;
@property (nonatomic, retain) IBOutlet UIButton *amethyst;
@property (nonatomic, retain) IBOutlet UIButton *beryl;
@property (nonatomic, retain) IBOutlet UIButton *onyx;
@property (nonatomic, retain) IBOutlet UIButton *jasper;
@property (nonatomic, retain) IBOutlet UIButton *chalcedony;
@property (nonatomic, retain) IBOutlet UIButton *sardonyx;
@property (nonatomic, retain) IBOutlet UIButton *chrysoprase;
@property (nonatomic, retain) IBOutlet UIButton *aquamarine;
@property (nonatomic, retain) IBOutlet UIButton *garnet;
@property (nonatomic, retain) IBOutlet UIButton *peridot;
@property (nonatomic, retain) IBOutlet UIButton *opal;
@property (nonatomic, retain) IBOutlet UIButton *yellowsapphire;
@property (nonatomic, retain) IBOutlet UIButton *pearl;
@property (nonatomic, retain) IBOutlet UIButton *whitesapphire;
@property (nonatomic, retain) IBOutlet UIButton *redcoral;
@property (nonatomic, retain) IBOutlet UIButton *diamond;    
@property (nonatomic, retain) IBOutlet UIImageView  *crownImage;
@property (nonatomic, retain) IBOutlet UIImageView  *colorCrownImage;
@property (nonatomic, retain) IBOutlet UIToolbar *_playBar;
@property (nonatomic, retain) UIImage  *_playBtnBG;
@property (nonatomic, retain) UIImage  *_pauseBtnBG;
@property (nonatomic, retain) UIImage  *crownShot;
//from avTouch
@property (nonatomic, retain) UIBarButtonItem  *_playButton;
@property (nonatomic, retain) UIBarButtonItem  *_ffwButton;
@property (nonatomic, retain) UIBarButtonItem  *_rewButton;

- (IBAction)left:(id)sender;
- (IBAction)info:(id)sender;

//from avTouch
- (IBAction)actionButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)playButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)rewButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)ffwButtonPressed:(UIBarButtonItem *)sender;

- (void)enableJewels: (NSArray *) jewelery count: (NSInteger) count;
- (void)singleTap;
- (void)doubleTap;
- (void)tripleTap;
- (void)quapleTap;

//from avTouch
- (void)updateViewForPlayerState;
- (void)pausePlayback;
- (void)startPlayback;
- (void)ffwd;
- (void)rewind;

@end
