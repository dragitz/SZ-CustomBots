# SZ-CustomBots
UE4SS Mod that allows the creation of custom bots for Sparking Zero

Currently in prototype mode for modders only

# Setup
1) Get ue4ss experimental https://github.com/UE4SS-RE/RE-UE4SS/releases and place it here

>  ``\DRAGON BALL - Sparking! ZERO\SparkingZERO\Binaries\Win64``

2) Enter the ``Mods`` folder and create a new one called ``CustomBots``
3) Then make a new folder in ``CustomBots`` called ``Scripts``
4) place ``main.lua`` in the ``Scripts`` folder
5) Open ``mods.txt`` and add ``CustomBots : 1`` below ``BPModLoaderMod``

You are tecnically done, to get the function names you need to dump the ``CXX headers``
To do so, open ``UE4SS-settings.ini`` and change the following to ``1`` 
```ini
GuiConsoleEnabled = 1
GuiConsoleVisible = 1
```
Run the game and a new console gui/window will open, go into the ``Dumpers`` tab and press ``Dump CXX Headers``, a new folder named ``CXXHeaderDump`` will be created.

The two most important files are ``SS.hpp`` and ``SS_enums.hpp``, do a search and look for ``class ASSCharacter : public ACharacter`` <-- there will be all the info you need about the characters

Happy modding ``¯\_(ツ)_/¯`` 
