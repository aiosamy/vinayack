export CHAT_CONTACT_FOR_DEVICE2="${CHAT_CONTACT_FOR_DEVICE2:-"TestDevice2"}"
for file in features/templates/*.tpl
do
	basename=$(basename "$file")
	name="${basename%.*}"
	sed 's/<CHAT_CONTACT_FOR_DEVICE2>/'"$CHAT_CONTACT_FOR_DEVICE2"'/g' $file >features/$name.feature
done
