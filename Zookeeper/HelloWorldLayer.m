//
//  HelloWorldLayer.m
//  Zookeeper
//
//  Created by takuya.watabe on 12/11/01.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
@property (retain, nonatomic) NSMutableArray* figures;
@property (retain, nonatomic) CCSprite* selSprite;
@property (assign, nonatomic) CGPoint startPoint;

-(void) selectSpriteForTouch:(CGPoint)touchLoation;
@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        self.figures = [[[NSMutableArray alloc] init] autorelease];
        
        int width = 4;
        int height = 4;
        for (int i = 0; i < width * height; i++) {
            int spriteHeght = (i + height) / (height);
            int spriteWidth = i % width + 1;
            
            CCSprite *sprite = [CCSprite spriteWithFile:@"btn.png"];
            CGPoint originalPoint = CGPointMake(size.width/width + spriteWidth, size.height/height / spriteHeght);
            sprite.position = originalPoint;
            [self addChild:sprite];
            [self.figures addObject:sprite];
        }
        /*
        CCSprite *sprite = [CCSprite spriteWithFile:@"btn.png"];
        CGPoint originalPoint = CGPointMake(size.width/2, size.height/2);
        self.startPoint = originalPoint;
        sprite.position = originalPoint;
        [self addChild:sprite];
        [self.figures addObject:sprite];
         */
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchPoint];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    if (self.selSprite) {
        CGPoint newPos = ccpAdd(self.selSprite.position, translation);
        self.selSprite.position = newPos;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selSprite.position = self.startPoint;
    self.selSprite = nil;
}

-(void) selectSpriteForTouch:(CGPoint)touchLoation
{
    CCSprite* newSprite = nil;
    for (CCSprite* sprite in self.figures) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLoation)) {
            newSprite = sprite;
        }
    }
    
    if (newSprite != self.selSprite) {
        [self.selSprite stopAllActions];
        /*
        [self.selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
         */
        self.selSprite = newSprite;
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate
@end
