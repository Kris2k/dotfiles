XPTemplate priority=personal+

let s:f = g:XPTfuncs()

XPTinclude
      \ _common/common


XPT once wrap	" #ifndef .. #define ..
XSET symbol=headerSymbol()
XSET symbol|post=UpperCase(V())
#ifndef `symbol^
#define `symbol^

`cursor^
#endif `$CL^ `symbol^ `$CR^

XPT inc alias=#include_user

XPT beerware " beerware licence 
XSET cursor|pre=CURSOR
/**
 * @file        :  `file()^ 
 * @author      :  `$author^ | `$email^
 * @description :
 * @Copyrigths  :  `date()^
 * 
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <`$email^> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return `$author^. 
 *     `cursor^
 * 
 */

XPT kelvatek " kelvatek licence
/**
 * @file        :  `file()^ 
 * @author      :  `$kelvatek_author^ | `$kelvatek_email^
 * @Company     :  Kelvatek 
 * @Copyrigths  :  Kelvatek  `strftime("%Y")^
 * @description : `cursor^ 
 *
 */

