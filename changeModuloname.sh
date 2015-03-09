#!/bin/bash
use () 
{
        echo "Use: $0 newname_for_the_module [current_name]"
}

if [ -z $1 ]
then
        echo "Missing new name. Exiting.."
        use
        exit 255
fi
if [ -z $2 ]
then
        current_name="basicpuppettemplate"
else
        current_name=$2
fi        

new_name=$1
echo "Renaming module in file contents.."
find ./ -type f | xargs sed -i s/"$current_name"/"$new_name"/g
echo "Renaming module directory.."
cd ..
mv $current_name $new_name
cd $new_name
