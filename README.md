# Deck

Window theme for Xfwm/Xfce.
Small update of theme [Microdeck2](http://) 

+ Sharp corners instead of the rounded.
+ Adjusted vertical alignment of title.
+ PNG overlay

Future:

+ Adjusted colors
+ 1px smaller bottom bar
+ Hover buttons

## Build

### Pre requirements

Xcftools // I have version 1.0.7 and it complaines about not supporting current xcf version but works anyways.
Imagemagick // I have version 6.7.8.
Make sure you have libpng installed as well.


```bash
> cd Deck
> chmod 755 Build.sh
> ./Build.sh
```

## Install

If the builder did not ask you already.

```bash
> mkdir -p ~/.themes/Deck/xfwm4 && cp dist/xfwm4/* ~/.themes/Deck/xfwm4/.
```
## License

