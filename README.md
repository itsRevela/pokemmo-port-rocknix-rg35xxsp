# PokeMMO Port for PortMaster on Rocknix/Knulli with RG35XXSP

PokeMMO is a fan-made multiplayer online game that brings together multiple generations of Pokémon in a single MMO experience.
This fork provides some support for the RG35XXSP and similar devices that do not have analog controls. If you have a question or issue not related to controls, please reach out on the main fork https://github.com/lowlevel-1989/pokemmo-port

---

## 🛠 Installation Instructions

[![Installation Video for RG35XXSP](https://img.youtube.com/vi/hSXAO46nL8w/0.jpg)](https://youtu.be/hSXAO46nL8w)


### CFW Tests:

|                        | 480x320 | 640x480 | 720x720 | Higher resolutions |
|------------------------|---------|---------|---------|--------------------|
| Playable?              | No      | Yes     | Yes     | Yes                |
| Create new character?  | No      | No      | Yes     | Yes                |
| All regions?           | No      | Yes     | Yes     | Yes                |

~~~
- [x] ArkOS
- [x] Rocknix
    -> [x] Panfrost
    -> [x] Libmali
- [x] MuOS
- [x] Knulli
~~~

### 1. Install/Update the Port

Download pokemmo.zip Place the `.zip` into:  
`/PortMaster/autoinstall`

Launch **PortMaster**. It will automatically install the port.

---

### 2. Add Official PokeMMO Client Files

Go to the official PokeMMO website:  
[https://pokemmo.com/en/downloads/portable](https://pokemmo.com/en/downloads/portable)

Download the **portable version**, extract it, and copy these into:  
`/roms/ports/PokeMMO/`

- `PokeMMO.exe`  
- `data/` folder

⚠️  Make sure not to replace the existing shaders folder and main.properties, as it contains optimized shaders.
Replacing them may negatively impact performance on low-end devices.

---

### 3. Add Required and Optional ROMs

To add the ROMs, place them inside the PokeMMO/roms folder and set the following values in `main.properties`:
~~~
client.roms.nds=roms/pokemon_black.nds  
client.roms.em=roms/pokemon_emerald.gba  
client.roms.fr=roms/pokemon_firered.gba  
client.roms.nds2=roms/pokemon_platinum.nds  
client.roms.nds3=roms/pokemon_heartgold.nds
~~~

**Required ROM:**  
- Pokémon Black or White (Version 1)

**Optional ROMs (enable more regions):**  
- Fire Red  
- Emerald  
- Platinum  
- HeartGold / SoulSilver

---

🎮 HOW TO USE THE VIRTUAL KEYBOARD & MOUSE 🎮

🖱️ MOUSE MODE:
• Hold [L1] to control the mouse
• Use the D-Pad to move the cursor
• Press [R1] for left-click
• Press [R2] for right-click
• Release [L1] to exit mouse mode

⌨️ TYPING MODE:
• Enter typing mode: Hold [L1], tap [L2], then release both
• Use D-Pad Up/Down to scroll through letters or numbers
• Press [B] or [Y] to insert a character
• Press [X] or [Y] to insert a space
• Press [A] to delete (backspace)
• Press [Start] to finish typing and exit

🔤 SWITCH CHARACTERS:
• Press [X] to switch between lowercase (abc) and uppercase (ABC)
• Press [Back] to switch between letters (abc/ABC) and numbers (123)

✅ EXIT TYPING:
• Just press [Start] once — works from any typing mode

#### Controller Support Status

Only the version with `gptokeyb2` supports the virtual keyboard.

---

## Thanks

- Jeod
- BinaryCounter
- ddrsoul
- lil gabo
- Fran
- rttn
- zerchu
- Ganimoth
- antiNT
- cuongnv1312

## Refs

- Official site: [https://pokemmo.com](https://pokemmo.com)  
- Port suggestion on PortMaster: [View Suggestion](https://suggestions.portmaster.games/suggestion-details?id=ab4f9b6b87314eba96536a86804d7235)
---
