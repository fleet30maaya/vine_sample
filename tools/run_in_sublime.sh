if [ ! $# == 1 ]; then
	echo "Please enter project path"
	exit
fi
echo $1
rm -r $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/src
rm -r $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/res
cp -R $1/res $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/
cp -R $1/src $1/runtime/mac/vineSample' 'Mac.app/Contents/Resources/

$1/runtime/mac/vineSample' 'Mac.app/Contents/MacOS/vineSample' 'Mac