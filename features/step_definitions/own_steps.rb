Given /^joyn app is running on the first device$/ do
$device=1
setKPIIdentifier() 
      performAction('wait_for_view_by_id','contacts_toggle_filter_txtview', true)
     waitTillViewIsShown('contacts_toggle_filter_txtview', 120)
    elapsedTime = Time.now.to_f - $startTime
   puts "KPI-For-Nagios: joyn;Startup|Startup time for app till the joyn contacts being displayed in the first device;opco="+$opco1_str+";imsi="+$imsi1_str+"; time="+elapsedTime.to_s+"s"
end

Then /^I cleanup all chat history in the first device$/ do
$device=1
performAction('wait_for_view_by_id','contacts_toggle_filter_txtview')
performAction('select_from_menu', 'Delete all messages')
performAction('wait_for_text', 'Yes')
performAction('click_on_text', 'Yes')
begin
        r = performAction('read_text_for_view_by_id','contacts_toggle_filter_txtview')
        current = r["bonusInformation"].to_s
 current = current.gsub!(/^\[|\"|\]/, '')
     end while ( current != 'joyn contacts' ) and performAction('click_on_view_by_id','contacts_toggle_filter_btn')
end

Then /^I take a screenshot in the first device$/ do
$device=1
screenshot_embed
end

And /^also in Second Device joyn app is running$/ do
$device=2
uninstall_apps
install_app(ENV["TEST_APP_PATH"])
$startTime = Time.now.to_f
start_test_server_in_background
setKPIIdentifier()
        performAction('wait_for_view_by_id','contacts_toggle_filter_txtview', true)
     waitTillViewIsShown('contacts_toggle_filter_txtview', 120)
    elapsedTime = Time.now.to_f - $startTime
   puts "KPI-For-Nagios: joyn;Startup|Startup time for app till the joyn contacts being displayed in the second device;opco="+$opco2_str+";imsi="+$imsi2_str+"; time="+elapsedTime.to_s+"s"
end


Then /^I cleanup all chat history in the second device$/ do
$device=2
performAction('wait_for_view_by_id','contacts_toggle_filter_txtview')
performAction('select_from_menu', 'Delete all messages')
performAction('wait_for_text', 'Yes')
performAction('click_on_text', 'Yes')
 begin
        r = performAction('read_text_for_view_by_id','contacts_toggle_filter_txtview')
        current = r["bonusInformation"].to_s
 current = current.gsub!(/^\[|\"|\]/, '')
     end while ( current != 'joyn contacts' ) and performAction('click_on_view_by_id','contacts_toggle_filter_btn')
end


Then /^I put the Joyn app in background in the second device$/ do
$device=2 
performAction('go_back')
# clearing notification event log in device 2
system 'adb -s $ADB_DEVICE_ARG2  logcat -b events -c'
end


When /^I see the contact '(.*)' in joyn contacts list of the first device$/ do |device2|
$device=1
#while  (true == performAction('assert_text',device2,true))
#performAction('scroll_down')
#end
performAction('wait_for_text', device2)
end

Then /^I send a chat message '(.*)' to the contact '(.*)'$/ do |message1,device2|
$device=1
performAction('click_on_text', device2)
performAction('wait_for_view_by_id','contactcard_entry_text2')
performAction('click_on_view_by_id','contactcard_entry_text2')
performAction('wait_for_view_by_id','chat_composer')
performAction('enter_text_into_id_field',message1,'chat_composer')
performAction('wait_for_view_by_id','chat_send_button')
performAction('click_on_view_by_id','chat_send_button')
setKPIIdentifier()
$startTime = Time.now.to_f
end

Then /^I wait to see the ack sign$/ do
$device=1 
 begin

count = 1
info1 = 'NOT'
until info1.include?'FOUND'
    puts info1
    r = performAction('isJoynCheckBoxPresent')
    info = r["bonusInformation"]
    if info != nil then
        info1 = info.to_s
    end

    timeoutInSec=20
    unitInSec=10
    sleep(1.0/unitInSec)
    if count >= (timeoutInSec*unitInSec)
        puts 'Joyn chat message delivery notification did not recived in 20 seconds'
        performAction('time_out_exit',1)
		exit
    else
        count = count + 1
    end

end
puts info1
end
end 


When /^I wait to see the Joyn Chat Notification message in the second device$/ do
$device=2
count = 1
value =""
while  (value == "")
value=`adb -s $ADB_DEVICE_ARG2 logcat -b events -d  -v threadtime |grep com.summit.beam |grep notification_enqueue |grep flags=0x10`
sleep(1.0/5.0)
if count == 100
puts 'Joyn notification did not received in 20 seconds'
performAction('time_out_exit',1)
else
count = count + 1
end 
end
  elapsedTime = Time.now.to_f - $startTime
   puts "KPI-For-Nagios: Joyn notification message|Time elapsed between send msg in first device and received notification in second;opco="+$opco2_str+";imsi="+$imsi2_str+"; time ="+elapsedTime.to_s+"s"
end

Then /^I take a screenshot in the second device$/ do
$device=2
screenshot_embed
end

When /^I open the notification message to read the chat message in the second device$/ do
$device=2
system 'monkeyrunner Notification.py TestDevice1 $ADB_DEVICE_ARG2'
end

Then /^I should see the message '(.*)' in the second device$/ do |message2|
$device=2
performAction('wait_for_text', message2)
performAction('assert_text',message2, true)
end

Then /^I send '(.*)'as a response in the second device$/ do |message3|
$device=2
performAction('enter_text_into_id_field',message3,'chat_composer')
performAction('wait_for_view_by_id','chat_send_button')
performAction('click_on_view_by_id','chat_send_button')
setKPIIdentifier()
$startTime = Time.now.to_f
end


Then /^I wait to see message '(.*)' in the first device$/ do |message4|
$device=1
performAction('wait_for_text', message4)
    elapsedTime = Time.now.to_f - $startTime
   puts "KPI-For-Nagios: Joyn message recived|Time elapsed between send msg in second device and received it in first;opco="+$opco1_str+";imsi="+$imsi1_str+"; time ="+elapsedTime.to_s+"s"
performAction('assert_text',message4, true)
end

def waitTillViewIsShown(viewId, timeOut)
    endTime = Time.now.to_f + timeOut.to_f
    begin
        r = performAction('read_visibility_for_view_by_id', viewId)
        info = r["bonusInformation"].to_s
        sleep 0.2
    end while info == 'false' && Time.now.to_f < endTime.to_f
    if info == 'false' then
        macro 'I take a screenshot'
        assert(false ,'View with id ' + viewId + ' was not able to show up in time')
    end
    return false
end

def setKPIIdentifier()
    result = performAction('get_imsi')
    imsi = result["bonusInformation"].to_s
    imsi = imsi.gsub!(/^\[|\"|\]/, '')
    if $device == 1 then
        $opco1_str = getOpco(imsi)
        $imsi1_str = imsi
    elsif $device == 2 then
        $opco2_str = getOpco(imsi)
        $imsi2_str = imsi
    end
end

def getOpco(imsi)
    case imsi[0,3]
        when '262'
            return 'de'
        when '268'
            return 'pt'
        when '222'
            return 'it'
        when '204'
            return 'nl'
        when '214'
            return 'es'
        when '234' || '235'
            return 'gb'
        when '272'
            return 'ir'
        when '202'
            return 'gr'
        else
            return 'no_opco'
    end
end
