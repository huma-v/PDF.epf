#! /bin/bash

# Requires curl, unzip, zip, patch
# before running also install node.js lts/fermium (nvm recommended) and gulp-cli

die() { echo "$*" 1>&2 ; exit 1; }

if [ ! -f pdf.js-2.6.347.zip ]; then
    # last version to support IE
    curl -Lo pdf.js-2.6.347.zip "https://github.com/mozilla/pdf.js/archive/refs/tags/v2.6.347.zip" || die "Failed to download PDF.js!"
fi

if [ ! -d "pdf.js-2.6.347" ]; then
    unzip -q pdf.js-2.6.347.zip || die "Failed to extract PDF.js!"

    pushd pdf.js-2.6.347 > /dev/null
    PUPPETEER_SKIP_DOWNLOAD=1 npm install || die "npm install failure!"
    patch -p1 < ../adapt_for_1c.patch
    gulp minified-es5 || die "Build failure!"
    popd > /dev/null
fi

rm -r resources
cp -r "pdf.js-2.6.347/build/minified-es5" resources || die "Couldn't copy the build directory!"

# Cleaning up, IE wont be able to make use of those files anyway
rm resources/{build,web,image_decoders}/*.map
rm -r resources/web/{cmaps,locale}
mv "resources/web/compressed.tracemonkey-pldi-09.pdf" sample.pdf

rm resources.zip
pushd resources > /dev/null
zip -q -r ../resources.zip * || die "Failed to compress the resources package!"
popd > /dev/null
