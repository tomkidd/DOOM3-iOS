/*
===========================================================================

Doom 3 GPL Source Code
Copyright (C) 1999-2011 id Software LLC, a ZeniMax Media company.

This file is part of the Doom 3 GPL Source Code ("Doom 3 Source Code").

Doom 3 Source Code is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Doom 3 Source Code is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Doom 3 Source Code.  If not, see <http://www.gnu.org/licenses/>.

In addition, the Doom 3 Source Code is also subject to certain additional terms. You should have received a copy of these additional terms immediately following the terms and conditions of the GNU General Public License which accompanied the Doom 3 Source Code.  If not, please request a copy in writing from id Software at the address below.

If you have questions concerning this license or the applicable additional terms, you may contact in writing id Software LLC, c/o ZeniMax Media Inc., Suite 120, Rockville, Maryland 20850 USA.

===========================================================================
*/

#include <sys/param.h>
#include <sys/ucontext.h>
#include <unistd.h>
#include <fenv.h>
#include <mach/thread_status.h>
//#include <AppKit/AppKit.h>
#include <UIKit/UIKit.h>

#include <SDL.h>
#include <SDL_main.h>

#include "sys/platform.h"
#include "idlib/Str.h"
#include "framework/Common.h"

#include "sys/posix/posix_public.h"

static SDL_Joystick *joystick = NULL;
static SDL_Haptic *joystick_haptic = NULL;
static SDL_GameController *controller = NULL;

// Joystick direction settings
static idCVar *joy_axis_leftx;
static idCVar *joy_axis_lefty;
static idCVar *joy_axis_rightx;
static idCVar *joy_axis_righty;
static idCVar *joy_axis_triggerleft;
static idCVar *joy_axis_triggerright;

// Joystick threshold settings
static idCVar *joy_axis_leftx_threshold;
static idCVar *joy_axis_lefty_threshold;
static idCVar *joy_axis_rightx_threshold;
static idCVar *joy_axis_righty_threshold;
static idCVar *joy_axis_triggerleft_threshold;
static idCVar *joy_axis_triggerright_threshold;

bool Sys_GetPath(sysPath_t type, idStr &path) {
	char buf[MAXPATHLEN];
	char *snap;

	switch(type) {
	case PATH_BASE:
#ifdef IOS
		strncpy(buf, [ [ [ NSBundle mainBundle ] resourcePath ] cString ], MAXPATHLEN );
#else
        strncpy(buf, [ [ [ NSBundle mainBundle ] bundlePath ] cString ], MAXPATHLEN );

        snap = strrchr(buf, '/');
		if (snap)
			*snap = '\0';
#endif

		path = buf;
		return true;

	case PATH_CONFIG:
	case PATH_SAVE:
		sprintf(buf, "%s/Library/Application Support/dhewm3", [NSHomeDirectory() cString]);
		path = buf;
		return true;

	case PATH_EXE:
		strncpy(buf, [ [ [ NSBundle mainBundle ] bundlePath ] cString ], MAXPATHLEN);
		path = buf;
		return true;
	}

	return false;
}

/*
===============
Sys_Shutdown
===============
*/
void Sys_Shutdown( void ) {
	Posix_Shutdown();
}

/*
================
Sys_GetSystemRam
returns in megabytes
================
*/
int Sys_GetSystemRam( void ) {
	SInt32 ramSize;

#ifdef IOS
    return 1024;
#else
	if ( Gestalt( gestaltPhysicalRAMSize, &ramSize ) == noErr ) {
		return ramSize / (1024*1024);
	}
	else
		return 1024;
#endif
}

#ifndef IOS
bool OSX_GetCPUIdentification( int& cpuId, bool& oldArchitecture )
{
	SInt32 cpu;
	Gestalt(gestaltNativeCPUtype, &cpu);

	cpuId = cpu;
	oldArchitecture = cpuId < gestaltCPU970;
	return true;
}

void OSX_GetVideoCard( int& outVendorId, int& outDeviceId )
{
	kern_return_t err;
	mach_port_t masterPort;
	io_iterator_t itThis;
	io_service_t service;

	outVendorId = -1;
	outDeviceId = -1;

	// Get a mach port for us and check for errors
	err = IOMasterPort(MACH_PORT_NULL, &masterPort);
	if(err)
		return;
	// Grab all the PCI devices out of the registry
	err = IOServiceGetMatchingServices(masterPort, IOServiceMatching("IOPCIDevice"), &itThis);
	if(err)
		return;

	// Yank everything out of the iterator
	// We could walk through all devices and try to determine the best card. But for now,
	// we'll just look at the first card.
	while(1)
	{
		service = IOIteratorNext(itThis);
		io_name_t dName;

		// Make sure we have a valid service
		if(service)
		{
			// Get the classcode so we know what we're looking at
			CFDataRef classCode =  (CFDataRef)IORegistryEntryCreateCFProperty(service,CFSTR("class-code"),kCFAllocatorDefault,0);
			// Only accept devices that are
			// PCI Spec - 0x00030000 is a display device
			if((*(UInt32*)CFDataGetBytePtr(classCode) & 0x00ff0000) == 0x00030000)
			{
				// Get the name of the service (hw)
				IORegistryEntryGetName(service, dName);

			    CFDataRef vendorID, deviceID;

				// Get the information for the device we've selected from the list
			    vendorID = (CFDataRef)IORegistryEntryCreateCFProperty(service, CFSTR("vendor-id"),kCFAllocatorDefault,0);
			    deviceID = (CFDataRef)IORegistryEntryCreateCFProperty(service, CFSTR("device-id"),kCFAllocatorDefault,0);

			    outVendorId = *((long*)CFDataGetBytePtr(vendorID));
			    outDeviceId = *((long*)CFDataGetBytePtr(deviceID));

				CFRelease(vendorID);
				CFRelease(deviceID);
			}
			CFRelease(classCode);

			// Stop after finding the first device
			if (outVendorId != -1)
				break;
		}
		else
			break;
	}
}

#endif

/*
===============
main
===============
*/
int SDL_main( int argc, char *argv[] ) {
	NSAutoreleasePool *pool;

	pool = [[NSAutoreleasePool alloc] init];

	if (![[NSFileManager defaultManager] changeCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]])
		Sys_Error("Could not access application resources");

	Posix_InitSignalHandlers(); // DG: added signal handlers for POSIX platforms

	if (argc > 1)
		common->Init(argc - 1, &argv[1]);
	else
		common->Init(0, NULL);
    
//    SDL_SetHint(SDL_HINT_ACCELEROMETER_AS_JOYSTICK, "0");
//    SDL_SetHint(SDL_HINT_TOUCH_MOUSE_EVENTS, "0");
    
    if (!SDL_WasInit(SDL_INIT_GAMECONTROLLER | SDL_INIT_HAPTIC))
    {
        if (SDL_Init(SDL_INIT_GAMECONTROLLER | SDL_INIT_HAPTIC) == -1)
        {
            common->Printf ("Couldn't init SDL joystick: %s.\n", SDL_GetError ());
        }
        else
        {
            // cribbed from elsewhere -tkidd
            
            common->Printf ("TAKE 2: %i joysticks were found.\n", SDL_NumJoysticks());
            
            if (SDL_NumJoysticks() > 0) {
                for (int i = 0; i < SDL_NumJoysticks(); i++) {
                    joystick = SDL_JoystickOpen(i);
                    
                    common->Printf ("The name of the joystick is '%s'\n", SDL_JoystickName(joystick));
                    common->Printf ("Number of Axes: %d\n", SDL_JoystickNumAxes(joystick));
                    common->Printf ("Number of Buttons: %d\n", SDL_JoystickNumButtons(joystick));
                    common->Printf ("Number of Balls: %d\n", SDL_JoystickNumBalls(joystick));
                    common->Printf ("Number of Hats: %d\n", SDL_JoystickNumHats(joystick));
                    
                    joystick_haptic = SDL_HapticOpenFromJoystick(joystick);
                    
                    if (joystick_haptic == NULL)
                    {
                        common->Printf("Most likely joystick isn't haptic\n");
                    }
                    else
                    {
                        //                            IN_Haptic_Effects_Info();
                    }
                    
                    if(SDL_IsGameController(i))
                    {
                        SDL_GameControllerButtonBind backBind;
                        controller = SDL_GameControllerOpen(i);
                        
                        common->Printf ("Controller settings: %s\n", SDL_GameControllerMapping(controller));
                        common->Printf ("Controller axis: \n");
//                        common->Printf (" * leftx = %s\n", joy_axis_leftx->GetString());
//                        common->Printf (" * lefty = %s\n", joy_axis_lefty->GetString());
//                        common->Printf (" * rightx = %s\n", joy_axis_rightx->GetString());
//                        common->Printf (" * righty = %s\n", joy_axis_righty->GetString());
//                        common->Printf (" * triggerleft = %s\n", joy_axis_triggerleft->GetString());
//                        common->Printf (" * triggerright = %s\n", joy_axis_triggerright->GetString());
//
//                        common->Printf ("Controller thresholds: \n");
//                        common->Printf (" * leftx = %f\n", joy_axis_leftx_threshold->GetFloat());
//                        common->Printf (" * lefty = %f\n", joy_axis_lefty_threshold->GetFloat());
//                        common->Printf (" * rightx = %f\n", joy_axis_rightx_threshold->GetFloat());
//                        common->Printf (" * righty = %f\n", joy_axis_righty_threshold->GetFloat());
//                        common->Printf (" * triggerleft = %f\n", joy_axis_triggerleft_threshold->GetFloat());
//                        common->Printf (" * triggerright = %f\n", joy_axis_triggerright_threshold->GetFloat());
                        
                        backBind = SDL_GameControllerGetBindForButton(controller, SDL_CONTROLLER_BUTTON_BACK);
                        
                        if (backBind.bindType == SDL_CONTROLLER_BINDTYPE_BUTTON)
                        {
//                            back_button_id = backBind.value.button;
//                            common->Printf ("\nBack button JOY%d will be unbindable.\n", back_button_id+1);
                        }
                        
                        //                            Cbuf_AddText(va("bind TRIG_RIGHT \"+attack\"\n"));
                        //                            Cbuf_AddText(va("bind JOY1 \"+movedown\"\n"));
                        //                            Cbuf_AddText(va("bind JOY2 \"+moveup\"\n"));
                        //                            Cbuf_AddText(va("bind JOY3 \"cmd help\"\n"));
                        //                            Cbuf_AddText(va("bind JOY5 \"weapnext\"\n"));
                        //                            Cbuf_AddText(va("bind JOY6 \"weapprev\"\n"));
                        
                        break;
                    }
                    else
                    {
                        char joystick_guid[256] = {0};
                        
                        SDL_JoystickGUID guid;
                        guid = SDL_JoystickGetDeviceGUID(i);
                        
                        SDL_JoystickGetGUIDString(guid, joystick_guid, 255);
                        
                        common->Printf ("To use joystick as game controller please set SDL_GAMECONTROLLERCONFIG:\n");
                        common->Printf ("e.g.: SDL_GAMECONTROLLERCONFIG='%s,%s,leftx:a0,lefty:a1,rightx:a2,righty:a3,back:b1,...\n", joystick_guid, SDL_JoystickName(joystick));
                    }
                }
            }
        }
    }

#ifndef IOS
	[NSApp activateIgnoringOtherApps:YES];
#endif

	while (1) {
		common->Frame();

		// We should think about doing this less frequently than every frame
		[pool release];
		pool = [[NSAutoreleasePool alloc] init];
	}

	[pool release];
}

