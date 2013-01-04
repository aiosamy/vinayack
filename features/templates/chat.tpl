Feature: Chat Feature

Scenario: As a valid user I can chat with my joyn contact
Given joyn app is running on the first device
Then I cleanup all chat history in the first device
Then I take a screenshot in the first device

And also in Second Device joyn app is running
Then I cleanup all chat history in the second device
Then I take a screenshot in the second device
Then I put the Joyn app in background in the second device
Then I take a screenshot in the second device

When I see the contact '<CHAT_CONTACT_FOR_DEVICE2>' in joyn contacts list of the first device
Then I send a chat message 'first joyn chat message' to the contact '<CHAT_CONTACT_FOR_DEVICE2>'
Then I take a screenshot in the first device

When I wait to see the Joyn Chat Notification message in the second device
Then I take a screenshot in the second device
When I open the notification message to read the chat message in the second device
Then I should see the message 'first joyn chat message' in the second device
Then I send 'first joyn chat message ack'as a response in the second device
Then I take a screenshot in the second device

Then I wait to see message 'first joyn chat message ack' in the first device
Then I take a screenshot in the first device