# Deck

Window theme for Xfwm/Xfce.
Small update of theme [Microdeck2](http://xfce.org) 

+ Sharp corners instead of rounded.
+ Adjusted vertical alignment of title.
+ PNG overlay **Xfwm version 4.2**
+ Removed gradient pattern on inactive window

Future plans:

+ Adjusted colors
+ Prelight button state

## Build

### Pre requirements

+ Xcftools1.0.7
+ Imagemagick6.7.8
+ libPNG


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

