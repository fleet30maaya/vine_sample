if [ ! $# == 1 ]; then
	echo "Please enter project path"
	exit
fi
echo $1
rm -r $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/src
rm -r $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/res
cp -R $1/res $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/
cp -R $1/src $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/

#key: 2dxLua
#sign: XXTEA
#/Users/maAya/SDK/cocos2d-x-3.3rc0/tools/cocos2d-console/bin/cocos luacompile -s $1/src -d $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/src -e True -k 2dxLua -b XXTEA

$1/runtime/mac/vineSample' 'Mac.app/Contents/MacOS/vineSample' 'Mac