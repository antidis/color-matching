# README

Based on Scott Burns' work here: http://scottburns.us/subtractive-color-mixture/

Uses the `color-rgb` gem from here: https://github.com/apartmenttherapy/color-rgb

Any problems are likely down to my own errors. Under MIT license.

Sample use:

```
> ruby color.rb bbc2c7
Nearest colors:
0: #c6c6c6 Grey Seer
1: #b0c2d8 Blue Horror
2: #9baeae Celestra Grey
3: #d3e3de Ulthuan Grey

Closest mixes:
D1.4224412655616998 (not noticeably different): #bec4cb = 2:1 Grey Seer:Blue Horror
D1.5603889151773425 (not noticeably different): #c0c4ca = 3:1 Grey Seer:Blue Horror
D1.7550401205032922 (not noticeably different): #c1c5c9 = 4:1 Grey Seer:Blue Horror
D2.2832789539106275 (not noticeably different): #bcc4cd = 3:2 Grey Seer:Blue Horror
D3.2852663789708987: #bac3ce = 1:1 Grey Seer:Blue Horror
```
