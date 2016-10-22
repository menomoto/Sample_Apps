#!/bin/bash

renameDirectories () {
	for i in `find . -name \*$oldProject\* -type dir`
	do
		oldFile=$i
		newFile=`echo $i | sed -e s/$oldProject/$newProject/g`
		echo "mv $oldFile $newFile"
		mv $oldFile $newFile
	done
}

renameFiles () {
	for i in `find . -name \*$oldProject\* -type file`
	do
		oldFile=$i
		newFile=`echo $i | sed -e s/$oldProject/$newProject/g`
		echo "mv $oldFile $newFile"
		mv $oldFile $newFile
	done
}

renameWords () {
	for i in `grep -slr $oldProject *`
	do
		echo $i
		sed -i '' "s/$oldProject/$newProject/g" $i
	done
}

main () {
	oldProject=$1
	newProject=$2

	cp -pr $oldProject $newProject
	cd $newProject

	renameDirectories
	renameFiles
	renameWords

	cd ..
}

main $1 $2
exit
