# README

Based on Scott Burns' work here: http://scottburns.us/subtractive-color-mixture/

Uses the `color-rgb` gem from here: https://github.com/apartmenttherapy/color-rgb

Any problems are likely down to my own errors. Under MIT license.

## Sample use:

### Finding a match for Vallejo Model Air 71.120 Dark Ghost Grey

```
% ruby color.rb bbc2c7
This software is somewhat vocal about its internal work, but could take some time


Checking mixes with Grey Seer
...................................................
Checking mixes with Blue Horror
..............................................................................
Checking mixes with Celestra Grey
..................................................................................................
Checking mixes with Ulthuan Grey
.......................................................................................
Checking mixes with Deepkin Flesh
...................................................................................................

NEAREST COLORS:

c6c6c6: (D: 4.0835) Grey Seer
b0c2d8: (D: 9.709) Blue Horror
9baeae: (D: 9.8626) Celestra Grey
d3e3de: (D: 12.5614) Ulthuan Grey
deded2: (D: 13.7205) Deepkin Flesh

BEST TWO COLOR MIXES:

b9c1c6: (D: 0.5664) Blue Horror:Flayed One Flesh 9:2 (PERCEPTUALLY THE SAME)
bac1c7: (D: 0.6355) Ulthuan Grey:Naggaroth Night 8:1 (PERCEPTUALLY THE SAME)
bac1c5: (D: 0.6621) Blue Horror:Flayed One Flesh 4:1 (PERCEPTUALLY THE SAME)
bcc4c9: (D: 0.7415) Ulthuan Grey:Naggaroth Night 9:1 (PERCEPTUALLY THE SAME)
bac0c4: (D: 0.9268) Grey Seer:Fenrisian Grey 7:1 (PERCEPTUALLY THE SAME)

BEST THREE COLOR MIXES:

bbc2c7: (D: 0.0) Corax White:Celestra Grey:Daemonette Hide 10:7:2 (EXACT)
bbc2c7: (D: 0.0) Blue Horror:Grey Seer:Morghast Bone 6:6:1 (EXACT)
bbc2c7: (D: 0.0) Ulthuan Grey:Naggaroth Night:Grey Seer 8:1:1 (EXACT)
bbc2c7: (D: 0.0) Ulthuan Grey:Daemonette Hide:Grey Seer 7:2:2 (EXACT)
bbc2c7: (D: 0.0) Blue Horror:Grey Seer:Flayed One Flesh 10:3:2 (EXACT)
```

### Finding a match for Vallejo Model Air 71.088 French Blue

```
% ruby color.rb 1f4e7a
This software is somewhat vocal about its internal work, but could take some time


Checking mixes with Alaitoc Blue
.............................................................
Checking mixes with Night Lords Blue
..............................................................................................................................................
Checking mixes with Caledor Sky
...................................................................................................................
Checking mixes with Stegadon Scale Green
......................................................................................................................
Checking mixes with Thousand Sons Blue
...................................................................................................................

NEAREST COLORS:

305688: (D: 5.5555) Alaitoc Blue
043660: (D: 10.4102) Night Lords Blue
3a679b: (D: 11.1419) Caledor Sky
014360: (D: 11.5656) Stegadon Scale Green
025573: (D: 12.097) Thousand Sons Blue

BEST TWO COLOR MIXES:

1e4d7a: (D: 0.831) Stegadon Scale Green:Genestealer Purple 6:5 (PERCEPTUALLY THE SAME)
1c4c78: (D: 0.8632) Stegadon Scale Green:Genestealer Purple 4:3 (PERCEPTUALLY THE SAME)
1f4d7a: (D: 0.8854) Stegadon Scale Green:Genestealer Purple 7:6 (PERCEPTUALLY THE SAME)
194e7a: (D: 0.9364) Night Lords Blue:Fulgrim Pink 9:4 (PERCEPTUALLY THE SAME)
1e507c: (D: 0.9881) Alaitoc Blue:Stegadon Scale Green 3:1 (PERCEPTUALLY THE SAME)

BEST THREE COLOR MIXES:

1f4e7a: (D: 0.0) Night Lords Blue:Blue Horror:Pink Horror 6:3:1 (EXACT)
1f4e7a: (D: 0.0) Alaitoc Blue:Night Lords Blue:Slaanesh Grey 7:5:2 (EXACT)
1f4e7a: (D: 0.0) Night Lords Blue:Caledor Sky:Daemonette Hide 10:7:6 (EXACT)
1f4e7a: (D: 0.0) Alaitoc Blue:Night Lords Blue:Russ Grey 8:5:3 (EXACT)
1f4e7a: (D: 0.0) Alaitoc Blue:Night Lords Blue:Slaanesh Grey 9:7:3 (EXACT)
```

### Finding a match for a wholly blue color

```
% ruby color.rb 0000aa
This software is somewhat vocal about its internal work, but could take some time


Checking mixes with Altdorf Guard Blue

Checking mixes with Phoenician Purple
...........................
Checking mixes with Genestealer Purple

Checking mixes with Xereus Purple
.......................................................
Checking mixes with Macragge Blue
................................

NEAREST COLORS:

2a4b9b: (D: 54.7057) Altdorf Guard Blue
471352: (D: 58.1386) Phoenician Purple
7c5ba3: (D: 60.0896) Genestealer Purple
4b225b: (D: 60.5372) Xereus Purple
193a79: (D: 61.3397) Macragge Blue

BEST TWO COLOR MIXES:

382c7a: (D: 47.9712) Altdorf Guard Blue:Phoenician Purple 5:3
382d7b: (D: 48.1207) Altdorf Guard Blue:Phoenician Purple 7:4
3a2976: (D: 48.1743) Altdorf Guard Blue:Phoenician Purple 4:3
363180: (D: 48.2378) Altdorf Guard Blue:Phoenician Purple 7:3
3a2a77: (D: 48.294) Altdorf Guard Blue:Phoenician Purple 10:7

BEST THREE COLOR MIXES:

3c2e7c: (D: 48.2569) Altdorf Guard Blue:Phoenician Purple:Genestealer Purple 8:5:1
3b2e7c: (D: 48.2588) Altdorf Guard Blue:Phoenician Purple:Genestealer Purple 10:6:1
412f7d: (D: 48.4175) Altdorf Guard Blue:Phoenician Purple:Genestealer Purple 10:7:3
402b78: (D: 48.4876) Altdorf Guard Blue:Phoenician Purple:Genestealer Purple 8:7:2
3f307e: (D: 48.5553) Altdorf Guard Blue:Phoenician Purple:Genestealer Purple 8:5:2
```
