# NSDeckLink

A pure Objective-C (No Objective-C++) wrapper for Blackmagic's DeckLinkAPI

## Example 

    #import <NSDeckLink/NSDeckLink.h>

    int main(int argc, char *const *  argv)
    {

        NSIDeckLinkIterator* dlit = [NSIDeckLinkIterator iterator];
        NSArray<NSIDeckLink*>* allDecklinks = [dlit allObjects];
        if ([allDecklinks count] == 0)
        {
            NSLog(@"No Decklinks found");
            return 1;
        }

        NSIDeckLink* decklink = [allDecklinks firstObject];
        NSIDeckLinkProfileAttributes* attr = [decklink profileAttributes];

        NSLog(@"Decklink Name: \"%@\"",[attr stringForAttributeID:BMDDeckLinkDisplayName]);

        NSLog(@"BMDDeckLinkVideoInputConnections: %@",[attr intForAttributeID:BMDDeckLinkVideoInputConnections]);
        NSLog(@"BMDDeckLinkAudioInputConnections: %@",[attr intForAttributeID:BMDDeckLinkAudioInputConnections]);

        NSLog(@"BMDDeckLinkMaximumAnalogAudioInputChannels: %@",[attr intForAttributeID:BMDDeckLinkMaximumAnalogAudioInputChannels]);
    
        return 0;
    }	
