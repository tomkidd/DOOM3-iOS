#  DOOM 3 for iOS and tvOS for Apple TV

This is my port of DOOM 3 for iOS, running in modern resolutions including the full width of the iPhone X. I have also made a target and version for tvOS to run on Apple TV.

Features

- Tested and builds on Xcode 10.
- Runs single player campaigns at full screen and full speed on iOS
- Support for original campaign and expansion pack campaigns via separate apps.
- MFi controller support (reccomended) and on-screen control options
- Second project target for tvOS that takes advantage of focus model and removes on-screen controls.
- Limited support for native menus of original game

This commit does not need any placeholder resources as it is not an update of an existing id Software port. 

**NOTE: this is a port of the *original* DOOM 3 from 2004, not the DOOM 3: BFG Edition from 2012**

You will need to provide your own copies of the `base` and `d3xp` directories from an existing instalation of DOOM 3. The latter directory is only needed if you want to run the expansion. You can buy *DOOM 3* on Steam [here](https://store.steampowered.com/app/9050/DOOM_3/). You can buy the expansion pack *DOOM 3: Resurrection of Evil* on Steam [here](https://store.steampowered.com/app/9070/DOOM_3_Resurrection_of_Evil/). Note that GOG does not sell the original game, they only sell the *BFG Edition* which is incompatible with this release. 

There are two Xcode project files, one for DOOM 3, `DOOM3-iOS.xcodeproj`, and one for the expansion pack, `DOOM3xp-iOS.xcodeproj`. You will need to drag your directories into the project and select "Create Folder References". The `base` folder needs to be added to the DOOM 3 project and target, while both the `base` and `d3xp` folders need to be added to the expansion pack project. The folders will be blue if you've done it right:

![folders](https://github.com/tomkidd/DOOM3-iOS/raw/master/folders.png)

![foldersxp](https://github.com/tomkidd/DOOM3-iOS/raw/master/foldersxp.png)

You can read a lengthy blog article on how I did all this [here](http://schnapple.com/doom-3-for-ios-and-tvos-for-apple-tv/).

This port was based on [dhewm3](https://dhewm3.org/) and uses [SDL for iOS](https://www.libsdl.org/). I also referenced to [this fork for WebAssembly/WebGL](https://github.com/gabrielcuvillier/d3wasm) from Gabriel Cuvillier for OpenGL ES code. On-screen joystick code came from [this repo](https://github.com/bradhowes/Joystick) by Brad Howe. Font Diablo Heavy available [here](https://fontzone.net/font-details/diablo-heavy). I also studied the iOS port of [Hedgewars](https://github.com/hedgewars/hw) for information on how to use UIKit alongside SDL.

[Video of DOOM 3 running on an iPhone X](https://www.youtube.com/watch?v=KEaeWKSfgB8)

<!--[Video of DOOM 3 running on an Apple TV](https://www.youtube.com/watch?v=jjO2pAVgb84)-->

Have fun. For any questions I can be reached at tomkidd@gmail.com
