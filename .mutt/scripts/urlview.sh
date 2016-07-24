#!/bin/bash
# array of filters, to be moved to external file later
url_filters=('/lists.dragonflybsd.org\/\(mailman\|pipermail\)/d' '/<mailto:commits.*@dragonflybsd.org.*>/d' )
# url_filters=('p' )
filtering='sed '
for f in ${url_filters[*]}; do
    filtering+="-e $f "
done
mail_body=$(cat|$filtering)

echo $mail_body|urlview
