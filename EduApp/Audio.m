//
//  Audio.m
//  fxprocessor
//
//  Created by Mikkel Gravgaard on 01/02/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import "Audio.h"

#include <AudioToolbox/AudioToolbox.h>

#define SPEED_STEP 0.05

typedef struct MyAUGraphPlayer
{
	AudioStreamBasicDescription inputFormat; // input file's data stream description
	AudioFileID					inputFile; // reference to your input file
	
	AUGraph graph;
	AudioUnit fileAU;
    AudioUnit effectAU;
	AudioUnit speedAU;
    
} MyAUGraphPlayer;


@implementation Audio {
    MyAUGraphPlayer *_player;
    NSString *_songUrl;
    float _speed;
}

void CreateMyAUGraph(MyAUGraphPlayer *player);
double PrepareFileAU(MyAUGraphPlayer *player);

#pragma mark - utility functions -

// generic error handler - if err is nonzero, prints error message and exits program.
static void CheckError(OSStatus error, const char *operation)
{
	if (error == noErr) return;
	
	char str[20];
	// see if it appears to be a 4-char-code
	*(UInt32 *)(str + 1) = CFSwapInt32HostToBig(error);
	if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
		str[0] = str[5] = '\'';
		str[6] = '\0';
	} else
		// no, format it as an integer
		sprintf(str, "%d", (int)error);
	
	fprintf(stderr, "Error: %s (%s)\n", operation, str);
	
    //    [NSException raise:@"Error" format:@"See above"];
	exit(1);
}


#pragma mark - audio converter -

void CreateMyAUGraph(MyAUGraphPlayer *player)
{
	// create a new AUGraph
	CheckError(NewAUGraph(&player->graph),
			   "NewAUGraph failed");
	
	// generate description that will match out output device (speakers)
	AudioComponentDescription outputcd = {0};
	outputcd.componentType = kAudioUnitType_Output;
	outputcd.componentSubType = kAudioUnitSubType_RemoteIO;
	outputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
	
	// adds a node with above description to the graph
	AUNode outputNode;
	CheckError(AUGraphAddNode(player->graph, &outputcd, &outputNode),
			   "AUGraphAddNode[kAudioUnitSubType_DefaultOutput] failed");
	
    // generate fx description
    AudioComponentDescription effectcd = {0};
    effectcd.componentType = kAudioUnitType_Effect;
    effectcd.componentSubType = kAudioUnitSubType_Distortion;
    effectcd.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    // adds node with above desc to graph
    AUNode effectNode;
    CheckError(AUGraphAddNode(player->graph, &effectcd, &effectNode),
               "AUGraphAddNode[kAudioUnitSubType_Distortion] failed");

    // varispeed
    AudioComponentDescription speedcd = {0};
    speedcd.componentType = kAudioUnitType_FormatConverter;
    speedcd.componentSubType = kAudioUnitSubType_Varispeed;
    speedcd.componentManufacturer = kAudioUnitManufacturer_Apple;

    // add node with above desc
    AUNode speedNode;
    CheckError(AUGraphAddNode(player->graph, &speedcd, &speedNode), 
               "AUGraphAddNode[varispeed] failed");

	// generate description that will match a generator AU of type: audio file player
	AudioComponentDescription fileplayercd = {0};
	fileplayercd.componentType = kAudioUnitType_Generator;
	fileplayercd.componentSubType = kAudioUnitSubType_AudioFilePlayer;
	fileplayercd.componentManufacturer = kAudioUnitManufacturer_Apple;
	
	// adds a node with above description to the graph
	AUNode fileNode;
	CheckError(AUGraphAddNode(player->graph, &fileplayercd, &fileNode),
			   "AUGraphAddNode[kAudioUnitSubType_AudioFilePlayer] failed");
	
    
	// opening the graph opens all contained audio units but does not allocate any resources yet
	CheckError(AUGraphOpen(player->graph),
			   "AUGraphOpen failed");
	
	// get the reference to the AudioUnit object for the file player graph node
	CheckError(AUGraphNodeInfo(player->graph, fileNode, NULL, &player->fileAU),
			   "AUGraphNodeInfo failed");
	
	// connect the output source of the file player AU to the input source of the fx node
	CheckError(AUGraphConnectNodeInput(player->graph, fileNode, 0, speedNode, 0),
			   "AUGraphConnectNodeInput");

//    CheckError(AUGraphConnectNodeInput(player->graph, effectNode, 0, outputNode, 0), "AIGraphConnectNodeInput");
	
	CheckError(AUGraphConnectNodeInput(player->graph, speedNode, 0, outputNode, 0),
			   "AUGraphConnectNodeInput");

    CheckError(AUGraphNodeInfo(player->graph, speedNode, NULL, &(player->speedAU)), 
               "AUGraphNodeInfo failed");
    
    AudioUnit outputUnit;
    CheckError(AUGraphNodeInfo(player->graph, outputNode, NULL, &outputUnit), 
               "AUGraphNodeInfo failed");
    
    AudioUnit fileUnit;
    CheckError(AUGraphNodeInfo(player->graph, fileNode, NULL, &fileUnit), 
               "AUGraphNodeInfo failed");
    
    // Set the _output_ format of the VariSpeed to match the output format of the File Player
    UInt32 propSize = sizeof(AudioStreamBasicDescription);
    AudioStreamBasicDescription format = {0};
    
    AudioUnitGetProperty(fileUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &format, &propSize);    
    
    AudioUnitSetProperty(player->speedAU, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &format, propSize);
    
	// now initialize the graph (causes resources to be allocated)
	CheckError(AUGraphInitialize(player->graph),
			   "AUGraphInitialize failed");
    
    // configure effect
    CheckError(AUGraphNodeInfo(player->graph, effectNode, NULL, &(player->effectAU)), 
               "AUGraphNodeInfo failed");
    
    AudioUnitSetParameter(player->effectAU, kDistortionParam_FinalMix, kAudioUnitScope_Global, 
                          0, 0.0f, 0);
    
    
}

double PrepareFileAU(MyAUGraphPlayer *player)
{
	
	// tell the file player unit to load the file we want to play
	CheckError(AudioUnitSetProperty(player->fileAU, kAudioUnitProperty_ScheduledFileIDs, 
									kAudioUnitScope_Global, 0, &player->inputFile, sizeof(player->inputFile)),
			   "AudioUnitSetProperty[kAudioUnitProperty_ScheduledFileIDs] failed");
	
	UInt64 nPackets;
	UInt32 propsize = sizeof(nPackets);
	CheckError(AudioFileGetProperty(player->inputFile, kAudioFilePropertyAudioDataPacketCount,
									&propsize, &nPackets),
			   "AudioFileGetProperty[kAudioFilePropertyAudioDataPacketCount] failed");
	
	// tell the file player AU to play the entire file
	ScheduledAudioFileRegion rgn;
	memset (&rgn.mTimeStamp, 0, sizeof(rgn.mTimeStamp));
	rgn.mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
	rgn.mTimeStamp.mSampleTime = 0;
	rgn.mCompletionProc = NULL;
	rgn.mCompletionProcUserData = NULL;
	rgn.mAudioFile = player->inputFile;
	rgn.mLoopCount = 1000;
	rgn.mStartFrame = 0;
	rgn.mFramesToPlay = nPackets * player->inputFormat.mFramesPerPacket;
	
	CheckError(AudioUnitSetProperty(player->fileAU, kAudioUnitProperty_ScheduledFileRegion, 
									kAudioUnitScope_Global, 0,&rgn, sizeof(rgn)),
			   "AudioUnitSetProperty[kAudioUnitProperty_ScheduledFileRegion] failed");
	
	// prime the file player AU with default values
	UInt32 defaultVal = 0;
	CheckError(AudioUnitSetProperty(player->fileAU, kAudioUnitProperty_ScheduledFilePrime, 
									kAudioUnitScope_Global, 0, &defaultVal, sizeof(defaultVal)),
			   "AudioUnitSetProperty[kAudioUnitProperty_ScheduledFilePrime] failed");
	
	// tell the file player AU when to start playing (-1 sample time means next render cycle)
	AudioTimeStamp startTime;
	memset (&startTime, 0, sizeof(startTime));
	startTime.mFlags = kAudioTimeStampSampleTimeValid;
	startTime.mSampleTime = -1;
	CheckError(AudioUnitSetProperty(player->fileAU, kAudioUnitProperty_ScheduleStartTimeStamp, 
									kAudioUnitScope_Global, 0, &startTime, sizeof(startTime)),
			   "AudioUnitSetProperty[kAudioUnitProperty_ScheduleStartTimeStamp]");
	
	// file duration
	return (nPackets * player->inputFormat.mFramesPerPacket) / player->inputFormat.mSampleRate;
}

#pragma mark - main - 
static void startSound(void *userData)
{
//    MyAUGraphPlayer p = {0};
    Audio *audio = (__bridge Audio *)userData;
    MyAUGraphPlayer *player = audio->_player;
    NSString *songUrl = audio->_songUrl;
#if TARGET_IPHONE_SIMULATOR
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:songUrl];
#else
    NSURL *fileURL = [[NSURL alloc] initWithString:songUrl];
#endif
    NSLog(@"%@",[fileURL absoluteString]);
    
	// open the input audio file
	CheckError(AudioFileOpenURL((__bridge CFURLRef)fileURL, kAudioFileReadPermission, 0, &(player->inputFile)),
			   "AudioFileOpenURL failed");
	
	// get the audio data format from the file
	UInt32 propSize = sizeof(player->inputFormat);
	CheckError(AudioFileGetProperty(player->inputFile, kAudioFilePropertyDataFormat,
									&propSize, &(player->inputFormat)),
			   "couldn't get file's data format");
	
	// build a basic fileplayer->speakers graph
	CreateMyAUGraph(player);
	
	// configure the file player
	Float64 fileDuration = PrepareFileAU(player);
	NSLog(@"Duration: %f",fileDuration);
    
	// start playing
	CheckError(AUGraphStart(player->graph),
			   "AUGraphStart failed");
	
	// sleep until the file is finished
//	usleep ((int)(fileDuration * 1000.0 * 1000.0));
	
//cleanup:
//	AUGraphStop (player.graph);
//	AUGraphUninitialize (player.graph);
//	AUGraphClose(player.graph);
//	AudioFileClose(player.inputFile);
	
}

- (void) start:(NSString *)url
{
    _player = malloc(sizeof(MyAUGraphPlayer));
    _songUrl = url;
    bzero(_player, sizeof(MyAUGraphPlayer));
    startSound((__bridge void *)self);
}

- (void) stop
{
	AUGraphStop (_player->graph);
	AUGraphUninitialize (_player->graph);
	AUGraphClose(_player->graph);
	AudioFileClose(_player->inputFile);

}

- (void)effectLevel:(float) value
{
    AudioUnitSetParameter(_player->effectAU, kDistortionParam_FinalMix, kAudioUnitScope_Global, 
                          0, value, 0);
}

- (void)speedRamp
{
    float current;
    AudioUnitGetParameter(_player->speedAU, kVarispeedParam_PlaybackRate, kAudioUnitScope_Global, 0, &current);
    if(current>_speed){
        current-=SPEED_STEP;
    } else if(current<_speed){
        current+=SPEED_STEP;
    }
    if(fabs(_speed-current)<SPEED_STEP){
        current=_speed;
    }
//    NSLog(@"we want %f, we got %f, we set to %f",_speed,current,value);
    AudioUnitSetParameter(_player->speedAU,
                          kVarispeedParam_PlaybackRate, kAudioUnitScope_Global, 0, current, 0);
    if(current!=_speed){
        [self performSelector:@selector(speedRamp) withObject:nil afterDelay:0.1];
    }
}

- (void)speed:(float)value
{
//    NSLog(@"%f",value);
    _speed=value;
    [self performSelector:@selector(speedRamp) withObject:nil afterDelay:0.1];
}

@end
